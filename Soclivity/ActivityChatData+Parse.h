//
//  ActivityChatData+Parse.h
//  Soclivity
//
//  Created by Kanav Gupta on 08/03/13.
//
//
#import  <Foundation/Foundation.h>
#import "ActivityChatData.h"
@interface ActivityChatData (Parse)

+(NSArray*)PlayersChatPertainingToActivity:(NSArray*)ACTArray;
+(ActivityChatData*)postChatTextIntercept:(NSDictionary*)data;
+(ActivityChatData*)postChatImageIntercept:(NSDictionary*)data;
@end
