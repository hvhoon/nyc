//
//  PostActivityRequestInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"


@class PostActivityRequestInvocation;

@protocol PostActivityRequestInvocationDelegate 

-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                     withError:(NSError*)error;

@end


@interface PostActivityRequestInvocation : ProjectAsyncInvocation


@property (nonatomic,assign) NSInteger playerId;
@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic,assign) NSInteger relationshipId;
@end
