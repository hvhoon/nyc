//
//  PostActivityRequestInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostActivityRequestInvocation.h"
#import "JSON.h"


@implementation PostActivityRequestInvocation
@synthesize playerId,activityId,relationshipId;



-(void)dealloc {	
	[super dealloc];
}
-(void)invoke {
    
    NSString*a=nil;
    switch (relationshipId) {
      case 1:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/joinactivity.json?id=%d&pid=%d",activityId,playerId];
                [self post:a body:nil];
        }
            break;
            
      case 2:
      case 3:
      case 5:
      case 8:            
      case 9:      
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/leaveactivity.json?id=%d&pid=%d",activityId,playerId];
                [self post:a body:nil];
        }
            break;
            
    case 4:
    case 7:           
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/joinactivity.json?id=%d&pid=%d",activityId,playerId];
                [self put:a body:nil];
        }
            break;

     }


}

-(NSString*)body {
#if 1
	NSMutableDictionary* bodyD = [[[NSMutableDictionary alloc] init] autorelease];
    [bodyD setObject:@"TRUE" forKey:@"pStatus"];
    NSString *bodyData = [NSString stringWithFormat:@"%@",[bodyD JSONRepresentation]];
    
    NSLog(@"bodyData=%@",bodyData);
	return bodyData;
#endif
}


-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data 
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    NSString*resetStatus= [resultsd objectForKey:@"status"];
    NSLog(@"resetStatus=%@",resetStatus);
	[self.delegate PostActivityRequestInvocationDidFinish:self withResponse:resetStatus relationTypeTag:relationshipId withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate PostActivityRequestInvocationDidFinish:self 
                                             withResponse:@"" relationTypeTag:-1
                                                 withError:[NSError errorWithDomain:@"UserId" 
                        code:[[self response] statusCode]
                        userInfo:[NSDictionary dictionaryWithObject:@"Failed to Post Request. Please try again later" forKey:@"message"]]];
	return YES;
}


@end
