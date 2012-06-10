//
//  GetActivitiesInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "ParseOperation.h"

@class GetActivitiesInvocation;

@protocol GetActivitiesInvocationDelegate 

-(void)ActivitiesInvocationDidFinish:(GetActivitiesInvocation*)invocation
                   withResponse:(NSArray*)responses
                      withError:(NSError*)error;

@end

@interface GetActivitiesInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
     NSOperationQueue*queue;
}
@property(nonatomic,retain) NSOperationQueue*queue;
@property (nonatomic, assign) NSInteger userSOCId;
@property (nonatomic, assign) float  currentLatitude;
@property (nonatomic, assign) float  currentLongitude;
@property (nonatomic, retain) NSString*timeSpan;
@property (nonatomic, retain) NSString*lastUpdated;
@end

