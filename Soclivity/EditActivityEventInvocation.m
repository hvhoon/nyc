//
//  EditActivityEventInvocation.m
//  Soclivity
//
//  Created by Kanav on 9/14/12.
//
//

#import "EditActivityEventInvocation.h"
#import "JSON.h"
#import "InfoActivityClass.h"
@interface EditActivityEventInvocation (private)
-(NSString*)body;
@end


@implementation EditActivityEventInvocation
@synthesize playerId,activityObj,changePutUrlMethod;


-(void)dealloc {
	[super dealloc];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/activities/%d.json",activityObj.activityId];
    [self put:a
          body:[self body]];
}
-(NSString*)body {

	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    switch (changePutUrlMethod) {
        case 10:
        {
            [bodyD setObject:activityObj.where_lat forKey:@"where_lat"];
            [bodyD setObject:activityObj.where_lng forKey:@"where_lng"];
            
            if(activityObj.where_address!=nil&& [activityObj.where_address class]!=[NSNull class] && [activityObj.where_address length]!=0)
                [bodyD setObject:activityObj.where_address forKey:@"where_address"];
            if(activityObj.where_city!=nil && [activityObj.where_city class]!=[NSNull class] && [activityObj.where_city length]!=0)
                [bodyD setObject:activityObj.where_city forKey:@"where_city"];
            if(activityObj.where_state!=nil&& [activityObj.where_state class]!=[NSNull class] && [activityObj.where_state length]!=0)
                [bodyD setObject:activityObj.where_state forKey:@"where_state"];
            
            if(activityObj.where_zip!=nil&& [activityObj.where_zip class]!=[NSNull class] && [activityObj.where_zip length]!=0)
              [bodyD setObject:activityObj.where_zip forKey:@"where_zip"];
            
            if(activityObj.venueId!=nil&& [activityObj.venueId class]!=[NSNull class] && [activityObj.venueId length]!=0)
                [bodyD setObject:activityObj.where_zip forKey:@"venue_id"];

            
        }
            break;
            
        case 11:
        {
            [bodyD setObject:activityObj.access forKey:@"access"];
            
            
            [bodyD setObject:[NSNumber numberWithInt:activityObj.type] forKey:@"atype"];
            [bodyD setObject:activityObj.activityName forKey:@"name"];
            [bodyD setObject:[NSNumber numberWithInt:activityObj.num_of_people] forKey:@"num_of_people"];
            [bodyD setObject:activityObj.what forKey:@"what"];
            [bodyD setObject:activityObj.when forKey:@"when"];
            
        }
            break;
    }
    

   	return [bodyD JSONRepresentation];
}
-(BOOL)handleHttpOK:(NSMutableData *)data {
    NSError* error = nil;
    NSDictionary* resultsd = [[[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    
    
    NSString*resetStatus= [resultsd objectForKey:@"status"];
    NSLog(@"resetStatus=%@",resetStatus);
    [self.delegate EditActivityEventInvocationDidFinish:self withResponse:resetStatus requestType:changePutUrlMethod withError:error];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate EditActivityEventInvocationDidFinish:self
                                       withResponse:nil requestType:code
                                          withError:[NSError errorWithDomain:@"UserId"
                                                                        code:[[self response] statusCode]
                                                                    userInfo:[NSDictionary dictionaryWithObject:@"Failed to Update activity event. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
