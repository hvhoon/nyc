//
//  GetUpcomingActivitiesInvocation.m
//  Soclivity
//
//  Created by Kanav on 11/1/12.
//
//

#import "GetUpcomingActivitiesInvocation.h"
#import "JSON.h"
#import "InfoActivityClass.h"
#import "InfoActivityClass+Parse.h"
#import "SoclivityManager.h"



@implementation GetUpcomingActivitiesInvocation
@synthesize player1Id,player2Id;


-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];

    NSString*a= [NSString stringWithFormat:@"%@/activitylist.json?pid=%d&p2id=%d&lat=%f,lng=%f",ProductionServer,player1Id,player2Id,SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude];
    
     [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
      NSLog(@" resultsd;::%@", resultsd);
    
    NSArray* response=[InfoActivityClass GetAllActivitiesForTheUser:resultsd];
    
	[self.delegate UpcomingActivitiesInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate UpcomingActivitiesInvocationDidFinish:self
                                         withResponse:nil
                                            withError:[NSError errorWithDomain:@"UserId"
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get activities for a user. Please try again later" forKey:@"message"]]];
	return YES;
}


@end
