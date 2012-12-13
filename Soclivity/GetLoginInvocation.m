//
//  GetLoginInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetLoginInvocation.h"
#import "JSON.h"
@interface GetLoginInvocation (private)
-(NSString*)body;
@end

@implementation GetLoginInvocation
@synthesize queue,username,password;


-(void)dealloc {	
	[super dealloc];
}


-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@/signin.json",ProductionServer];
    [self post:a
		  body:[self body]];
}
-(NSString*)body {
#if 1    
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:username forKey:@"email"];
    [bodyD setObject:password forKey:@"password"];

    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];

//    NSString *bodyData = [NSString stringWithFormat:@"{\"signin\":%@}",[bodyD JSONRepresentation]];
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    self.queue = [[NSOperationQueue alloc] init];
    ParseOperation *parser = [[ParseOperation alloc] initWithData:data delegate:self tagJsonService:kLoginPlayer];
    
    [queue addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    [queue release];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate LoginInvocationDidFinish:self 
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
    [self.delegate LoginInvocationDidFinish:self withResponse:loadedMedia withError:error];
}

- (void)handleError:(NSString *)error
{
    
    [self.delegate LoginInvocationDidFinish:self 
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
