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
    NSString *latestActivityName;
    NSInteger activityId;
    float distance;
}
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,retain)NSString *profilePhotoUrl;
@property (nonatomic,retain)NSString *playerName;
@property (nonatomic,assign)NSInteger DOS;
@property (nonatomic,assign)NSInteger activityType;
@property (nonatomic,assign)NSInteger activityId;
@property (nonatomic,assign)float distance;
@property (nonatomic,retain)NSString *latestActivityName;
@end
