//
//  MessageSoundEffect.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MessageSoundEffect : NSObject
+ (void)playMessageReceivedSound;
+ (void)playMessageSentSound;


@end
