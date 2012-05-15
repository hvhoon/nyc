//
//  MainServiceManager.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAService.h"
#import "RegistrationDetailInvocation.h"
#import "GetPlayersDetailInvocation.h"
@interface MainServiceManager : SAService{
    
}

-(void)registrationDetailInvocation:(id<RegistrationDetailDelegate>)delegate;
-(void)GetPlayersInvocation:(id<GetPlayersDetailDelegate>)delegate;
@end
