//
//  SocPlayerClass.h
//  Soclivity
//
//  Created by Kanav on 10/1/12.
//
//

#import <Foundation/Foundation.h>

@interface SocPlayerClass : NSObject{
    
    UIImage *profileImage;
    NSString *profilePhotoUrl;
    NSString *playerName;
    NSInteger DOS;
    NSInteger activityType;
    NSString *activityTime;
    NSString *latestActivityName;
    NSInteger activityId;
    float distance;
    NSInteger friendId;
    BOOL isCurrentActivity;
    BOOL isCommon;
    NSMutableArray *commonFriends;
    NSString *fbUid;
}
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,retain)NSString *profilePhotoUrl;
@property (nonatomic,retain)NSString *playerName;
@property (nonatomic,assign)NSInteger DOS;
@property (nonatomic,assign)NSInteger activityType;
@property (nonatomic,assign)NSInteger activityId;
@property (nonatomic,assign)float distance;
@property (nonatomic,retain)NSString *latestActivityName;
@property (nonatomic,assign)NSInteger friendId;
@property (nonatomic,assign)BOOL isCurrentActivity;
@property (nonatomic,assign)BOOL isCommon;
@property (nonatomic,retain)NSMutableArray *commonFriends;
@property(nonatomic,retain)NSString*fbUid;
@property (nonatomic,retain)NSString*activityTime;
@end
