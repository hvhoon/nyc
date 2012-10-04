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
    [activityObj release];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"dev.soclivity.com/activities/%d.json",activityObj.activityId];
    [self put:a
          body:[self body]];
}
-(NSString*)body {
#if 1
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    [bodyD setObject:activityObj.where_lat forKey:@"where_lat"];
    [bodyD setObject:activityObj.where_lng forKey:@"where_lng"];
    [bodyD setObject:activityObj.where_address forKey:@"where_address"];
    [bodyD setObject:activityObj.where_zip forKey:@"where_zip"];
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif
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