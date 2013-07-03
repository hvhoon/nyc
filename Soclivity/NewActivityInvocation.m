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
    if(activityObj.where_address!=nil && [activityObj.where_address class]!=[NSNull class] && [activityObj.where_address length]!=0){
        
       // NSString *unfilteredString = @"!@#$%^&*()_+|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@", !@#$%^&*()_+abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
        NSString *resultString = [[activityObj.where_address componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSLog (@"Result=%@", resultString);
        
        NSString *unaccentedString = [activityObj.where_address stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    [bodyD setObject:unaccentedString forKey:@"where_address"];
        
    }
        if(activityObj.where_city!=nil && [activityObj.where_city class]!=[NSNull class] && [activityObj.where_city length]!=0)
    [bodyD setObject:activityObj.where_city forKey:@"where_city"];
    [bodyD setObject:activityObj.where_lat forKey:@"where_lat"];
    [bodyD setObject:activityObj.where_lng forKey:@"where_lng"];
        if(activityObj.where_state!=nil && [activityObj.where_state class]!=[NSNull class] && [activityObj.where_state length]!=0)
    [bodyD setObject:activityObj.where_state forKey:@"where_state"];
        if(activityObj.where_zip!=nil && [activityObj.where_zip class]!=[NSNull class] && [activityObj.where_zip length]!=0)
    [bodyD setObject:activityObj.where_zip forKey:@"where_zip"];
    
    if(activityObj.venueId!=nil && [activityObj.venueId class]!=[NSNull class] && [activityObj.venueId length]!=0)
        [bodyD setObject:activityObj.venueId forKey:@"venue_id"];
    else
        [bodyD setObject:@"" forKey:@"venue_id"];

    
    
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif    
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    NSLog(@"resultsd=%@",resultsd);
    
    InfoActivityClass* response =[InfoActivityClass DetailInfoParse:resultsd];
    
    
	[self.delegate PostNewActivityRequestInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code{
	[self.delegate PostNewActivityRequestInvocationDidFinish:self
                                             withResponse:nil
                                                withError:[NSError errorWithDomain:@"UserId"
                                                                              code:[[self response] statusCode]
                                                                          userInfo:[NSDictionary dictionaryWithObject:@"Failed to Post Request. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
