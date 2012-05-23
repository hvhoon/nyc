//
//  Players.h
//  
//
//  Created by Kanav Gupta on 5/22/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Players : NSObject {
    NSString *birthDate;
    NSString *createdAt;
    NSString *email;
    NSString *firstName;
    NSString *gender;
    NSString *lastName;
    NSString *locationLat;
    NSString *locationLng;
    NSString *passwordDigest;
    id passwordStatus;
    NSString *photoContentType;
    NSString *photoFileName;
    NSNumber *photoFileSize;
    NSString *photoUpdatedAt;
    NSNumber *playersId;
    id rememberToken;
    NSString *updatedAt;
}

@property (nonatomic, copy) NSString *birthDate;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *locationLat;
@property (nonatomic, copy) NSString *locationLng;
@property (nonatomic, copy) NSString *passwordDigest;
@property (nonatomic, retain) id passwordStatus;
@property (nonatomic, copy) NSString *photoContentType;
@property (nonatomic, copy) NSString *photoFileName;
@property (nonatomic, copy) NSNumber *photoFileSize;
@property (nonatomic, copy) NSString *photoUpdatedAt;
@property (nonatomic, copy) NSNumber *playersId;
@property (nonatomic, retain) id rememberToken;
@property (nonatomic, copy) NSString *updatedAt;

+ (Players *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+(NSArray*) responsesFromArray:(NSDictionary*) responsesA;
@end
