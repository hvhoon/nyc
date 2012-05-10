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
@property (nonatomic,retain)NSString *first_name;
@property (nonatomic,retain)NSString *last_name;
@property (nonatomic,retain)NSString *email;
@property (nonatomic,retain)NSString *birth_date;
@property (nonatomic,retain)NSString *password;
@property (nonatomic,retain)NSString *password_confirmation;
@property (nonatomic,retain)NSString *activities;

@end
