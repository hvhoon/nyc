//
//  SubmitLoginDetailInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"
#import "ProjectAsyncInvocation.h"
#import "ParseOperation.h"

@class RegistrationDetailInvocation;

@protocol RegistrationDetailDelegate 

-(void)RegistrationDetailInvocationDidFinish:(RegistrationDetailInvocation*)invocation 
                                  withResult:(NSArray*)result andUpdateType:(BOOL)andUpdateType
                                  withError:(NSError*)error;

@end


@interface RegistrationDetailInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
     NSOperationQueue*queue;
    BOOL isFacebookUser;
    BOOL activityTypeUpdate;
}
@property (nonatomic,assign)BOOL activityTypeUpdate;
@property(nonatomic,retain) NSOperationQueue*queue;
@property (nonatomic,assign)BOOL isFacebookUser;
-(NSString*)returnActivityType;
@end
