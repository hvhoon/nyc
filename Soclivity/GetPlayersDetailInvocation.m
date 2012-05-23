//
//  GetPlayersDetailInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPlayersDetailInvocation.h"
#import "JSON.h"
#import <CFNetwork/CFNetwork.h>
#import "Players.h"
#import "players_accel.h"
@implementation GetPlayersDetailInvocation
@synthesize queue;

-(void)dealloc {	
	[super dealloc];
}


-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/players.json"];
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *topDictionary = [jsonString JSONValue];
#if 0    
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data 
                                                encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    players_accel* response = [players_accel modelObjectWithDictionary:topDictionary];
#else
    self.queue = [[NSOperationQueue alloc] init];
    ParseOperation *parser = [[ParseOperation alloc] initWithData:data delegate:self tagJsonService:kGetPlayers];
    
    [queue addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    [queue release];
#endif    
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate GetPlayersDetailInvocationDidFinish:self 
                                             withResult:nil
                                              withError:[NSError errorWithDomain:@"UserId" 
                    code:[[self response] statusCode]
            userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}

- (void)handleLoadedMedia:(NSArray *)loadedMedia
{
    NSError* error = nil;

    
    // tell our table view to reload its data, now that parsing has completed
    [self.delegate GetPlayersDetailInvocationDidFinish:self withResult:loadedMedia withError:error];
}

- (void)handleError:(NSString *)error
{
    
    [self.delegate GetPlayersDetailInvocationDidFinish:self 
                                            withResult:nil
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
