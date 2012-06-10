//
//  SoclivitySqliteClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoclivitySqliteClass : NSObject{
    
}
+(BOOL)openDatabase:(NSString*)dbPath;
+ (void) copyDatabaseIfNeeded;
+ (NSString *) getDBPath;

@end
