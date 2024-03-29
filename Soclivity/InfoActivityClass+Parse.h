//
//  InfoActivityClass+Parse.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoActivityClass.h"

@interface InfoActivityClass (Parse)

+(InfoActivityClass*) ActivitiesFromDictionary:(NSDictionary*)ACTDict isQuotation:(BOOL)isQuotation;
+(NSArray*) ActivitiesFromArray:(NSArray*) ActivitiesSchedulesAt;
+(InfoActivityClass*) DetailInfoParse:(NSDictionary*)ACTDict;
+(NSArray*)GetAllActivitiesForTheUser:(NSDictionary*)ACTDict;
@end
