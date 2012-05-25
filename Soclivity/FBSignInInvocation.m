//
//  FBSignInInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBSignInInvocation.h"
#import "JSON.h"
@interface FBSignInInvocation (private)
-(NSString*)body;
@end

@implementation FBSignInInvocation
@synthesize email,fbuid,access_token;

-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/signin.json"];
    [self post:a
         body:[self body]];
}

-(NSString*)body {
#if 1    
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:email forKey:@"email"];
    [bodyD setObject:fbuid forKey:@"fbuid"];
    [bodyD setObject:access_token forKey:@"access_token"];
    
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    
    //    NSString *bodyData = [NSString stringWithFormat:@"{\"signin\":%@}",[bodyD JSONRepresentation]];
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    NSError* error = nil;
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
                                                     encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSNumber * n = [resultsd valueForKey:@"registered"];
    BOOL value = [n boolValue];
    //for (NSString *key in [resultsd allKeysForObject:@"registered"]) {
       // NSLog(@"Key: %@", key);
    //}
    [self.delegate FBSignInInvocationDidFinish:self withResponse:value withError:error];

	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate FBSignInInvocationDidFinish:self 
                                       withResponse:FALSE
                                          withError:[NSError errorWithDomain:@"UserId" 
                                                                        code:[[self response] statusCode]
                                                                    userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
