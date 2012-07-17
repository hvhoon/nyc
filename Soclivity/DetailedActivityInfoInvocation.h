//
//  DetailedActivityInfoInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "InfoActivityClass.h"
#import "InfoActivityClass+Parse.h"

@class DetailedActivityInfoInvocation;

@protocol DetailedActivityInfoInvocationDelegate 

-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                        withResponse:(InfoActivityClass*)responses
                           withError:(NSError*)error;

@end

@interface DetailedActivityInfoInvocation : ProjectAsyncInvocation

@property (nonatomic, assign) NSInteger playerId;
@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic, assign) float  currentLatitude;
@property (nonatomic, assign) float  currentLongitude;

@end
