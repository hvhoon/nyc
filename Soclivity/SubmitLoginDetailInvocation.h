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


@class SubmitLoginDetailInvocation;

@protocol SubmitLoginDetailDelegate 

-(void)SubmitLoginDetailInvocationDidFinish:(SubmitLoginDetailInvocation*)invocation 
                                 withResult:(NSArray*)result
                                  withError:(NSError*)error;

@end


@interface SubmitLoginDetailInvocation : ProjectAsyncInvocation{
    
}
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSString *usePassword;

@end
