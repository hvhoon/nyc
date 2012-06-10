//
//  SoclivitySqliteClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivitySqliteClass.h"
#import <sqlite3.h>
static sqlite3 *database = nil;
@implementation SoclivitySqliteClass


+ (NSString *) getDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
}

+(BOOL)openDatabase:(NSString*)dbPath{
	BOOL openT=FALSE;
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		openT=TRUE;
	}
    else
        sqlite3_close(database);
	return openT;
}
+ (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	NSLog(@"dbPath=%@",dbPath);
	
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
		NSLog(@"defaultDBPath=%@",defaultDBPath);
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

@end
