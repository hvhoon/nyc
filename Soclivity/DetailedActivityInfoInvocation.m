//
//  DetailedActivityInfoInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailedActivityInfoInvocation.h"
#import "JSON.h"

@implementation DetailedActivityInfoInvocation
@synthesize playerId,activityId,currentLongitude,currentLatitude;



-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    NSString *a= [NSString stringWithFormat:@"%@/getactivity.json?id=%d&pid=%d&lat=%f&lng=%f",ProductionServer,activityId,playerId,currentLatitude,currentLongitude];
    
    NSLog(@"a::%@",a);
    
     [self get:a];
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data 
                                               encoding:NSUTF8StringEncoding] JSONValue];
    
     NSLog(@"resultsd::%@",resultsd);
    
    InfoActivityClass* response =[InfoActivityClass DetailInfoParse:resultsd];
    
   // NSLog(@"response::%@",response);
    
	[self.delegate DetailedActivityInfoInvocationDidFinish:self withResponse:response withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate DetailedActivityInfoInvocationDidFinish:self 
                withResponse:nil
            withError:[NSError errorWithDomain:@"UserId" 
                code:[[self response] statusCode]
        userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get user. Please try again later" forKey:@"message"]]];
	return YES;
}



@end
