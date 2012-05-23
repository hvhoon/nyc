//
//  players_accel.m
//
//  Created by Harish Hoon on 5/21/12
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "players_accel.h"


@interface players_accel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation players_accel

@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize photoUpdatedAt = _photoUpdatedAt;
@synthesize birthDate = _birthDate;
@synthesize rememberToken = _rememberToken;
@synthesize photoContentType = _photoContentType;
@synthesize photoFileName = _photoFileName;
@synthesize createdAt = _createdAt;
@synthesize passwordDigest = _passwordDigest;
@synthesize firstName = _firstName;
@synthesize locationLat = _locationLat;
@synthesize passwordStatus = _passwordStatus;
@synthesize locationLng = _locationLng;
@synthesize updatedAt = _updatedAt;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize gender = _gender;
@synthesize photoFileSize = _photoFileSize;


+ (players_accel *)modelObjectWithDictionary:(NSDictionary *)dict
{
    players_accel *instance = [[[players_accel alloc] initWithDictionary:dict] autorelease];
    return instance;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.internalBaseClassIdentifier = [[dict objectForKey:@"id"] intValue];
            self.photoUpdatedAt = [self objectOrNilForKey:@"photo_updated_at" fromDictionary:dict];
            self.birthDate = [self objectOrNilForKey:@"birth_date" fromDictionary:dict];
            self.rememberToken = [self objectOrNilForKey:@"remember_token" fromDictionary:dict];
            self.photoContentType = [self objectOrNilForKey:@"photo_content_type" fromDictionary:dict];
            self.photoFileName = [self objectOrNilForKey:@"photo_file_name" fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:@"created_at" fromDictionary:dict];
            self.passwordDigest = [self objectOrNilForKey:@"password_digest" fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:@"first_name" fromDictionary:dict];
            self.locationLat = [self objectOrNilForKey:@"location_lat" fromDictionary:dict];
            self.passwordStatus = [self objectOrNilForKey:@"password_status" fromDictionary:dict];
            self.locationLng = [self objectOrNilForKey:@"location_lng" fromDictionary:dict];
            self.updatedAt = [self objectOrNilForKey:@"updated_at" fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:@"last_name" fromDictionary:dict];
            self.email = [self objectOrNilForKey:@"email" fromDictionary:dict];
            self.gender = [self objectOrNilForKey:@"gender" fromDictionary:dict];
            self.photoFileSize = [[dict objectForKey:@"photo_file_size"] intValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.internalBaseClassIdentifier] forKey:@"id"];
    [mutableDict setValue:self.photoUpdatedAt forKey:@"photo_updated_at"];
    [mutableDict setValue:self.birthDate forKey:@"birth_date"];
    [mutableDict setValue:self.rememberToken forKey:@"remember_token"];
    [mutableDict setValue:self.photoContentType forKey:@"photo_content_type"];
    [mutableDict setValue:self.photoFileName forKey:@"photo_file_name"];
    [mutableDict setValue:self.createdAt forKey:@"created_at"];
    [mutableDict setValue:self.passwordDigest forKey:@"password_digest"];
    [mutableDict setValue:self.firstName forKey:@"first_name"];
    [mutableDict setValue:self.locationLat forKey:@"location_lat"];
    [mutableDict setValue:self.passwordStatus forKey:@"password_status"];
    [mutableDict setValue:self.locationLng forKey:@"location_lng"];
    [mutableDict setValue:self.updatedAt forKey:@"updated_at"];
    [mutableDict setValue:self.lastName forKey:@"last_name"];
    [mutableDict setValue:self.email forKey:@"email"];
    [mutableDict setValue:self.gender forKey:@"gender"];
    [mutableDict setValue:[NSNumber numberWithInt:self.photoFileSize] forKey:@"photo_file_size"];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.internalBaseClassIdentifier = [aDecoder decodeIntegerForKey:@"internalBaseClassIdentifier"];
    self.photoUpdatedAt = [aDecoder decodeObjectForKey:@"photoUpdatedAt"];
    self.birthDate = [aDecoder decodeObjectForKey:@"birthDate"];
    self.rememberToken = [aDecoder decodeObjectForKey:@"rememberToken"];
    self.photoContentType = [aDecoder decodeObjectForKey:@"photoContentType"];
    self.photoFileName = [aDecoder decodeObjectForKey:@"photoFileName"];
    self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
    self.passwordDigest = [aDecoder decodeObjectForKey:@"passwordDigest"];
    self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
    self.locationLat = [aDecoder decodeObjectForKey:@"locationLat"];
    self.passwordStatus = [aDecoder decodeObjectForKey:@"passwordStatus"];
    self.locationLng = [aDecoder decodeObjectForKey:@"locationLng"];
    self.updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.gender = [aDecoder decodeObjectForKey:@"gender"];
    self.photoFileSize = [aDecoder decodeIntegerForKey:@"photoFileSize"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInteger:_internalBaseClassIdentifier forKey:@"internalBaseClassIdentifier"];
    [aCoder encodeObject:_photoUpdatedAt forKey:@"photoUpdatedAt"];
    [aCoder encodeObject:_birthDate forKey:@"birthDate"];
    [aCoder encodeObject:_rememberToken forKey:@"rememberToken"];
    [aCoder encodeObject:_photoContentType forKey:@"photoContentType"];
    [aCoder encodeObject:_photoFileName forKey:@"photoFileName"];
    [aCoder encodeObject:_createdAt forKey:@"createdAt"];
    [aCoder encodeObject:_passwordDigest forKey:@"passwordDigest"];
    [aCoder encodeObject:_firstName forKey:@"firstName"];
    [aCoder encodeObject:_locationLat forKey:@"locationLat"];
    [aCoder encodeObject:_passwordStatus forKey:@"passwordStatus"];
    [aCoder encodeObject:_locationLng forKey:@"locationLng"];
    [aCoder encodeObject:_updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:_lastName forKey:@"lastName"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeInteger:_photoFileSize forKey:@"photoFileSize"];
}


- (void)dealloc
{
    [_photoUpdatedAt release];
    [_birthDate release];
    [_rememberToken release];
    [_photoContentType release];
    [_photoFileName release];
    [_createdAt release];
    [_passwordDigest release];
    [_firstName release];
    [_locationLat release];
    [_passwordStatus release];
    [_locationLng release];
    [_updatedAt release];
    [_lastName release];
    [_email release];
    [_gender release];
    [super dealloc];
}

@end
