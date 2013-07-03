//
//  AutoSessionClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 02/07/13.
//
//

#import <Foundation/Foundation.h>
#import "FacebookLogin.h"

@protocol AutoSessionClassDelegate <NSObject>

@optional
-(void)pushSlidingViewController;
-(void)sessionLogout;
@end


@interface AutoSessionClass : NSObject<FacebookLoginDelegate>{
    id <AutoSessionClassDelegate>delegate;
}
-(void)isFacebookTokenValid;
@property(nonatomic,retain)id<AutoSessionClassDelegate>delegate;
@end
