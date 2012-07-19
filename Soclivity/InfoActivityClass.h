//
//  InfoActivityClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoActivityClass : NSObject{
    NSInteger type;
    NSInteger stamp;
    
    NSString *organizerName;
    NSInteger DOS;
    NSInteger DOS1;
    NSInteger DOS2;
    NSInteger DOS3;
    NSString *distance;
    NSString *goingCount;
    NSString *where_lat;
    NSString *where_lng;
    NSArray *quotations;
    NSString *dateAndTime;
    NSString *activityType;
    NSString *access;
    NSString *created_at;
    NSInteger num_of_people;
    NSInteger activityId;
    NSString *activityName;
    NSInteger organizerId;
    NSString *updated_at;
    NSString *what;
    NSString *when;
    NSString *where_address;
    NSString *where_city;
    NSString *where_state;
    NSString *where_zip;
    BOOL isParticipant;
    NSString*ownerProfilePhotoUrl;
    UIImage *organizerImage;
    NSMutableArray *friendsOfFriendsArray;
    NSMutableArray *friendsArray;
    NSInteger relationType;
    
    
}
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSInteger stamp;
@property (nonatomic,retain)NSString *activityName;
@property (nonatomic,retain)NSString *organizerName;
@property (nonatomic,assign)NSInteger DOS;
@property (nonatomic,assign)NSInteger DOS1;
@property (nonatomic,assign)NSInteger DOS2;
@property (nonatomic,assign)NSInteger DOS3;
@property (nonatomic,retain)NSString *distance;
@property (nonatomic,retain)NSString *goingCount;
@property (nonatomic,retain) NSString *where_lat;
@property (nonatomic,retain) NSString *where_lng;
@property (nonatomic, retain) NSArray *quotations;
@property(nonatomic,retain)NSString *dateAndTime;


@property (nonatomic,retain)NSString *activityType;
@property(nonatomic,retain) NSString *access;
@property(nonatomic,retain) NSString *created_at;
@property (nonatomic,assign) NSInteger num_of_people;
@property (nonatomic,assign) NSInteger activityId;
@property (nonatomic,assign) NSInteger organizerId;
@property(nonatomic,retain) NSString *updated_at;
@property (nonatomic,retain)NSString *what;
@property (nonatomic,retain)NSString *when;
@property (nonatomic,retain)NSString *where_address;
@property (nonatomic,retain)NSString *where_city;
@property (nonatomic,retain)NSString *where_state;
@property (nonatomic,retain)NSString *where_zip;

@property (nonatomic,assign)BOOL isParticipant;
@property (nonatomic,retain)NSString*ownerProfilePhotoUrl;
@property (nonatomic,retain)UIImage *organizerImage;

@property(nonatomic,retain)NSMutableArray *friendsOfFriendsArray;
@property(nonatomic,retain)NSMutableArray *friendsArray;
@property (nonatomic,assign)NSInteger relationType;
@end
