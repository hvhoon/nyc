//
//  ActivityChatData.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <Foundation/Foundation.h>


typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@interface ActivityChatData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic, strong) NSString *name;
@property (readonly, nonatomic,assign) NSBubbleType type;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic) BOOL showAvatars;


- (id)initWithText:(NSString *)text date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type;
+ (id)dataWithText:(NSString *)text date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type;
- (id)initWithImage:(UIImage *)image date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type;
+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type;
- (id)initWithView:(UIView *)view date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type insets:(UIEdgeInsets)insets;
+ (id)dataWithView:(UIView *)view date:(NSDate *)date name:(NSString*)name type:(NSBubbleType)type insets:(UIEdgeInsets)insets;



@end
