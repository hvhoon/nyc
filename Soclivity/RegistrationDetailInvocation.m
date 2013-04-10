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
#import "FilterPreferenceClass.h"
#define kPlay 0
#define kEat 1
#define kSee 2
#define kCreate 3
#define kLearn 4

@interface RegistrationDetailInvocation (private)
-(NSString*)body;
-(NSString*)updateActivityBody;
-(NSString*)updateCalendarSync:(BOOL)sync;
@end

@implementation RegistrationDetailInvocation


@synthesize  queue,isFacebookUser,activityTypeUpdate;


-(void)dealloc {	
	[super dealloc];
}


-(void)invoke {

    NSString *a=nil;
    
    switch (activityTypeUpdate) {
        case 1:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/players.json"];
            [self post:a body:[self body]];//dev.soclivity.com/players/17.json

        }
            break;
            
        case 2:
        {
            SoclivityManager *SOC=[SoclivityManager SharedInstance];
            GetPlayersClass *player=SOC.loggedInUser;
            a= [NSString stringWithFormat:@"dev.soclivity.com/players/%d.json",[player.idSoc intValue]];
            [self put:a body:[self updateActivityBody]];
            
        }
            break;

            
        case 3:
        {
            SoclivityManager *SOC=[SoclivityManager SharedInstance];
            GetPlayersClass *player=SOC.loggedInUser;
            a= [NSString stringWithFormat:@"dev.soclivity.com/players/%d.json",[player.idSoc intValue]];
            [self put:a body:[self updateCalendarSync:player.calendarSync]];
            
        }
            break;

            
    }

    //[self delete:a];
}

-(NSString*)updateCalendarSync:(BOOL)sync{
    NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    [bodyD setObject:[NSNumber numberWithBool:sync] forKey:@"calendar_status"];
    
    return [bodyD JSONRepresentation];

}

-(NSString*)updateActivityBody{
    
    NSString *bodyData = [NSString stringWithFormat:@"{\"player\":{\"activity_type_ids\":[%@]}}",[self returnActivityType]];
    NSLog(@"bodyData=%@",bodyData);
    return bodyData;

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
    
    if(!isFacebookUser){
    [bodyD setObject:player.password forKey:@"password"];
	[bodyD setObject:player.password_confirmation  forKey:@"password_confirmation"];
    }
    if(player.gender!=nil)
    [bodyD setObject:player.gender  forKey:@"gender"];
    
    if(playerLoc.coordinate.latitude!=0.0f && playerLoc.coordinate.longitude!=0.0f){
    [bodyD setObject:[NSString stringWithFormat:@"%f",playerLoc.coordinate.latitude]  forKey:@"location_lat"];
    [bodyD setObject:[NSString stringWithFormat:@"%f",playerLoc.coordinate.longitude]  forKey:@"location_lng"];
    }
    
    
    player.activityTypes=[self returnActivityType];
    
    [bodyD setObject:player.activityTypes forKey:@"activity_type_ids"];
     
    if(isFacebookUser){
        [bodyD setObject:player.facebookAccessToken  forKey:@"access_token"];
        [bodyD setObject:player.facebookUId  forKey:@"fbuid"];

        
    }

    NSLog(@"bodyDataJSONRepresentation=%@",[bodyD JSONRepresentation]);
    if(player.profileImageData!=nil)
    [bodyD setObject:[Base64 encode:player.profileImageData] forKey:@"photo_data"];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]!=NULL)
    {
        [bodyD setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]  forKey:@"device_token"];
    }//END if([[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]!=NULL)
    
    NSLog(@"bodyD::%@",bodyD);

    NSString *bodyData = [NSString stringWithFormat:@"{\"player\":%@}",[bodyD JSONRepresentation]];
     NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}

-(NSString*)returnActivityType{
    SoclivityManager *SOC=[SoclivityManager SharedInstance];

    FilterPreferenceClass*idObj=SOC.filterObject;

    NSString *activitySelect=nil;
    for(int i=0;i<5;i++){
        switch (i) {
            case kPlay:
            {
                if(idObj.playAct){
                    if(activitySelect==nil)
                        activitySelect=[NSString stringWithFormat:@"1"];
                }
            }
                break;
                
            case kEat:
            {
                if(idObj.eatAct){
                    if(activitySelect==nil)
                        activitySelect=[NSString stringWithFormat:@"2"];
                    else{
                        activitySelect=[NSString stringWithFormat:@"%@,2",activitySelect];
                        
                    }
                }
            }
                break;
            case kSee:
            {
                if(idObj.seeAct){
                    if(activitySelect==nil)
                        activitySelect=[NSString stringWithFormat:@"3"];
                    else{
                        activitySelect=[NSString stringWithFormat:@"%@,3",activitySelect];
                        
                    }
                }
            }
                break;
            case kCreate:
            {
                if(idObj.createAct){
                    if(activitySelect==nil)
                        activitySelect=[NSString stringWithFormat:@"4"];
                    else{
                        activitySelect=[NSString stringWithFormat:@"%@,4",activitySelect];
                        
                    }
                }
            }
                break;
            case kLearn:
            {
                if(idObj.learnAct){
                    if(activitySelect==nil)
                        activitySelect=[NSString stringWithFormat:@"5"];
                    else{
                        activitySelect=[NSString stringWithFormat:@"%@,5",activitySelect];
                        
                    }
                }
            }
                break;
                
                
                
        }
        
    }
    return activitySelect;
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    NSString *response=[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"response=%@",response);


    switch (activityTypeUpdate) {
        case 1:
        {
            self.queue = [[NSOperationQueue alloc] init];
            
            ParseOperation *parser = [[ParseOperation alloc] initWithData:data delegate:self tagJsonService:kRegisterPlayer];
            
            [queue addOperation:parser]; // this will start the "ParseOperation"
            
            [parser release];
            [queue release];

        }
            break;
            
            case 2:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding] JSONValue];
            NSNumber*resetStatus= [resultsd objectForKey:@"id"];
            NSLog(@"resetStatus=%@",resetStatus);
            [self.delegate RegistrationDetailInvocationDidFinish:self withResult:nil  andUpdateType:activityTypeUpdate withError:nil];
            
        }
            break;
            
            
        case 3:
        {
            NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding] JSONValue];
            NSNumber*resetStatus= [resultsd objectForKey:@"status"];
            NSLog(@"resetStatus=%@",resetStatus);
            [self.delegate RegistrationDetailInvocationDidFinish:self withResult:nil  andUpdateType:activityTypeUpdate withError:nil];
            
        }
            break;

            
    }
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate RegistrationDetailInvocationDidFinish:self 
                                              withResult:nil andUpdateType:activityTypeUpdate
        withError:[NSError errorWithDomain:@"UserId" 
        code:[[self response] statusCode]
    userInfo:[NSDictionary dictionaryWithObject:@"Failed to register user. Please try again later" forKey:@"message"]]];
	return YES;
}
- (void)handleLoadedMedia:(NSArray *)loadedMedia
{
    NSError* error = nil;
    
    
    // tell our table view to reload its data, now that parsing has completed
    [self.delegate RegistrationDetailInvocationDidFinish:self withResult:loadedMedia  andUpdateType:activityTypeUpdate withError:error];
}

- (void)handleError:(NSString *)error
{
    
    [self.delegate RegistrationDetailInvocationDidFinish:self 
            withResult:nil andUpdateType:activityTypeUpdate
                    withError:[NSError errorWithDomain:@"UserId" 
        code:[[self response] statusCode]
    userInfo:[NSDictionary dictionaryWithObject:@"Failed to Register user. Please try again later" forKey:@"message"]]];
    
    //NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Parse json"
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
