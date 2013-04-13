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
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
@interface ChatServiceInvocation (private)
-(NSString*)body;
@end

@implementation ChatServiceInvocation
@synthesize chatId,activityId,textMessage,imageData,requestType;


-(void)dealloc {
	[super dealloc];
    [textMessage release];
    [imageData release];
}


-(void)invoke {
    SoclivityManager *SOC=[SoclivityManager SharedInstance];

    switch (requestType) {
        case 1:
        {
            NSString*a=[NSString stringWithFormat:@"dev.soclivity.com/activity_chats.json?activity_id=%d&player_id=%d",activityId,[SOC.loggedInUser.idSoc intValue]];
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
            NSString*a=[NSString stringWithFormat:@"dev.soclivity.com/activity_chats/%d.json",chatId];
            [self delete:a];

        }
            break;
            
            
        case 5:
        {
            NSString*a=[NSString stringWithFormat:@"dev.soclivity.com/activity_chats/%d/chat_detail.json?pid=%d",chatId,[SOC.loggedInUser.idSoc intValue]];
            [self get:a];
            
        }
            break;
            
            
        case 6:
        {
            NSString*a=[NSString stringWithFormat:@"dev.soclivity.com/activity_chats/backgroundchat.json?pid=%d&aid=%d&time=%@",[SOC.loggedInUser.idSoc intValue],activityId,[[NSUserDefaults standardUserDefaults]valueForKey:@"ChatTimeStamp"]];
            [self get:a];
            
        }
            break;


        default:
            break;
    }
}
//{"activity_id":277,"player_id":26,"description":"test"}
-(NSString*)body{
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    [bodyD setObject:[NSNumber numberWithInt:activityId] forKey:@"activity_id"];
    [bodyD setObject:[NSNumber numberWithInt:[SOC.loggedInUser.idSoc intValue]] forKey:@"player_id"];
    
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
        case 5:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding] JSONValue];
            
            ActivityChatData *response=[ActivityChatData getChatInterceptFromUsers:resultsd];
            
            [self.delegate addAPost:response];

        }
            break;
        case 6:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding] JSONValue];
            
            NSArray *response=[ActivityChatData PlayersDeltaPertainingToActivity:resultsd];
            [self.delegate chatPostToDidFinish:self withResponse:response withError:Nil];

            
            
            [self.delegate deltaPostInBackground:response];
            
        }
            break;
    }
    
    
    
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
    
    [self.delegate postDidFailed:[NSError errorWithDomain:@"UserId"
                                                     code:[[self response] statusCode]
                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get Chat for a user. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
