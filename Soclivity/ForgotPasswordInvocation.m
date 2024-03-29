//
//  ForgotPasswordInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswordInvocation.h"
#import "JSON.h"
@interface ForgotPasswordInvocation (private)
-(NSString*)body;
@end

@implementation ForgotPasswordInvocation
@synthesize queue,emailAddress;

-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/reset.json"];
    [self post:a
		  body:[self body]];
}
-(NSString*)body {
#if 1    
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:emailAddress forKey:@"email"];
    
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    
    //    NSString *bodyData = [NSString stringWithFormat:@"{\"signin\":%@}",[bodyD JSONRepresentation]];
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    self.queue = [[NSOperationQueue alloc] init];
    ParseOperation *parser = [[ParseOperation alloc] initWithData:data delegate:self tagJsonService:kForgotPassword];
    
    [queue addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    [queue release];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate ForgotPasswordInvocationDelegate:self 
                                       withResponse:nil
                                          withError:[NSError errorWithDomain:@"UserId" 
                                                                        code:[[self response] statusCode]
                                                                    userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}

- (void)handleLoadedMedia:(NSArray *)loadedMedia
{
    NSError* error = nil;
    
    
    // tell our table view to reload its data, now that parsing has completed
    [self.delegate ForgotPasswordInvocationDelegate:self withResponse:loadedMedia withError:error];
}

- (void)handleError:(NSString *)error
{
    
    [self.delegate ForgotPasswordInvocationDelegate:self 
                                       withResponse:nil
                                          withError:[NSError errorWithDomain:@"UserId" 
                                                                        code:[[self response] statusCode]
                                                                    userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
    
    //NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot jSon Parse"
														message:error
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)didFinishParsing:(NSArray *)mediaList
{
    [self performSelectorOnMainThread:@selector(handleLoadedMedia:) withObject:mediaList waitUntilDone:NO];
    
    self.queue = nil;   // we are finished with the queue and our ParseOperation
    
}

- (void)parseErrorOccurred:(NSString *)error
{
    [self performSelectorOnMainThread:@selector(handleError:) withObject:error waitUntilDone:NO];
}

@end
