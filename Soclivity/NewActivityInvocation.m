//
//  NewActivityInvocation.m
//  Soclivity
//
//  Created by Kanav on 10/12/12.
//
//

#import "NewActivityInvocation.h"
#import "InfoActivityClass.h"
#import "JSON.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
@interface NewActivityInvocation (private)
-(NSString*)body;
@end


@implementation NewActivityInvocation
@synthesize activityObj;

-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/activities.json"];
	[self post:a body:[self body]];
    
}


-(NSString*)body {
#if 1
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    GetPlayersClass *player=SOC.loggedInUser;

    [bodyD setObject:activityObj.access forKey:@"access"];
    
    
    [bodyD setObject:[NSNumber numberWithInt:activityObj.type] forKey:@"atype"];
    [bodyD setObject:activityObj.activityName forKey:@"name"];
    [bodyD setObject:[NSNumber numberWithInt:activityObj.num_of_people] forKey:@"num_of_people"];
    [bodyD setObject:player.idSoc forKey:@"ownnerid"];
    [bodyD setObject:activityObj.what forKey:@"what"];
    [bodyD setObject:activityObj.when forKey:@"when"];
        if(activityObj.where_address!=nil)
    [bodyD setObject:activityObj.where_address forKey:@"where_address"];
        if(activityObj.where_city!=nil)
    [bodyD setObject:activityObj.where_city forKey:@"where_city"];
    [bodyD setObject:activityObj.where_lat forKey:@"where_lat"];
    [bodyD setObject:activityObj.where_lng forKey:@"where_lng"];
        if(activityObj.where_state!=nil)
    [bodyD setObject:activityObj.where_state forKey:@"where_state"];
        if(activityObj.where_zip!=nil)
    [bodyD setObject:activityObj.where_zip forKey:@"where_zip"];
    
    
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    InfoActivityClass* response =[InfoActivityClass DetailInfoParse:resultsd];
	[self.delegate PostNewActivityRequestInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate PostNewActivityRequestInvocationDidFinish:self
                                             withResponse:nil
                                                withError:[NSError errorWithDomain:@"UserId"
                                                                              code:[[self response] statusCode]
                                                                          userInfo:[NSDictionary dictionaryWithObject:@"Failed to Post Request. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
