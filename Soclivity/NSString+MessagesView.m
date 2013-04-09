//
//  NSString+MessagesView.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "NSString+MessagesView.h"

@implementation NSString (MessagesView)

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace(( CFMutableStringRef)str);
    return str;
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}


@end
