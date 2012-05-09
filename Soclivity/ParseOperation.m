//
//  ParseOperation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseOperation.h"
#import "GetPlayersClass.h"
@interface ParseOperation ()
@property (nonatomic, assign) id <ParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic,retain) NSString *mappedKey;
@property (nonatomic,retain) GetPlayersClass *playerObject;
@end

@implementation ParseOperation
@synthesize delegate, dataToParse, workingArray,mappedKey,jsonQueryKey,playerObject;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate tagJsonService:(NSInteger)tagJsonService
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.delegate = theDelegate;
        jsonQueryKey=tagJsonService;
    }
    return self;
}

-(void)main{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArray = [NSMutableArray array];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
	// desirable because it gives less control over the network, particularly in responding to
	// connection errors.
    //
    
    adapter = [SBJsonStreamParserAdapter new];
    adapter.delegate = self;
    
    parser = [SBJsonStreamParser new];
	
    // .. and set our adapter as its delegate.
	parser.delegate = self;
	parser.multi = YES;
    
    SBJsonStreamParserStatus status = [parser parse:dataToParse];
    
 	
	if (![self isCancelled])
    {
        if (status == SBJsonStreamParserError) {
            NSLog(@"Parser error: %@", parser.error);
            [self.delegate parseErrorOccurred:parser.error];
            
            
        } else if (status == SBJsonStreamParserWaitingForData) {
            //		NSLog(@"Parser waiting for more data");
            
            
            [self.delegate didFinishParsing:self.workingArray];
            
        }
        // notify our AppDelegate that the parsing is complete
    }
    
    self.workingArray = nil;
    self.dataToParse = nil;
    
    [parser release];
    [adapter release];
	[pool release];
}

- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
    //NSLog(@"Inside json adapter delegate foundArray");	
}

- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
    //NSLog(@"Inside json adapter delegate foundObject");	
}


- (void)parserFoundObjectStart:(SBJsonStreamParser*)parser
{
    //NSLog(@"Inside json delegate parserFoundObjectStart");
    if(arrayInsert){
        if(jsonQueryKey==kGetPlayers)
        self.playerObject=[[[GetPlayersClass alloc]init]autorelease];
        
    }
    
}
- (void)parser:(SBJsonStreamParser*)parser foundObjectKey:(NSString*)key
{
    //NSLog(@"Inside json delegate foundObjectKey");
    
    if(jsonQueryKey==kGetPlayers){  
        if ([key isEqualToString:@"birth_date"]) {
                mappedKey=key;
        }
        if ([key isEqualToString:@"created_at"]) {
			mappedKey=key;
        }
        if ([key isEqualToString:@"email"]) {
			mappedKey=key;
        }
        if ([key isEqualToString:@"first_name"]) {
			mappedKey=key;
        }
        if ([key isEqualToString:@"id"]){
            mappedKey=key;
        }
        if ([key isEqualToString:@"last_name"]) {
			mappedKey=key;
        }
        if ([key isEqualToString:@"updated_at"]) {
			mappedKey=key;
        }

        
    }		
        
    
}
- (void)parserFoundObjectEnd:(SBJsonStreamParser*)parser{
    
    
    if(arrayInsert){
        if(jsonQueryKey==kGetPlayers)
            [[self workingArray] addObject:self.playerObject];
        
    }
    
}


- (void)parserFoundArrayStart:(SBJsonStreamParser*)parser{
    //    NSLog(@"Inside json delegate parserFoundArrayStart");
    
    //response ke baad idhar
    arrayInsert=TRUE;
}

- (void)parserFoundArrayEnd:(SBJsonStreamParser*)parser{
    //    NSLog(@"Inside json delegate parserFoundArrayEnd");
    arrayInsert=FALSE;
    //sab kaam khatam
}


- (void)parser:(SBJsonStreamParser*)parser foundBoolean:(BOOL)x{
    // NSLog(@"Inside json delegate foundBoolean");
}
- (void)parserFoundNull:(SBJsonStreamParser*)parser{
    //    NSLog(@"Inside json delegate parserFoundNull");	
}


- (void)parser:(SBJsonStreamParser*)parser foundNumber:(NSNumber*)num{
    //    NSLog(@"Inside json delegate foundNumber");
    
    if(jsonQueryKey==kGetPlayers){
        if ([mappedKey isEqualToString:@"id"]) {
            self.playerObject.idSoc = num;
            mappedKey=nil;
        }
        
    }
    
}

- (void)parser:(SBJsonStreamParser*)parser foundString:(NSString*)string{
    //    	NSLog(@"Inside json delegate foundString");
    
    if(jsonQueryKey==kGetPlayers){
            
        if ([mappedKey isEqualToString:@"birth_date"]) {
            self.playerObject.birth_date = string;
            
            mappedKey=nil;
            }
        if ([mappedKey isEqualToString:@"created_at"]) {
            self.playerObject.created_at = string;
            
            mappedKey=nil;
        }
        if ([mappedKey isEqualToString:@"email"]) {
            self.playerObject.email = string;
            
            mappedKey=nil;
        }
        if ([mappedKey isEqualToString:@"first_name"]) {
            self.playerObject.first_name = string;
            
            mappedKey=nil;
        }
        if ([mappedKey isEqualToString:@"last_name"]) {
            self.playerObject.last_name = string;
            
            mappedKey=nil;
        }
        if ([mappedKey isEqualToString:@"updated_at"]) {
            self.playerObject.updated_at = string;
            
            mappedKey=nil;
        }

        
    }
        
        
        
	
    
}



// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [dataToParse release];
    [workingArray release];
    [super dealloc];
}
@end
