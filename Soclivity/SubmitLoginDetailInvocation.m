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


@synthesize  userName, usePassword;


-(void)dealloc {	
	[super dealloc];
}


-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"whoosout.projectdevelopment.co/API/loginUser.php?data=true"];
	[self post:a
		  body:[self body]];
}

-(NSString*)body {
#if 0    
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:self.userName forKey:@"username"];
	[bodyD setObject:self.usePassword forKey:@"password"];
	return [bodyD JSONRepresentation];
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSArray *result = nil;
    NSError* error = Nil;
    
#if 0    
	NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
													 encoding:NSUTF8StringEncoding] autorelease] JSONValue];
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
