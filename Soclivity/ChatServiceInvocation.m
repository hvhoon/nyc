//
//  ChatServiceInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 08/03/13.
//
//

#import "ChatServiceInvocation.h"
#import "ActivityChatData+Parse.h"
#import "ActivityChatData.h"
#import "Base64.h"
@interface ChatServiceInvocation (private)
-(NSString*)body;
@end

@implementation ChatServiceInvocation
@synthesize playerId,activityId,textMessage,imageData,requestType;


-(void)dealloc {
	[super dealloc];
    [textMessage release];
    [imageData release];
}


-(void)invoke {
    switch (requestType) {
        case 1:
        {
            NSString*a=[NSString stringWithFormat:@"dev.soclivity.com/activity_chats.json?activity_id=%d",activityId];
            [self get:a];
            
        }
            break;
            
        case 2:
        case 3:
        {
            
            NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/activity_chats.json"];
            [self post:a
                  body:[self body]];

            
        }
            break;
            
            
            case 4:
        {
            NSString*a=[NSString stringWithFormat:@"dev.soclivity.com/activity_chats/%d.json",playerId];
            [self delete:a];

        }
            break;
        default:
            break;
    }
}

-(NSString*)body{
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:[NSNumber numberWithInt:activityId] forKey:@"activity_id"];
    [bodyD setObject:[NSNumber numberWithInt:playerId] forKey:@"player_id"];
    
    if(requestType==2){
        [bodyD setObject:textMessage forKey:@"description"];
        
    }
    if(requestType==3){
        [bodyD setObject:@"IMG" forKey:@"description"];
        [bodyD setObject:[Base64 encode:imageData] forKey:@"activity_photo_data"];
    }
    
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    NSLog(@"body=%@",[bodyD JSONRepresentation]);
	return bodyData;
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
    
    switch (requestType) {
        case 1:
        {
            NSArray* resultsd = [[[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding] JSONValue];

            NSArray *response=[ActivityChatData PlayersChatPertainingToActivity:resultsd];
            [self.delegate chatPostToDidFinish:self withResponse:response withError:Nil];
            
        }
            break;
            
        case 2:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding] JSONValue];

            ActivityChatData *response=[ActivityChatData postChatTextIntercept:resultsd];
            [self.delegate userPostedAText:response];
            
        }
            break;
            
        case 3:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding] JSONValue];
            
            ActivityChatData *response=[ActivityChatData postChatImageIntercept:resultsd];
            response.postImage=[UIImage imageWithData:imageData];
            
            [self.delegate userPostedAnImage:response];
            
        }
            break;

        case 4:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding] JSONValue];
            NSString*resetStatus= [resultsd objectForKey:@"status"];
            
            [self.delegate chatDeleted:resetStatus];

            
        }
            break;
        default:
            break;
    }
    
    
    
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate chatPostToDidFinish:self
                                   withResponse:nil
                                      withError:[NSError errorWithDomain:@"UserId"
                                                                    code:[[self response] statusCode]
                                                                userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get Chat for a user. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
