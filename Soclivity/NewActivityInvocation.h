//
//  NewActivityInvocation.h
//  Soclivity
//
//  Created by Kanav on 10/12/12.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"


@class NewActivityInvocation;
@class InfoActivityClass;
@protocol NewActivityRequestInvocationDelegate

-(void)PostNewActivityRequestInvocationDidFinish:(NewActivityInvocation*)invocation
                                 withResponse:(InfoActivityClass*)responses 
                                    withError:(NSError*)error;

@end


@interface NewActivityInvocation : ProjectAsyncInvocation{
    InfoActivityClass *activityObj;
}
@property (nonatomic,retain)InfoActivityClass *activityObj;
@end
