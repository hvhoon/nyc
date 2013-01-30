//
//  Created by nick on 20/09/11.
//
//  To change this template use File | Settings | File Templates.
//


#import "JMCMacros.h"
#import "JMCRequestQueue.h"
#import "JMCIssueTransport.h"
#import "JMCReplyTransport.h"
#import "JMCCreateIssueDelegate.h"
#import "JMCReplyDelegate.h"
#import "Reachability.h"
#import "JMC.h"
#import "JMCTransportOperation.h"

static NSOperationQueue *sharedOperationQueue = nil;

#define KEY_NUM_ATTEMPTS @"numAttempts"
#define KEY_SENT_STATUS @"sentStatus"
#define KEY_UPDATED_AT @"updatedAt"

@interface JMCRequestQueue ()
- (NSString *)getQueueIndexPath;

- (NSString *)getQueueDirPath;

- (NSString *)getQueueItemPathFor:(NSString *)uuid;

- (void)saveQueueIndex:(NSMutableDictionary *)queueList;

- (NSMutableDictionary *)getQueueList;

- (void) doFlushQueue:(NSTimer*) timer;

@end

JMCIssueTransport* _issueTransport;
JMCReplyTransport* _replyTransport;
NSRecursiveLock* _flushLock;
int _maxNumRequestFailures;

@implementation JMCRequestQueue {

}

+ (JMCRequestQueue *)sharedInstance
{
    static JMCRequestQueue *instance = nil;
    if (instance == nil) {
        instance = [[JMCRequestQueue alloc] init];
        sharedOperationQueue = [[NSOperationQueue alloc] init];
        [sharedOperationQueue setMaxConcurrentOperationCount:1];
        _issueTransport = [[JMCIssueTransport alloc] init];
        _replyTransport = [[JMCReplyTransport alloc] init];
        _issueTransport.delegate = [[[JMCCreateIssueDelegate alloc]init] autorelease];
        _replyTransport.delegate = [[[JMCReplyDelegate alloc] init] autorelease];
        _flushLock = [[NSRecursiveLock alloc] init];
        _maxNumRequestFailures = 50;
        JMCDLog(@"queue at  %@", [instance getQueueIndexPath]);
        [instance resetAllInProgress];

    }
    return instance;
}

-(void) flushQueue
{
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(doFlushQueue:) userInfo:nil repeats:NO];
}

- (void)resetAllInProgress
{
    @synchronized (_flushLock) {
        NSMutableDictionary *items = [self getQueueList];

        for (NSString *itemId in [items allKeys]) {
            JMCQueueItem *item = [self getItem:itemId];

            // Get metadata and check if empty
            NSDictionary *metadata = [self metaDataFor:itemId];
            if (!metadata) {
                continue;
            }
            JMCSentStatus sentStatus = [[metadata valueForKey:KEY_SENT_STATUS] intValue];
            if (sentStatus == JMCSentStatusInProgress)
            {
                JMCDLog(@"Resetting request to retry from in-progress %@",itemId)
                [self updateItem:itemId sentStatus:JMCSentStatusRetry bumpNumAttemptsBy:0];
            }
        }
    }

}


-(void)doFlushQueue:(NSTimer*) timer
{
    // Ensure a single thread at a time tries to flush the queue.
    @synchronized (_flushLock) { 
        NSMutableDictionary *items = [self getQueueList];        
        
        for (NSString *itemId in [items allKeys]) {
            JMCQueueItem *item = [self getItem:itemId];
            
            // Get metadata and check if empty
            NSDictionary *metadata = [self metaDataFor:itemId];
            if (!metadata) {
                continue;
            }

            // Check permanent error
            JMCSentStatus sentStatus = [[metadata valueForKey:KEY_SENT_STATUS] intValue];
            if (sentStatus == JMCSentStatusPermError) {
                JMCALog(@"Deleting queued item as sent status shows permanent error: %@.", itemId);
                [self deleteItem:itemId];
                continue;
            }
            
            // Check if in progress (timeout after 2 minutes)
            if ((sentStatus == JMCSentStatusInProgress) && ([[metadata objectForKey:KEY_UPDATED_AT] timeIntervalSinceNow] > -2 * 60)) {
                JMCALog(@"Ignored queued item as send process is in progress: %@.", itemId);
                continue;
            }
            
            // Set to in progess
            [self updateItem:itemId sentStatus:JMCSentStatusInProgress bumpNumAttemptsBy:0];
            
            // Create operation according to type
            NSOperation *operation = nil;
            if ([item.type isEqualToString:kTypeReply]) {
                operation = [_replyTransport requestFromItem:item];
            } 
            else if ([item.type isEqualToString:kTypeCreate]) {
                operation = [_issueTransport requestFromItem:item];
            }
            
            if (operation == nil) {
                JMCALog(@"Missing or invalid queued item with id: %@. Removing from queue.", itemId);
                [self deleteItem:itemId];
            } 
            else {
                [sharedOperationQueue addOperation:operation];
                JMCDLog(@"Added request to operation queue %@", item.uuid);
            }
        }
    }
}

-(NSDictionary *) metaDataFor:(NSString *)uuid
{
    NSMutableDictionary *queueIndex = [self getQueueList];
    return [queueIndex objectForKey:uuid];
}
                
-(JMCSentStatus) requestStatusFor:(NSString *)uuid
{
    NSDictionary *metadata = [self metaDataFor:uuid];
    if (metadata) {
        NSNumber *status = [metadata objectForKey:KEY_SENT_STATUS];
        return status.intValue;
    }
    else {
        // No news is good news, return success
        return JMCSentStatusSuccess;
    }
}

-(void)updateItem:(NSString *)uuid sentStatus:(JMCSentStatus)sentStatus bumpNumAttemptsBy:(int)inc
{
    @synchronized (_flushLock) {
        // get the index, set the sent status, save the index
        NSMutableDictionary *queueIndex = [self getQueueList];
        NSMutableDictionary *metadata = [queueIndex objectForKey:uuid];

        [metadata setObject:[NSNumber numberWithInt:sentStatus] forKey:KEY_SENT_STATUS];
        [metadata setObject:[NSDate date] forKey:KEY_UPDATED_AT];

        NSNumber *lastNumAttempts = [metadata objectForKey:KEY_NUM_ATTEMPTS];
        NSNumber *newNumAttempts  = [NSNumber numberWithInt:lastNumAttempts.intValue + inc];
        if (newNumAttempts.intValue >= _maxNumRequestFailures) {
            [metadata setObject:[NSNumber numberWithInt:JMCSentStatusPermError] forKey:KEY_SENT_STATUS];
        }
        [metadata setObject:newNumAttempts forKey:KEY_NUM_ATTEMPTS];
        [self saveQueueIndex:queueIndex];
    }

}

- (void)addItem:(JMCQueueItem *)item
{
    @synchronized (_flushLock) {
        // get the index, set the metadata, save the index, write the item
        NSMutableDictionary *queueIndex = [self getQueueList];
        NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithCapacity:2];
        [metadata setObject:[NSNumber numberWithInt:JMCSentStatusNew] forKey:KEY_SENT_STATUS];
        [metadata setObject:[NSNumber numberWithInt:0] forKey:KEY_NUM_ATTEMPTS];
        [queueIndex setObject:metadata forKey:item.uuid];
        [self saveQueueIndex:queueIndex];
        // now save the queue item to disc...
        NSString *itemPath = [self getQueueItemPathFor:item.uuid];
        [item writeToFile:itemPath];
    }
}

-(JMCQueueItem *)getItem:(NSString *)uuid
{
    NSString *itemPath = [self getQueueItemPathFor:uuid];
    return [JMCQueueItem queueItemFromFile:itemPath];
}


- (void)saveQueueIndex:(NSMutableDictionary *)queueList
{
    [queueList writeToFile:[self getQueueIndexPath] atomically:YES];
}

- (void)deleteItem:(NSString *)uuid
{
    @synchronized (_flushLock) {
        // get the index, remove the object, save the index, remove the item
        NSMutableDictionary *queue = [self getQueueList];
        [queue removeObjectForKey:uuid];
        [self saveQueueIndex:queue];
        // now remove the queue item from disk
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self getQueueItemPathFor:uuid] error:nil];
        // and the POST request file if it exists...
        NSString* postDataPath = [JMCTransport postDataFilePathFor:uuid];
        if ([fileManager fileExistsAtPath:postDataPath]) {
            [fileManager removeItemAtPath:postDataPath error:nil];
        }        
    }

}

// This is the actual list of items that need sending
- (NSMutableDictionary *)getQueueList {
    NSMutableDictionary  *queueIndex = [[[NSMutableDictionary dictionaryWithContentsOfFile:[self getQueueIndexPath]] mutableCopy] autorelease];
    if (queueIndex == nil) {
        queueIndex = [NSMutableDictionary dictionary];
    }
    return queueIndex;
}

// The path of the plist that stores a list of request that need resending
- (NSString *)getQueueIndexPath {
    return [[self getQueueDirPath] stringByAppendingPathComponent:@"JMCQueueIndex.plist"];
}

- (NSString *)getQueueItemPathFor:(NSString *)uuid {
    return [[self getQueueDirPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", uuid]];
}

- (NSString *)getQueueDirPath {
    return [[JMC sharedInstance] dataDirPath];
}

-(void) dealloc
{
    [_issueTransport release];
    [_replyTransport release];
    [sharedOperationQueue release];
    [_flushLock release];
    [super dealloc];
}

@end