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
@implementation GetActivityInvitesInvocation
@synthesize playerId,activityId;


-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    //NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/activityinvites.json?id=%d&pid=%d",activityId,playerId];
    
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/activityinvites.json?id=2&pid=71"];

    [self get:a];
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding] JSONValue];
    
    NSArray* response =[InviteObjectClass PlayersInvitesParse:resultsd];
    
	[self.delegate ActivityInvitesInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate ActivityInvitesInvocationDidFinish:self
                                    withResponse:nil
                                       withError:[NSError errorWithDomain:@"UserId"
                                                                     code:[[self response] statusCode]
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
