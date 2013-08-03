//
//  ActivityChatData+Parse.m
//  Soclivity
//
//  Created by Kanav Gupta on 08/03/13.
//
//

#import "ActivityChatData+Parse.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "Base64.h"
@implementation ActivityChatData (Parse)

+(NSArray*)PlayersDeltaPertainingToActivity:(NSDictionary*)data{
    return [ActivityChatData PlayersChatPertainingToActivity:[data objectForKey:@"backgrounchat"]];
}
+(NSArray*)PlayersChatPertainingToActivity:(NSArray*)ACTArray {
	if (!ACTArray) {
		return Nil;
	}
	
    
    
    NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
    for(id friend in ACTArray){
        
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        
        // how to get back time from current time in the same format
        NSDate *lastDate = [dateFormatter dateFromString:[friend objectForKey:@"created_at"]];//add the string
        
        if([SOC.loggedInUser.idSoc integerValue]==[[friend objectForKey:@"player_id"]integerValue]){
            
            if([[[NSString alloc] initWithData:[Base64 decode:[friend objectForKey:@"description"]]encoding:NSUTF8StringEncoding] isEqualToString:@"IMG"]){
                ActivityChatData *replyBubble = [ActivityChatData dataWithImage:[UIImage imageNamed:@"S05.3_chatImageFrame.png"] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeMine];
                replyBubble.postImageUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"activity_photo_url"]];
                
                replyBubble.avatar = nil;
                replyBubble.showAvatars=NO;
                replyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
                replyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
                replyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
                replyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
                
                [entries addObject:replyBubble];
                
            }
            else{
                
                
                ActivityChatData *replyBubble = [ActivityChatData dataWithText:[[NSString alloc] initWithData:[Base64 decode:[friend objectForKey:@"description"]]encoding:NSUTF8StringEncoding] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeMine];
                replyBubble.avatar = nil;
                replyBubble.showAvatars=NO;
                replyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
                replyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
                replyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
                replyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
                
                [entries addObject:replyBubble];
            }
            
        }else{
            
            if([[[NSString alloc] initWithData:[Base64 decode:[friend objectForKey:@"description"]]encoding:NSUTF8StringEncoding] isEqualToString:@"IMG"]){
                ActivityChatData *heyBubble = [ActivityChatData dataWithImage:[UIImage imageNamed:@"S05.3_chatImageFrame.png"] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeSomeoneElse];
                heyBubble.postImageUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"activity_photo_url"]];
                
                heyBubble.avatar = nil;
                heyBubble.avatarUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"player_photo"]];
                heyBubble.showAvatars=YES;
                heyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
                heyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
                heyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
                heyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
                [entries addObject:heyBubble];
                
            }
            else{
                ActivityChatData *heyBubble = [ActivityChatData dataWithText:[[NSString alloc] initWithData:[Base64 decode:[friend objectForKey:@"description"]]encoding:NSUTF8StringEncoding] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeSomeoneElse];
                heyBubble.avatar = nil;
                heyBubble.avatarUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"player_photo"]];
                heyBubble.showAvatars=YES;
                heyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
                heyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
                heyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
                heyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
                [entries addObject:heyBubble];
                
            }
            
            
        }
    }
    return entries;
    
}
+(ActivityChatData*)postChatTextIntercept:(NSDictionary*)data{
    NSDictionary *friend=[data objectForKey:@"activity_chat"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    NSDate *lastDate = [dateFormatter dateFromString:[friend objectForKey:@"created_at"]];//add the string
    
    
    ActivityChatData*replyBubble = [ActivityChatData dataWithText:[[NSString alloc] initWithData:[Base64 decode:[friend objectForKey:@"description"]]encoding:NSUTF8StringEncoding] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    replyBubble.showAvatars=NO;
    replyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
    replyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
    replyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
    replyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
    
    return replyBubble;
    
}
+(ActivityChatData*)postChatImageIntercept:(NSDictionary*)data{
    NSDictionary *friend=[data objectForKey:@"activity_chat"];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    NSDate *lastDate = [dateFormatter dateFromString:[friend objectForKey:@"created_at"]];//add the string
    
    
    ActivityChatData*replyBubble = [ActivityChatData dataWithImage:[UIImage imageNamed:@"S05.3_chatImageFrame.png"] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeMine];
    replyBubble.postImageUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"activity_photo_url"]];
    replyBubble.avatar = nil;
    replyBubble.showAvatars=NO;
    replyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
    replyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
    replyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
    replyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
    
    return replyBubble;
    
}

+(ActivityChatData*)getChatInterceptFromUsers:(NSDictionary*)data{
    
    
    
    NSDictionary *friend=[data objectForKey:@"activity_chat"];
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.loggedInUser.badgeCount=[[friend objectForKey:@"badge"]integerValue];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    NSDate *lastDate = [dateFormatter dateFromString:[friend objectForKey:@"created_at"]];//
    
    if([[friend objectForKey:@"description"] isEqualToString:@"IMG"]){
        ActivityChatData *heyBubble = [ActivityChatData dataWithImage:[UIImage imageNamed:@"S05.3_chatImageFrame.png"] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeSomeoneElse];
        heyBubble.postImageUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"activity_photo_url"]];
        
        heyBubble.avatar = nil;
        heyBubble.avatarUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"player_photo"]];
        heyBubble.showAvatars=YES;
        heyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
        heyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
        heyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
        heyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
        return heyBubble;
        
    }
    else{
        ActivityChatData *heyBubble = [ActivityChatData dataWithText:[[NSString alloc] initWithData:[Base64 decode:[friend objectForKey:@"description"]]encoding:NSUTF8StringEncoding] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeSomeoneElse];
        heyBubble.avatar = nil;
        heyBubble.avatarUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"player_photo"]];
        heyBubble.showAvatars=YES;
        heyBubble.ownerId=[[friend objectForKey:@"ownnerid"]integerValue];
        heyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
        heyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
        heyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
        return heyBubble;
        
    }
    
    
    
}


@end
