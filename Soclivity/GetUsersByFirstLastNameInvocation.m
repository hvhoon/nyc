//
//  GetUsersByFirstLastNameInvocation.m
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import "GetUsersByFirstLastNameInvocation.h"

@implementation GetUsersByFirstLastNameInvocation
@synthesize searchName;
-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    
    NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/mutualfriends.json?pid=&fid="];
    
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    
	[self.delegate SearchUsersInvocationDidFinish:self withResponse:nil withError:Nil];
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
