//
//  ResetPasswordInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordInvocation.h"
#import "JSON.h"
@interface ResetPasswordInvocation (private)
-(NSString*)body;
@end

@implementation ResetPasswordInvocation
@synthesize confirmPassword,userId,oldPassword,theNewPassword;

-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/password/%d.json",userId];
    [self put:a
		  body:[self body]];
}
-(NSString*)body {
#if 1    
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    [bodyD setObject:theNewPassword forKey:@"password"];
    [bodyD setObject:confirmPassword forKey:@"password_confirmation"];
    
     NSString *bodyData = [NSString stringWithFormat:@"\"player\":%@}",[bodyD JSONRepresentation]];
     NSString *bodyData1 = [NSString stringWithFormat:@"{\"old_password\":\"%@\",%@",oldPassword,bodyData];
     NSLog(@"bodyData=%@",bodyData1);
	return bodyData1;
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSError* error = nil;
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
   
    NSString*resetStatus= [resultsd objectForKey:@"status"];
     NSLog(@"resetStatus=%@",resetStatus);
    [self.delegate ResetPasswordInvocationDidFinish:self withResponse:resetStatus withError:error];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate ResetPasswordInvocationDidFinish:self 
                               withResponse:nil
                                  withError:[NSError errorWithDomain:@"UserId" 
                                                                code:[[self response] statusCode]
                                                            userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}


@end
