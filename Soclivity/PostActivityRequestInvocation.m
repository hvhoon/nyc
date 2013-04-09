//
//  PostActivityRequestInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostActivityRequestInvocation.h"
#import "JSON.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"

@implementation PostActivityRequestInvocation
@synthesize playerId,activityId,relationshipId;



-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    
    NSString*a=nil;
    switch (relationshipId) {
      case 1:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/joinactivity.json?id=%d&pid=%d&pstatus=true",activityId,playerId];
                [self post:a body:nil];
        }
            break;
            
      case 2:
      case 5:
      case 3:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/leaveactivity.json?id=%d&pid=%d&pstatus=true",activityId,playerId];
            [self post:a body:nil];
        }
            break;


            
      case 8:
      case 9:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/leaveactivity.json?id=%d&pid=%d&astatus=true",activityId,playerId];
            [self post:a body:nil];
        }
            break;


            
    case 4:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/joinactivity.json?id=%d&pid=%d&pstatus=true",activityId,playerId];
            [self put:a body:nil];
        }
            break;

    case 7:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/joinactivity.json?id=%d&pid=%d&astatus=true",activityId,playerId];
                [self put:a body:nil];
        }
            break;
            
    case 10:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/activities/%d.json",activityId];
            [self delete:a];
        }
            break;
            
        case 11:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/joinactivity.json?id=%d&pid=%d&astatus=true",activityId,playerId];
            [self post:a body:nil];
        }
            break;
            
        case 12:
        {
            SoclivityManager*SOC=[SoclivityManager SharedInstance];
             a= [NSString stringWithFormat:@"dev.soclivity.com/players/send_facebook_message.json?id=%d&aid=%d&fbuid=%d",[SOC.loggedInUser.idSoc integerValue],activityId,playerId];
            [self post:a body:nil];
        }
            break;

            
        case 13:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/declinerequest.json?id=%d&pid=%d",activityId,playerId];
            [self post:a body:nil];
        }
            break;
            
        case 14:
        {
             a= [NSString stringWithFormat:@"dev.soclivity.com/declinerequest.json?id=%d&pid=%d&notgoing=true",activityId,playerId];
            [self post:a body:nil];
        }
            break;
            
        case 15:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/removeparticipant.json?id=%d&pid=%d",activityId,playerId];
            [self post:a body:nil];
        }
            break;
            
        case 16:
        {
            SoclivityManager*SOC=[SoclivityManager SharedInstance];
            a= [NSString stringWithFormat:@"dev.soclivity.com/players/send_facebook_message.json?id=%d&fbuid=%d",[SOC.loggedInUser.idSoc integerValue],playerId];
            [self post:a body:nil];
        }
            break;


     }


}

-(NSString*)body {
#if 1
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:@"TRUE" forKey:@"pStatus"];
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data 
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    NSNumber*resetStatus= [resultsd objectForKey:@"status"];
    NSLog(@"resetStatus=%@",resetStatus);
    switch (relationshipId) {
        case 4:
        case 7:
        case 13:
        case 14:

        {
            NSNumber *badge=[resultsd objectForKey:@"badge"];
            SoclivityManager*SOC=[SoclivityManager SharedInstance];
            SOC.loggedInUser.badgeCount=[badge intValue];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];
        }
            break;
            
        default:
            break;
    }
	[self.delegate PostActivityRequestInvocationDidFinish:self withResponse:[resetStatus boolValue] relationTypeTag:relationshipId withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate PostActivityRequestInvocationDidFinish:self 
                                             withResponse:NO relationTypeTag:-1
                                                 withError:[NSError errorWithDomain:@"UserId" 
                        code:[[self response] statusCode]
                        userInfo:[NSDictionary dictionaryWithObject:@"Failed to Post Request. Please try again later" forKey:@"message"]]];
	return YES;
}


@end
