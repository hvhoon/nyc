//
//  NotificationClass.h
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import <Foundation/Foundation.h>

@interface NotificationClass : NSObject{
    NSString *notificationString;
    NSInteger type;
    NSString *date;
    //UIImage *profileImage;
    NSString *profileImage;
    NSString *count;
}
@property (nonatomic,retain)NSString *notificationString;
@property (nonatomic,retain)NSString *date;
//@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,retain)NSString *profileImage;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSString *count;

@end
