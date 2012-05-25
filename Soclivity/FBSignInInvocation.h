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



@class FBSignInInvocation;

@protocol FBSignInInvocationDelegate 

-(void)FBSignInInvocationDidFinish:(FBSignInInvocation*)invocation
                           withResponse:(BOOL)responses
                              withError:(NSError*)error;

@end

@interface FBSignInInvocation : ProjectAsyncInvocation{
    NSString *email;
    NSString *fbuid;
    NSString *access_token;
}
@property (nonatomic, retain) NSString *email;
@property (nonatomic,retain)NSString *fbuid;
@property (nonatomic,retain)NSString*access_token;

@end
