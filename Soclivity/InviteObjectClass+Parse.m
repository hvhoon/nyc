//
//  InviteObjectClass+Parse.m
//  Soclivity
//
//  Created by Kanav on 10/5/12.
//
//

#import "InviteObjectClass+Parse.h"

@implementation InviteObjectClass (Parse)




+(NSArray*)PlayersInvitesParse:(NSDictionary*)ACTDict{
	if (!ACTDict) {
		return Nil;
	}
    
    NSMutableArray *content = [NSMutableArray new];
    
    NSNumber *openSlots = [ACTDict objectForKey:@"slots"];
    [[NSUserDefaults standardUserDefaults] setValue:openSlots forKey:@"ActivityOpenSlots"];


	NSArray*rdswArray =[ACTDict objectForKey:@"rdsw"];
    
    for(id obj in rdswArray){
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
        
        bool insertNewElement = TRUE;
        InviteObjectClass *play=[[[InviteObjectClass alloc]init]autorelease];

        NSNumber*invId=[obj objectForKey:@"id"];
        play.inviteId=[invId intValue];
        play.userName = [obj objectForKey:@"name"];
        play.typeOfRelation= 0;
        NSNumber * DOS = [obj objectForKey:@"dos"];
        play.DOS= [DOS intValue];
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[obj objectForKey:@"photo"]];
        NSString * status = [obj objectForKey:@"going"];
        if([status isEqualToString:@"yes"]){
            play.status=TRUE;
        }
        else{
            play.status=FALSE;
        }
        

        [row setValue:[NSNumber numberWithInt:0] forKey:@"relation"];
        
           for(NSDictionary *dict in content) {
                    NSNumber *headerKey = [dict objectForKey:@"relation"];
                    if ([headerKey intValue]==play.typeOfRelation) {
                        NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
                        [elements setValue:play forKey:@"ActivityInvite"];
                        [oldEntries addObject:elements];
                        insertNewElement = FALSE;
                        break;
                    }
                    else {
                        insertNewElement = TRUE;
                    }
                }
                
                
                if (insertNewElement) {
                    [elements setValue:play forKey:@"ActivityInvite"];
                    [entries addObject:elements];
                    [row setValue:entries forKey:@"Elements"];
                    [content addObject:row];
                }
        }
    
    NSArray*friendsOnSoclivityArray =[ACTDict objectForKey:@"fos"];
    
    for(id obj in friendsOnSoclivityArray){
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
        
        bool insertNewElement = TRUE;
        InviteObjectClass *play=[[[InviteObjectClass alloc]init]autorelease];
        
        NSNumber*invId=[obj objectForKey:@"id"];
        play.inviteId=[invId intValue];

        play.userName = [obj objectForKey:@"name"];
        play.typeOfRelation= 1;
        NSNumber * DOS = [obj objectForKey:@"dos"];
        play.DOS= [DOS intValue];
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[obj objectForKey:@"photo"]];
        NSString * status = [obj objectForKey:@"going"];
        if([status isEqualToString:@"yes"]){
            play.status=TRUE;
        }
        else{
            play.status=FALSE;
        }
        
        
        [row setValue:[NSNumber numberWithInt:1] forKey:@"relation"];
        
        for(NSDictionary *dict in content) {
            NSNumber *headerKey = [dict objectForKey:@"relation"];
            if ([headerKey intValue]==play.typeOfRelation) {
                NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
                [elements setValue:play forKey:@"ActivityInvite"];
                [oldEntries addObject:elements];
                insertNewElement = FALSE;
                break;
            }
            else {
                insertNewElement = TRUE;
            }
        }
        
        
        if (insertNewElement) {
            [elements setValue:play forKey:@"ActivityInvite"];
            [entries addObject:elements];
            [row setValue:entries forKey:@"Elements"];
            [content addObject:row];
        }
        
        
        
        
        
    }

    
    NSArray*friendsNotOnSoclivityArray =[ACTDict objectForKey:@"fnos"];
    
    for(id obj in friendsNotOnSoclivityArray){
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
        
        bool insertNewElement = TRUE;
        InviteObjectClass *play=[[[InviteObjectClass alloc]init]autorelease];
        
        NSNumber*invId=[obj objectForKey:@"id"];
        play.inviteId=[invId intValue];

        play.userName = [obj objectForKey:@"name"];
        play.typeOfRelation= 2;
        play.profilePhotoUrl=[NSString stringWithFormat:@"https://graph.facebook.com/%ld/picture",[invId longValue]];
        NSString * status = [obj objectForKey:@"going"];
        if([status isEqualToString:@"yes"]){
            play.status=TRUE;
        }
        else{
            play.status=FALSE;
        }
        
        
        [row setValue:[NSNumber numberWithInt:2] forKey:@"relation"];
        
        for(NSDictionary *dict in content) {
            NSNumber *headerKey = [dict objectForKey:@"relation"];
            if ([headerKey intValue]==play.typeOfRelation) {
                NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
                [elements setValue:play forKey:@"ActivityInvite"];
                [oldEntries addObject:elements];
                insertNewElement = FALSE;
                break;
            }
            else {
                insertNewElement = TRUE;
            }
        }
        
        
        if (insertNewElement) {
            [elements setValue:play forKey:@"ActivityInvite"];
            [entries addObject:elements];
            [row setValue:entries forKey:@"Elements"];
            [content addObject:row];
        }
        
        
        
        
        
    }

    
    
        return content;

    
}
+(NSArray*)PlayersAdressBookParse:(NSDictionary*)ACTDict{
    
    NSMutableArray *content = [NSMutableArray new];
    
    
    NSDictionary*abDict =[ACTDict objectForKey:@"ab"];
    NSArray *fosArray=[abDict objectForKey:@"fos"];
    
    
    for(id obj in fosArray){
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
        
        bool insertNewElement = TRUE;
        InviteObjectClass *play=[[[InviteObjectClass alloc]init]autorelease];
        
        NSNumber*invId=[obj objectForKey:@"id"];
        play.inviteId=[invId intValue];
        play.userName = [obj objectForKey:@"name"];
        play.typeOfRelation= 3;
        NSNumber * DOS = [obj objectForKey:@"dos"];
        play.DOS= [DOS intValue];
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[obj objectForKey:@"photo"]];
        NSString * status = [obj objectForKey:@"going"];
        if([status isEqualToString:@"yes"]){
            play.status=TRUE;
        }
        else{
            play.status=FALSE;
        }
        
        
        [row setValue:[NSNumber numberWithInt:3] forKey:@"relation"];
        
        for(NSDictionary *dict in content) {
            NSNumber *headerKey = [dict objectForKey:@"relation"];
            if ([headerKey intValue]==play.typeOfRelation) {
                NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
                [elements setValue:play forKey:@"ActivityInvite"];
                [oldEntries addObject:elements];
                insertNewElement = FALSE;
                break;
            }
            else {
                insertNewElement = TRUE;
            }
        }
        
        
        if (insertNewElement) {
            [elements setValue:play forKey:@"ActivityInvite"];
            [entries addObject:elements];
            [row setValue:entries forKey:@"Elements"];
            [content addObject:row];
        }
    }
    
    NSArray*friendsNotOnSoclivityArray =[abDict objectForKey:@"fnos"];
    
    for(id obj in friendsNotOnSoclivityArray){
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
        
        bool insertNewElement = TRUE;
        InviteObjectClass *play=[[[InviteObjectClass alloc]init]autorelease];
        
        NSNumber*invId=[obj objectForKey:@"id"];
        play.inviteId=[invId intValue];
        
        play.userName = [obj objectForKey:@"name"];
        play.typeOfRelation= 4;
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com/assets/picbox.png"];
        NSString * status = [obj objectForKey:@"going"];
        if([status isEqualToString:@"yes"]){
            play.status=TRUE;
        }
        else{
            play.status=FALSE;
        }
        
        
        [row setValue:[NSNumber numberWithInt:4] forKey:@"relation"];
        
        for(NSDictionary *dict in content) {
            NSNumber *headerKey = [dict objectForKey:@"relation"];
            if ([headerKey intValue]==play.typeOfRelation) {
                NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
                [elements setValue:play forKey:@"ActivityInvite"];
                [oldEntries addObject:elements];
                insertNewElement = FALSE;
                break;
            }
            else {
                insertNewElement = TRUE;
            }
        }
        
        
        if (insertNewElement) {
            [elements setValue:play forKey:@"ActivityInvite"];
            [entries addObject:elements];
            [row setValue:entries forKey:@"Elements"];
            [content addObject:row];
        }
        
        
        
        
        
    }
    return  content;
}
@end
