//
//  players_accel.h
//
//  Created by Harish Hoon on 5/21/12
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface players_accel : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger internalBaseClassIdentifier;
@property (nonatomic, retain) NSString *photoUpdatedAt;
@property (nonatomic, retain) NSString *birthDate;
@property (nonatomic, retain) NSString *rememberToken;
@property (nonatomic, retain) NSString *photoContentType;
@property (nonatomic, retain) NSString *photoFileName;
@property (nonatomic, retain) NSString *createdAt;
@property (nonatomic, retain) NSString *passwordDigest;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *locationLat;
@property (nonatomic, retain) NSString *passwordStatus;
@property (nonatomic, retain) NSString *locationLng;
@property (nonatomic, retain) NSString *updatedAt;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, assign) NSInteger photoFileSize;

+ (players_accel *)modelObjectWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
