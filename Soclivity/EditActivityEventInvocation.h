//
//  EditActivityEventInvocation.h
//  Soclivity
//
//  Created by Kanav on 9/14/12.
//
//

#import <Foundation/Foundation.h>
#import "ProjectAsyncInvocation.h"
#import "SAServiceAsyncInvocation.h"


@class EditActivityEventInvocation;
@class InfoActivityClass;

@protocol EditActivityEventInvocationDelegate

-(void)EditActivityEventInvocationDidFinish:(EditActivityEventInvocation*)invocation
                                 withResponse:(NSString*)responses requestType:(int)requestType withError:(NSError*)error;

@end


@interface EditActivityEventInvocation : ProjectAsyncInvocation

@property (nonatomic,assign) NSInteger playerId;
@property (nonatomic,retain) InfoActivityClass *activityObj;
@property (nonatomic,assign) NSInteger changePutUrlMethod;


@end
