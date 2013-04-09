//
//  GetActivityInvitesInvocation.m
//  Soclivity
//
//  Created by Kanav on 10/5/12.
//
//

#import "GetActivityInvitesInvocation.h"
#import "JSON.h"
#import "InviteObjectClass.h"
#import "InviteObjectClass+Parse.h"


@interface GetActivityInvitesInvocation (private)
-(NSString*)body;
@end

@implementation GetActivityInvitesInvocation
@synthesize playerId,activityId,inviteeType,responseABString;


-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    
    NSString *a=nil;
    switch (inviteeType) {
        case 1:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/activityinvites.json?id=%d&pid=%d",activityId,playerId];
            [self get:a];
        }
            break;
            
        case 2:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/abcheck.json"];
            [self post:a body:[self body]];
        }
            break;
            
        case 3:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/players/friendwithdos1.json?id=%d",playerId];
            //a= [NSString stringWithFormat:@"dev.soclivity.com/players/friendwithdos1.json?id=24"];

            [self get:a];
        }
            break;


    }
}

-(NSString*)body {
    NSString *myTest=[NSString stringWithFormat:@"\"id\":%d,\"pid\":%d",activityId,playerId];
    NSString *bodyData = [NSString stringWithFormat:@"{\"ab\":%@,%@}",responseABString,myTest];
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
   
}




-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding] JSONValue];
    
    NSArray* response=nil;
    switch (inviteeType) {
        case 1:
            response =[InviteObjectClass PlayersInvitesParse:resultsd];
            break;
            
        case 2:
            response =[InviteObjectClass PlayersAddressBookParse:resultsd];
            break;
            
        case 3:
            response =[InviteObjectClass PlayersInvitesToJoinSoclivityParse:resultsd];
            break;

    }
    
	[self.delegate ActivityInvitesInvocationDidFinish:self withResponse:response type:inviteeType withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate ActivityInvitesInvocationDidFinish:self
                                    withResponse:nil type:inviteeType
                                       withError:[NSError errorWithDomain:@"UserId"
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
