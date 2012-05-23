//
//  Players.m
//  
//
//  Created by Kanav Gupta on 5/22/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "Players.h"

@implementation Players

@synthesize birthDate = birthDate;
@synthesize createdAt = createdAt;
@synthesize email = email;
@synthesize firstName = firstName;
@synthesize gender = gender;
@synthesize lastName = lastName;
@synthesize locationLat = locationLat;
@synthesize locationLng = locationLng;
@synthesize passwordDigest = passwordDigest;
@synthesize passwordStatus = passwordStatus;
@synthesize photoContentType = photoContentType;
@synthesize photoFileName = photoFileName;
@synthesize photoFileSize = photoFileSize;
@synthesize photoUpdatedAt = photoUpdatedAt;
@synthesize playersId = playersId;
@synthesize rememberToken = rememberToken;
@synthesize updatedAt = updatedAt;


- (void)dealloc {
    [birthDate release], birthDate = nil;
    [createdAt release], createdAt = nil;
    [email release], email = nil;
    [firstName release], firstName = nil;
    [gender release], gender = nil;
    [lastName release], lastName = nil;
    [locationLat release], locationLat = nil;
    [locationLng release], locationLng = nil;
    [passwordDigest release], passwordDigest = nil;
    [passwordStatus release], passwordStatus = nil;
    [photoContentType release], photoContentType = nil;
    [photoFileName release], photoFileName = nil;
    [photoFileSize release], photoFileSize = nil;
    [photoUpdatedAt release], photoUpdatedAt = nil;
    [playersId release], playersId = nil;
    [rememberToken release], rememberToken = nil;
    [updatedAt release], updatedAt = nil;

    [super dealloc];

}


+ (Players *)instanceFromDictionary:(NSDictionary *)aDictionary {

    Players *instance = [[[Players alloc] init] autorelease];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.birthDate = [aDictionary objectForKey:@"birth_date"];
    self.createdAt = [aDictionary objectForKey:@"created_at"];
    self.email = [aDictionary objectForKey:@"email"];
    self.firstName = [aDictionary objectForKey:@"first_name"];
    self.gender = [aDictionary objectForKey:@"gender"];
    self.lastName = [aDictionary objectForKey:@"last_name"];
    self.locationLat = [aDictionary objectForKey:@"location_lat"];
    self.locationLng = [aDictionary objectForKey:@"location_lng"];
    self.passwordDigest = [aDictionary objectForKey:@"password_digest"];
    self.passwordStatus = [aDictionary objectForKey:@"password_status"];
    self.photoContentType = [aDictionary objectForKey:@"photo_content_type"];
    self.photoFileName = [aDictionary objectForKey:@"photo_file_name"];
    self.photoFileSize = [aDictionary objectForKey:@"photo_file_size"];
    self.photoUpdatedAt = [aDictionary objectForKey:@"photo_updated_at"];
    self.playersId = [aDictionary objectForKey:@"id"];
    self.rememberToken = [aDictionary objectForKey:@"remember_token"];
    self.updatedAt = [aDictionary objectForKey:@"updated_at"];

}
+(NSArray*) responsesFromArray:(NSDictionary*) responsesA{
	if (!responsesA) {
		return Nil;
	}
	
	NSMutableArray *res = [[[NSMutableArray alloc] init] autorelease];
    
    Players *r = [Players instanceFromDictionary:responsesA];
    if (r) {
        [res addObject:r];
    }
	
	return res;	
}

@end
