//
//  GetUsersByFirstLastNameInvocation.m
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import "GetUsersByFirstLastNameInvocation.h"
#import "InviteObjectClass.h"
#import "InviteObjectClass+Parse.h"

@implementation GetUsersByFirstLastNameInvocation
@synthesize searchName,playerId,activityId;
-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    
    //NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/mutualfriends.json?pid=&fid="];
        //NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/players/search_contact.json?id=%d&aid=%d&name=%@",playerId,activityId,searchName];
    
    NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/players/global_search.json?id=%d&aid=%d&name=%@",playerId,activityId,searchName];

    
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    NSLog(@"resultsd=%@",resultsd);
    
    
    NSArray*response =[InviteObjectClass PlayersInvitesParse2:resultsd];

	[self.delegate SearchUsersInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate SearchUsersInvocationDidFinish:self
                                         withResponse:nil
                                            withError:[NSError errorWithDomain:@"UserId"
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get activities for a user. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
