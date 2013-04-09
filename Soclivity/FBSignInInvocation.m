//
//  FBSignInInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBSignInInvocation.h"
#import "JSON.h"
#import "AppDelegate.h"
@interface FBSignInInvocation (private)
-(NSString*)body;
@end

@implementation FBSignInInvocation
@synthesize email,fbuid,access_token,queue;

-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/signin.json"];
    [self post:a
         body:[self body]];
}

-(NSString*)body {
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:email forKey:@"email"];
    [bodyD setObject:fbuid forKey:@"fbuid"];
    [bodyD setObject:access_token forKey:@"access_token"];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]!=NULL)
    {
        [bodyD setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]  forKey:@"device_token"];
    }
    
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    
    //    NSString *bodyData = [NSString stringWithFormat:@"{\"signin\":%@}",[bodyD JSONRepresentation]];
	return bodyData;
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
	[self.delegate FBSignInInvocationDidFinish:self 
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
    [self.delegate FBSignInInvocationDidFinish:self withResponse:loadedMedia withError:error];
}

- (void)handleError:(NSString *)error
{
    
    [self.delegate FBSignInInvocationDidFinish:self 
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
