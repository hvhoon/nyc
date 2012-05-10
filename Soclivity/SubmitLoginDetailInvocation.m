//
//  SubmitLoginDetailInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubmitLoginDetailInvocation.h"


@interface SubmitLoginDetailInvocation (private)
-(NSString*)body;
@end

@implementation SubmitLoginDetailInvocation


@synthesize  first_name, last_name,email,birth_date,password,password_confirmation,activities;


-(void)dealloc {	
	[super dealloc];
}


-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/players"];
	[self post:a
		  body:[self body]];
}

-(NSString*)body {
#if 1    
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:@"kanav" forKey:@"player_first_name"];
	[bodyD setObject:@"gupta" forKey:@"player_last_name"];
    [bodyD setObject:@"kanav@relaystrategy.com" forKey:@"player_email"];
	[bodyD setObject:@"12-02-2000" forKey:@"player_birth_date"];
    [bodyD setObject:@"123456" forKey:@"player_password"];
	[bodyD setObject:@"123456" forKey:@"player_password_confirmation"];
    //[bodyD setObject:self.activities forKey:@"username"];
    NSLog(@"body=%@",[bodyD JSONRepresentation]);
	return [bodyD JSONRepresentation];
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray *result = nil;
    NSError* error = Nil;
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
													 encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
#if 0    
	
	// response dictionary
	
	NSDictionary *responsed = [SAServiceAsyncInvocation responseFromJSONDictionary:resultsd error:&error];
    
    
    
	if (!error) 
	{
        result = [UserDetail userDetailsFromArray:[responsed objectForKey:@"result"]];
		
	}
#endif	
	[self.delegate SubmitLoginDetailInvocationDidFinish:self withResult:result withError:error];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate SubmitLoginDetailInvocationDidFinish:self 
                                             withResult:nil
        withError:[NSError errorWithDomain:@"UserId" 
        code:[[self response] statusCode]
    userInfo:[NSDictionary dictionaryWithObject:@"Failed to submit user. Please try again later" forKey:@"message"]]];
	return YES;
}

@end
