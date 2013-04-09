//
//  InviteObjectClass+Parse.h
//  Soclivity
//
//  Created by Kanav on 10/5/12.
//
//

#import <Foundation/Foundation.h>
#import "InviteObjectClass.h"
@interface InviteObjectClass (Parse)


+(NSArray*)PlayersInvitesParse:(NSDictionary*)ACTDict;
+(NSArray*)PlayersAddressBookParse:(NSDictionary*)ACTDict;
+(NSArray*)PlayersInvitesGlobalSearchToActivity:(NSDictionary*)ACTDict;
+(NSArray*)PlayersInvitesToJoinSoclivityParse:(NSDictionary*)ACTDict;
@end
