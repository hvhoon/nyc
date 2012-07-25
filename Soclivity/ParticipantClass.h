//
//  ParticipantClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParticipantClass : NSObject{
    NSString *photoUrl;
    UIImage *profilePhotoImage;
    NSString *name;
    NSInteger participantId;
    NSInteger dosConnection;
}
@property (nonatomic,retain)NSString *photoUrl;
@property (nonatomic,retain)UIImage *profilePhotoImage;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,assign)NSInteger participantId;
@property (nonatomic,assign)NSInteger dosConnection;
@end
