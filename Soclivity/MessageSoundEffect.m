//
//  MessageSoundEffect.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "MessageSoundEffect.h"

@interface MessageSoundEffect ()

+ (void)playSoundWithName:(NSString *)name type:(NSString *)type;

@end

@implementation MessageSoundEffect

+ (void)playSoundWithName:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSURL *url = [NSURL fileURLWithPath:path];
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"**** Sound Error: file not found: %@", path);
    }
}

+ (void)playMessageReceivedSound
{
    [MessageSoundEffect playSoundWithName:@"messageReceived" type:@"aiff"];
}

+ (void)playMessageSentSound
{
    [MessageSoundEffect playSoundWithName:@"messageSent" type:@"aiff"];
}


@end
