//
//  FBSignInInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"
#import "ParseOperation.h"


@class FBSignInInvocation;

@protocol FBSignInInvocationDelegate 

-(void)FBSignInInvocationDidFinish:(FBSignInInvocation*)invocation
                           withResponse:(NSArray*)responses
                              withError:(NSError*)error;

@end

@interface FBSignInInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
    NSString *email;
    NSString *fbuid;
    NSString *access_token;
    NSOperationQueue*queue;
}
@property(nonatomic,retain) NSOperationQueue*queue;
@property (nonatomic, retain) NSString *email;
@property (nonatomic,retain)NSString *fbuid;
@property (nonatomic,retain)NSString*access_token;

@end
