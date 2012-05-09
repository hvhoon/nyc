//
//  GetPlayersDetailInvocation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAServiceAsyncInvocation.h"
#import "ProjectAsyncInvocation.h"
#import "ParseOperation.h"
@class GetPlayersDetailInvocation;

@protocol GetPlayersDetailDelegate 

-(void)GetPlayersDetailInvocationDidFinish:(GetPlayersDetailInvocation*)invocation 
                                 withResult:(NSArray*)result
                                  withError:(NSError*)error;

@end


@interface GetPlayersDetailInvocation : ProjectAsyncInvocation<ParseOperationDelegate>{
    NSOperationQueue*queue;
}
@property(nonatomic,retain) NSOperationQueue*queue;
@end
