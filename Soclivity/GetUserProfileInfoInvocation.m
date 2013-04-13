//
//  GetUserProfileInfoInvocation.m
//  Soclivity
//
//  Created by Kanav on 11/3/12.
//
//

#import "GetUserProfileInfoInvocation.h"
#import "SocPlayerClass.h"
#import "SocPlayerClass+Parse.h"
@implementation GetUserProfileInfoInvocation
@synthesize playerId,friendId;


-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    
    //NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/mutualfriends.json?pid=%d&fid=%d",playerId,friendId];
    
    //NSString *a=[NSString stringWithFormat:@"dev.soclivity.com/players/friendprofile.json?id=%d&fid=%d",playerId,friendId];
    NSString *a=[NSString stringWithFormat:@"dev.soclivity.com/players/friendprofile.json?id=24&fid=55"];
    
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    SocPlayerClass* response=[SocPlayerClass GetUserProfileInfoActivityPlusCommonFriends:resultsd];
    
	[self.delegate UserProfileInfoInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate UserProfileInfoInvocationDidFinish:self
                                            withResponse:nil
                                               withError:[NSError errorWithDomain:@"UserId"
                                                                             code:[[self response] statusCode]
                                                                         userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get activities for a user. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
