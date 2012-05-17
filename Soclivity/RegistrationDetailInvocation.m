//
//  SubmitLoginDetailInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrationDetailInvocation.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "Base64.h"
@interface RegistrationDetailInvocation (private)
-(NSString*)body;
@end

@implementation RegistrationDetailInvocation


@synthesize  queue;


-(void)dealloc {	
	[super dealloc];
}


-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/players.json"];//dev.soclivity.com/players.json
	[self post:a
		  body:[self body]];
}

-(NSString*)body {
#if 1    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    GetPlayersClass *player=SOC.registrationObject;
    CLLocation *playerLoc=SOC.currentLocation;
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:player.first_name forKey:@"first_name"];
    
    if(player.last_name!=nil)
	[bodyD setObject:player.last_name forKey:@"last_name"];
    [bodyD setObject:player.email forKey:@"email"];
    if(player.birth_date!=nil)
	[bodyD setObject:player.birth_date forKey:@"birth_date"];
    [bodyD setObject:player.password forKey:@"password"];
	[bodyD setObject:player.password_confirmation  forKey:@"password_confirmation"];
    if(player.gender!=nil)
    [bodyD setObject:player.gender  forKey:@"gender"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",playerLoc.coordinate.latitude]  forKey:@"location_lat"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",playerLoc.coordinate.longitude]  forKey:@"location_lng"];
    
    
     //NSString *stringType=[NSString stringWithFormat:@"[1,5]"];
    //[bodyD setObject:stringType forKey:@"activity_type_ids"];



    
    NSLog(@"bodyDataJSONRepresentation=%@",[bodyD JSONRepresentation]);
    if(player.profileImageData!=nil)
    [bodyD setObject:[Base64 encode:player.profileImageData] forKey:@"photo_data"];

    NSString *bodyData = [NSString stringWithFormat:@"{\"player\":%@}",[bodyD JSONRepresentation]];
     NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}




-(BOOL)handleHttpOK:(NSMutableData *)data {
    self.queue = [[NSOperationQueue alloc] init];
    ParseOperation *parser = [[ParseOperation alloc] initWithData:data delegate:self tagJsonService:kRegisterPlayer];
    
    [queue addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    [queue release];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate RegistrationDetailInvocationDidFinish:self 
                                             withResult:nil
        withError:[NSError errorWithDomain:@"UserId" 
        code:[[self response] statusCode]
    userInfo:[NSDictionary dictionaryWithObject:@"Failed to register user. Please try again later" forKey:@"message"]]];
	return YES;
}
- (void)handleLoadedMedia:(NSArray *)loadedMedia
{
    NSError* error = nil;
    
    
    // tell our table view to reload its data, now that parsing has completed
    [self.delegate RegistrationDetailInvocationDidFinish:self withResult:loadedMedia withError:error];
}

- (void)handleError:(NSString *)error
{
    
    [self.delegate RegistrationDetailInvocationDidFinish:self 
            withResult:nil
                    withError:[NSError errorWithDomain:@"UserId" 
        code:[[self response] statusCode]
    userInfo:[NSDictionary dictionaryWithObject:@"Failed to Register user. Please try again later" forKey:@"message"]]];
    
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
