//
//  SocPlayerClass+Parse.h
//  Soclivity
//
//  Created by Kanav on 11/3/12.
//
//

#import <Foundation/Foundation.h>
#import "SocPlayerClass.h"

@interface SocPlayerClass (Parse)

+(SocPlayerClass*)GetUserProfileInfoAndCommonFriends:(NSDictionary*)ACTDict;
+(SocPlayerClass*)GetUserProfileInfoActivityPlusCommonFriends:(NSDictionary*)ACTDict;
@end
