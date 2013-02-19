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
    UIImage *profileImage;
    NSString *count;
    NSInteger notificationId;
    NSString *userId;
    NSInteger activityId;
    NSString *expirationDate;
    NSString *photoUrl;
    NSString *latitude;
    NSString *longitude;
    NSString *notificationType;
    BOOL isRead;
    CGFloat rowHeight;
    NSString*timeOfNotification;
    NSInteger referredId;
}
@property (nonatomic,retain)NSString *notificationString;
@property (nonatomic,retain)NSString *date;
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSString *count;
@property (nonatomic,assign)NSInteger notificationId;
@property (nonatomic,retain)NSString *userId;
@property (nonatomic,assign)NSInteger activityId;
@property (nonatomic,retain)NSString*expirationDate;
@property (nonatomic,retain)NSString*photoUrl;
@property(nonatomic,retain)NSString *latitude;
@property(nonatomic,retain)NSString *longitude;
@property(nonatomic,retain)NSString *notificationType;
@property (nonatomic,assign)BOOL isRead;
@property(nonatomic,assign)CGFloat rowHeight;
@property(nonatomic,retain)NSString*timeOfNotification;
@property(nonatomic,assign)NSInteger referredId;
@end
