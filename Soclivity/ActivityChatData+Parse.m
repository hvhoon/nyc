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
@implementation ActivityChatData (Parse)
+(NSMutableArray*)PlayersChatPertainingToActivity:(NSArray*)ACTArray{
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
            
            ActivityChatData *replyBubble = [ActivityChatData dataWithText:[friend objectForKey:@"description"] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeMine];
            replyBubble.avatar = nil;
            replyBubble.showAvatars=NO;
            replyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
            replyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
            replyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
            
            [entries addObject:replyBubble];


        }else{
            ActivityChatData *heyBubble = [ActivityChatData dataWithText:[friend objectForKey:@"description"] date:lastDate name:[friend objectForKey:@"player_name"] type:BubbleTypeSomeoneElse];
            heyBubble.avatar = [UIImage imageNamed:@"picbox.png"];
            heyBubble.avatarUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[friend objectForKey:@"activity_photo_url"]];
            heyBubble.showAvatars=YES;
            heyBubble.chatId=[[friend objectForKey:@"id"]integerValue];
            heyBubble.activityId=[[friend objectForKey:@"activity_id"]integerValue];
            heyBubble.playerId=[[friend objectForKey:@"player_id"]integerValue];
            
            [entries addObject:heyBubble];

        }
    }
        return entries;
    
}

@end
