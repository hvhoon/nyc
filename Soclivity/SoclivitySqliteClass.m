//
//  SoclivitySqliteClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivitySqliteClass.h"
#import <sqlite3.h>
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"
#import "DetailInfoActivityClass.h"
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
#pragma mark -
#pragma mark InsertNewActivities Method

+(void)InsertNewActivities:(NSArray*)ActivityArray{
	
	sqlite3_stmt *insertStmtNewActivity=nil;
	
	[SoclivitySqliteClass deleteAllActivitiesPriorToThisRequest];
    
    for(InfoActivityClass *ActObj in ActivityArray){
        
		
		if(insertStmtNewActivity == nil) {
			
			const char *sqlNewActivity = "insert into Activities(name,atype,when_act,where_lat,where_lng,where_address,where_city,where_state,where_zip,what,access,numofpeople,ownnerid,created_at,updated_at) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			int error = sqlite3_prepare_v2(database, sqlNewActivity, -1, &insertStmtNewActivity, NULL);
			if(error != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(insertStmtNewActivity, 1, [ActObj.activityName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 2, ActObj.type);
		sqlite3_bind_text(insertStmtNewActivity, 3, [ActObj.when UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 4, [ActObj.where_lat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 5, [ActObj.where_lng UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 6, [ActObj.where_address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 7, [ActObj.where_city UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 8, [ActObj.where_state UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 9, [ActObj.where_zip UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 10, [ActObj.what UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 11, [ActObj.access UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 12, ActObj.num_of_people);
        sqlite3_bind_int(insertStmtNewActivity, 13, ActObj.OwnerId);
        sqlite3_bind_text(insertStmtNewActivity, 14, [ActObj.created_at UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 15, [ActObj.updated_at UTF8String], -1, SQLITE_TRANSIENT);

		
		if(SQLITE_DONE != sqlite3_step(insertStmtNewActivity))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(insertStmtNewActivity);
	}
	
}
#pragma mark -
#pragma mark deleteAllActivitiesPriorToThisRequest Method

+(void)deleteAllActivitiesPriorToThisRequest{
	sqlite3_stmt *deleteStmtActivities=nil;
	
	if(deleteStmtActivities == nil) {
		
		const char *sql ="delete from Activities";
        
		
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmtActivities, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	
	if (SQLITE_DONE != sqlite3_step(deleteStmtActivities)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmtActivities);
}

+(NSArray*)returnAllValidActivities{
	
	NSMutableArray *listOfValidActivitiesArray=[[NSMutableArray alloc]init];
    
	sqlite3_stmt *SOCTableActivityGetStmt;
    
	const char *sqlLevelQues5 = "select name,atype,when_act,where_lat,where_lng,where_address,where_city,where_state,where_zip,what,access,numofpeople,ownnerid,created_at,updated_at from Activities";
	
	
	if(sqlite3_prepare_v2(database, sqlLevelQues5, -1, &SOCTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From EMS_table5Ques.'%s'",sqlite3_errmsg(database));
	}
	
    
	while(sqlite3_step(SOCTableActivityGetStmt)==SQLITE_ROW){
		InfoActivityClass*play=[[[InfoActivityClass alloc]init]autorelease];
        DetailInfoActivityClass *quotation = [[[DetailInfoActivityClass alloc] init]autorelease];
		
		const char *nameChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt, 0);
		if(nameChars != NULL)
		{
			play.activityName = [NSString stringWithUTF8String:nameChars];
		}
        
        NSNumber *n=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 1)];
        play.type=[n intValue];
 
		
		const char *when_actChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,2);
		if(when_actChars != NULL)
		{
			play.when = [NSString stringWithUTF8String: when_actChars];
		}
		
		const char *where_latChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,3);
		if(where_latChars != NULL)
		{
			play.where_lat = [NSString stringWithUTF8String: where_latChars];
		}
		
		const char *where_lngChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,4);
		if(where_lngChars != NULL)
		{
			play.where_lng = [NSString stringWithUTF8String: where_lngChars];
		}
		
		const char *where_addressChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,5);
		if(where_addressChars != NULL)
		{
			quotation.location = [NSString stringWithUTF8String: where_addressChars];
		}
		
		const char *where_cityChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,6);
		if(where_cityChars != NULL)
		{
			play.where_city = [NSString stringWithUTF8String: where_cityChars];
		}
        const char *where_stateChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,7);
		if(where_stateChars != NULL)
		{
			play.where_state = [NSString stringWithUTF8String: where_stateChars];
		}
		const char *where_zipChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,8);
		if(where_zipChars != NULL)
		{
			play.where_zip = [NSString stringWithUTF8String: where_zipChars];
		}
		const char *whatChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,9);
		if(whatChars != NULL)
		{
			play.what = [NSString stringWithUTF8String: whatChars];
		}
		const char *accessChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,10);
		if(accessChars != NULL)
		{
			play.access = [NSString stringWithUTF8String: accessChars];
		}
        NSNumber *NoOfPeople=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 11)];
        play.num_of_people=[NoOfPeople intValue];
        
        NSNumber *ownerId=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 12)];
        play.OwnerId=[ownerId intValue];


		const char *created_atChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,13);
		if(created_atChars != NULL)
		{
			play.created_at = [NSString stringWithUTF8String: created_atChars];
		}
		const char *updated_atChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,14);
		if(updated_atChars != NULL)
		{
			play.updated_at = [NSString stringWithUTF8String: updated_atChars];
		}
        
        if([SoclivityUtilities ValidActivityDate:play.when]){
            
            
            NSString *message=[SoclivityUtilities NetworkTime:play];
            play.distance=@"0.89";
            play.organizerName=@"Shahved Katoch";
            play.goingCount=@"34";
            play.DOS=@"2";
            NSLog(@"message=%@",message);

            NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:1];
            quotation.DOS_1=3;
            quotation.DOS_2=3;
            [quotations addObject:quotation];
             play.quotations = quotations;
                
            [listOfValidActivitiesArray addObject:play];
            }
        }
      return listOfValidActivitiesArray;
	}
    
	
	
    

@end
