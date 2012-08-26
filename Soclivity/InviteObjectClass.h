//
//  InviteObjectClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteObjectClass : NSObject{
    
    NSString *userName;
    NSInteger typeOfRelation;
    NSInteger DOS;
    NSString *profilePhotoUrl;
    UIImage *profileImage;
    BOOL status;
    
}
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSString *profilePhotoUrl;
@property (nonatomic,retain)UIImage *profileImage;
@property (nonatomic,assign)NSInteger typeOfRelation;
@property (nonatomic,assign)NSInteger DOS;
@property (nonatomic,assign)BOOL status;
@end
