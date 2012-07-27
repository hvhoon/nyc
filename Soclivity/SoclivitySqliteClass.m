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
#import "SoclivityManager.h"
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
			
        const char *sqlNewActivity ="INSERT OR REPLACE INTO Activities(name,activityId,atype,when_act,where_lat,where_lng,where_address,access,numofpeople,updated_at,Distance,ownnerid,dos0,ownername,dos1,dos2,dos3) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			/*const char *sqlNewActivity = "insert into Activities(name,atype,when_act,where_lat,where_lng,where_address,where_city,where_state,where_zip,what,access,numofpeople,ownnerid,created_at,updated_at) Values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";*/
			int error = sqlite3_prepare_v2(database, sqlNewActivity, -1, &insertStmtNewActivity, NULL);
			if(error != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(insertStmtNewActivity, 1, [ActObj.activityName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 2, ActObj.activityId);

        sqlite3_bind_int(insertStmtNewActivity, 3, ActObj.type);
		sqlite3_bind_text(insertStmtNewActivity, 4, [ActObj.when UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 5, [ActObj.where_lat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 6, [ActObj.where_lng UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 7, [ActObj.where_address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity,8, [ActObj.access UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 9, ActObj.num_of_people);
		sqlite3_bind_text(insertStmtNewActivity, 10, [ActObj.updated_at UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 11, [ActObj.distance UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 12, ActObj.organizerId);

        sqlite3_bind_int(insertStmtNewActivity, 13, ActObj.DOS);
        sqlite3_bind_text(insertStmtNewActivity,14, [ActObj.organizerName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 15, ActObj.DOS1);
        sqlite3_bind_int(insertStmtNewActivity, 16, ActObj.DOS2);
        sqlite3_bind_int(insertStmtNewActivity, 17, ActObj.DOS3);

		
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
    
	const char *sqlLevelQues5 = "select name,activityId,atype,when_act,where_lat,where_lng,where_address,access,numofpeople,updated_at,Distance,ownnerid,dos0,ownername,dos1,dos2,dos3 from Activities";
	
	
	if(sqlite3_prepare_v2(database, sqlLevelQues5, -1, &SOCTableActivityGetStmt, NULL)!=SQLITE_OK){
		NSAssert1(0,@"Error while updating From sqlLevelQues5.'%s'",sqlite3_errmsg(database));
	}
	
    
	while(sqlite3_step(SOCTableActivityGetStmt)==SQLITE_ROW){
		InfoActivityClass*play=[[[InfoActivityClass alloc]init]autorelease];
        DetailInfoActivityClass *quotation = [[[DetailInfoActivityClass alloc] init]autorelease];
		
		const char *nameChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt, 0);
		if(nameChars != NULL)
		{
			play.activityName = [NSString stringWithUTF8String:nameChars];
		}
        
        NSNumber *activityNumber=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 1)];
        play.activityId=[activityNumber intValue];

        
        NSNumber *n=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 2)];
        play.type=[n intValue];
 
		
		const char *when_actChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,3);
		if(when_actChars != NULL)
		{
			play.when = [NSString stringWithUTF8String: when_actChars];
		}
		
		const char *where_latChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,4);
		if(where_latChars != NULL)
		{
			play.where_lat = [NSString stringWithUTF8String: where_latChars];
		}
		
		const char *where_lngChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,5);
		if(where_lngChars != NULL)
		{
			play.where_lng = [NSString stringWithUTF8String: where_lngChars];
		}
		
		const char *where_addressChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,6);
		if(where_addressChars != NULL)
		{
			quotation.location = [NSString stringWithUTF8String: where_addressChars];
            play.where_address = [NSString stringWithUTF8String: where_addressChars];
		}
		
		const char *accessChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,7);
		if(accessChars != NULL)
		{
			play.access = [NSString stringWithUTF8String: accessChars];
		}
        NSNumber *NoOfPeople=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt,8)];
        play.num_of_people=[NoOfPeople intValue];
        


		const char *updated_atChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,9);
		if(updated_atChars != NULL)
		{
			play.updated_at = [NSString stringWithUTF8String: updated_atChars];
		}
        
        const char *distanceChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,10);
		if(distanceChars != NULL)
		{
			play.distance = [NSString stringWithUTF8String:distanceChars];
		}

        NSNumber *ownerIdNum=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 11)];
        play.organizerId=[ownerIdNum intValue];
        
        NSNumber *dosOwner=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 12)];
        play.DOS=[dosOwner intValue];
        
        const char *organizerNameChars = (const char *)sqlite3_column_text(SOCTableActivityGetStmt,13);
		if(organizerNameChars != NULL)
		{
			play.organizerName =[NSString stringWithUTF8String: organizerNameChars];
		}

        
        NSNumber *dos1=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 14)];
        play.DOS1=[dos1 intValue];
        
        NSNumber *dos2=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 15)];
        play.DOS2=[dos2 intValue];

        NSNumber *dos3=[NSNumber numberWithInt:sqlite3_column_int(SOCTableActivityGetStmt, 16)];
        play.DOS3=[dos3 intValue];



        
        if([SoclivityUtilities ValidActivityDate:play.when]){
            
            
            NSString *message=[SoclivityUtilities NetworkTime:play];
#if 0        
            SoclivityManager *SOC=[SoclivityManager SharedInstance];
            CLLocationDegrees latitude  = [play.where_lat  doubleValue];
            CLLocationDegrees longitude = [play.where_lng  doubleValue];
            CLLocation *tempLocObj = [[CLLocation alloc] initWithLatitude:latitude
                                                                longitude:longitude];
            
            CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:SOC.currentLocation.coordinate.latitude
                                                                longitude:SOC.currentLocation.coordinate.longitude];

            play.distance =[NSString stringWithFormat:@"%.02f",[newCenter distanceFromLocation:tempLocObj] / 1000];
#endif            
            play.goingCount=[NSString stringWithFormat:@"%d",play.DOS1+play.DOS2+play.DOS3];
            NSLog(@"message=%@",message);

            NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:1];
            quotation.DOS_1=play.DOS1;
            quotation.DOS_2=play.DOS2;
            [quotations addObject:quotation];
             play.quotations = quotations;
                
            [listOfValidActivitiesArray addObject:play];
            }
        }
      return listOfValidActivitiesArray;
	}
    
	
+(void)UpadateTheActivityEventTable:(InfoActivityClass*)ActObj{
	
    
    [SoclivitySqliteClass deleteActivityRecords:ActObj.activityId];
    
	sqlite3_stmt *insertStmtNewActivity=nil;
    
    
		
		if(insertStmtNewActivity == nil) {
			
            const char *sqlNewActivity ="INSERT OR REPLACE INTO Activities(name,activityId,atype,when_act,where_lat,where_lng,where_address,access,numofpeople,updated_at,Distance,ownnerid,dos0,ownername,dos1,dos2,dos3) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
			int error = sqlite3_prepare_v2(database, sqlNewActivity, -1, &insertStmtNewActivity, NULL);
			if(error != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(insertStmtNewActivity, 1, [ActObj.activityName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 2, ActObj.activityId);
        
        sqlite3_bind_int(insertStmtNewActivity, 3, ActObj.type);
		sqlite3_bind_text(insertStmtNewActivity, 4, [ActObj.when UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 5, [ActObj.where_lat UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 6, [ActObj.where_lng UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insertStmtNewActivity, 7, [ActObj.where_address UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity,8, [ActObj.access UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 9, ActObj.num_of_people);
		sqlite3_bind_text(insertStmtNewActivity, 10, [ActObj.updated_at UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStmtNewActivity, 11, [ActObj.distance UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 12, ActObj.organizerId);
        
        sqlite3_bind_int(insertStmtNewActivity, 13, ActObj.DOS);
        sqlite3_bind_text(insertStmtNewActivity,14, [ActObj.organizerName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(insertStmtNewActivity, 15, ActObj.DOS1);
        sqlite3_bind_int(insertStmtNewActivity, 16, ActObj.DOS2);
        sqlite3_bind_int(insertStmtNewActivity, 17, ActObj.DOS3);
        
		
		if(SQLITE_DONE != sqlite3_step(insertStmtNewActivity))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(insertStmtNewActivity);
}

+(void)deleteActivityRecords:(NSInteger)activityId{
	sqlite3_stmt *deleteStmtRecord=nil;
	
	if(deleteStmtRecord == nil) {
		
		NSString *str_queryLevel2 = [NSString stringWithFormat:@"delete from Activities where activityId = %d",activityId];
		const char *sql = [str_queryLevel2 UTF8String];
		
		
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmtRecord, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	
	if (SQLITE_DONE != sqlite3_step(deleteStmtRecord)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmtRecord);
}


    

@end
