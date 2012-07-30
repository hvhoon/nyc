//
//  PostActivityRequestInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostActivityRequestInvocation.h"
#import "JSON.h"


@implementation PostActivityRequestInvocation
@synthesize playerId,activityId,relationshipId;



-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/getactivity.json?id=%d&pid=%d",activityId,playerId];
    [self get:a];
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data 
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    NSString*value=nil;
    
	[self.delegate PostActivityRequestInvocationDidFinish:self withResponse:value relationTypeTag:0 withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate PostActivityRequestInvocationDidFinish:self 
                                             withResponse:@"" relationTypeTag:-1
                                                 withError:[NSError errorWithDomain:@"UserId" 
                        code:[[self response] statusCode]
                        userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}


@end
