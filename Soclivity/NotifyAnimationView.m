//
//  NotifyAnimationView.m
//  Soclivity
//
//  Created by Kanav Gupta on 17/02/13.
//
//

#import "NotifyAnimationView.h"
#import "TTTAttributedLabel.h"
#import "SoclivityUtilities.h"
#import "NotificationClass.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
static NSRegularExpression *__nameRegularExpression;
static inline NSRegularExpression * NameRegularExpression() {
    if (!__nameRegularExpression) {
        
        __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"#([^#(#)]+#)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __nameRegularExpression;
}



@implementation NotifyAnimationView
@synthesize summaryLabel,delegate;
- (id)initWithFrame:(CGRect)frame andNotif:(NotificationClass*)andNotif
{
    
        if(self=[super initWithFrame:frame]){
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            self.userInteractionEnabled = YES;
            self.opaque = NO;
            
            
            UIView *notificationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
            notificationView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"InAppAlertBar.png"]];
            
            UIImageView *imageViewFrame=[[UIImageView alloc] init];
            imageViewFrame.frame=CGRectMake(5, 5, 43, 43);
            imageViewFrame.image=[UIImage imageNamed:@"S11_frame.png"];
            
            UIImageView *leftImageView=[[UIImageView alloc] init];
            leftImageView.frame=CGRectMake(10, 10, 32, 32);
            leftImageView.backgroundColor=[UIColor clearColor];
            
            self.summaryLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            summaryLabel.frame=CGRectMake(50, 0, 200, 50);
            summaryLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
            summaryLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:12];
            summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
            summaryLabel.numberOfLines = 0;
            summaryLabel.highlightedTextColor = [UIColor whiteColor];
            summaryLabel.backgroundColor=[UIColor clearColor];
            
            [self setSummaryText:andNotif.notificationString];
            
            UIButton *btnclose=[UIButton buttonWithType:UIButtonTypeCustom];
            btnclose.frame=CGRectMake(295, 16, 19, 19);
            [btnclose setBackgroundImage:[UIImage imageNamed:@"InAppRemove.png"] forState:UIControlStateNormal];
            [btnclose addTarget:self action:@selector(HideNotification) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize imgSize;
            
            switch (1) {
                case 1:
                {
                    leftImageView.image=[UIImage imageNamed:@"S11_infoChangeIcon.png"];
                    imgSize=[leftImageView.image size];
                    leftImageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
                    
                }
                    break;
                    
                    
                case 2:
                {
                    leftImageView.image=[UIImage imageNamed:@"S11_calendarIcon.png"];
                    imgSize=[leftImageView.image size];
                    leftImageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
                    
                }
                    break;
                    
                case 3:
                {
                    leftImageView.image=[UIImage imageNamed:@"S11_clockLogo.png"];
                    imgSize=[leftImageView.image size];
                    leftImageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
                    
                }
                    break;
                    
                case 4:
                {
                    leftImageView.image=[UIImage imageNamed:@"S11_locationIcon.png"];
                    imgSize=[leftImageView.image size];
                    leftImageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
                    
                }
                    break;
                    
                    
                    
                    
                default:
                    break;
            }
            
            
            
            
            UIButton *btnaction=[UIButton buttonWithType:UIButtonTypeCustom];
            btnaction.frame=CGRectMake(0, 0, 320, 58);
            btnaction.backgroundColor=[UIColor clearColor];
            //btnaction.tag=[[[[dict valueForKey:@"userInfo"] valueForKey:@"activity"] valueForKey:@"id"] intValue];
            //[btnaction setTitle:[NSString stringWithFormat:@"%i",[[[dict valueForKey:@"userInfo"] valueForKey:@"notification_id"] intValue]] forState:UIControlStateNormal];
            [btnaction setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btnaction addTarget:self action:@selector(backgroundtap:) forControlEvents:UIControlEventTouchUpInside];
            
            [notificationView addSubview:btnclose];
            [notificationView addSubview:self.summaryLabel];
            [notificationView addSubview:leftImageView];
            [notificationView addSubview:btnaction];
            
            switch (6) {
                case 6:
                case 7:
                case 8:
                case 9:
                case 11:
                case 12:
                case 13:
                case 14:
                case 15:
                case 16:
                {
                    NSString *str=[NSString stringWithFormat:@"%@",andNotif.photoUrl];
                    leftImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
                    [notificationView addSubview:imageViewFrame];
                    [notificationView addSubview:leftImageView];
                    [self addSubview:notificationView];
                    
                }
                    break;
                    
                default:
                {
                    [self addSubview:notificationView];
                    
                }
                    break;
            }
            counter=0;
            timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTracker:) userInfo:nil repeats:YES];

            CGRect popupStartRect=CGRectMake(0, -58, 320, 58);
            CGRect popupEndRect=CGRectMake(0,0, 320, 58);
            self.frame = popupStartRect;
            self.alpha = 1.0f;
            [UIView animateWithDuration:0.35 delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
                self.frame = popupEndRect;
            } completion:^(BOOL finished) {
            }];
            
            
        }
    return self;
}

- (void)countdownTracker:(NSTimer *)theTimer {
    counter++;
    if (counter ==5){
        [timer invalidate];
        timer = nil;
        counter = 0;
        
        [self HideNotification];
    }
}

-(void)HideNotification{
    
    CGRect popupStartRect=CGRectMake(0, -58, 320, 58);
    [UIView animateWithDuration:0.7 delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
        self.frame = popupStartRect;
    } completion:^(BOOL finished) {
        self.alpha = 0.0f;

    }];

}

- (void)setSummaryText:(NSString *)text {
    [self.summaryLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();
        
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            UIFont *boldSystemFont =[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14.0];
            CTFontRef boldFont = CTFontCreateWithName(( CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (boldFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:( id)boldFont range:result.range];
                CFRelease(boldFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:result.range];
            }
        }];
        
        int hashCount = [[text componentsSeparatedByString:@"#"] count]-1;
        
        for (int i=0; i<hashCount; i++)
        {
            NSRange range = [[mutableAttributedString string] rangeOfString:@"#"];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(range.location, 1) withString:@""];
        }
        
        return mutableAttributedString;
    }];
}
-(void)backgroundtap:(UIButton*)sender{
    
#if 0
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://dev.soclivity.com/received_notification.json?id=%i",[[sender currentTitle] intValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"url=%@",url);
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSHTTPURLResponse *response = NULL;
	NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* resultsd = [[[NSString alloc] initWithData:returnData
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    SOC.loggedInUser.notification_count=[[resultsd objectForKey:@"badge"]integerValue];

    
    NSString *notifIds=SOC.loggedInUser.unread_notification;
    NSArray *unreadNotificationsArray=[resultsd objectForKey:@"unreadnotification"];
    NSString *finalIds=nil;
    
    if(notifIds != nil && [notifIds class] != [NSNull class] && ![notifIds isEqualToString:@""]){
        NSArray *commaSeperated=[notifIds componentsSeparatedByString:@","];
        NSMutableArray *testArray=[NSMutableArray arrayWithArray:commaSeperated];
            if([unreadNotificationsArray count]==0){
                SOC.loggedInUser.unread_notification=notifIds;
            }
            
            else{
                finalIds=[testArray objectAtIndex:0];
                for(int i=0;i<[unreadNotificationsArray count];i++){
                    
                    [testArray addObject:[unreadNotificationsArray objectAtIndex:i]];
                }
                
                for(int i=1;i<[testArray count];i++){
                    finalIds=[NSString stringWithFormat:@"%@,%@",finalIds,[testArray objectAtIndex:i]];

                }
                        SOC.loggedInUser.unread_notification=finalIds;
            }
        }
    
else{
    if([unreadNotificationsArray count]>0){
    finalIds=[unreadNotificationsArray objectAtIndex:0];
    for(int i=1;i<[unreadNotificationsArray count];i++){
        finalIds=[NSString stringWithFormat:@"%@,%@",finalIds,[unreadNotificationsArray objectAtIndex:i]];
        
    }
    SOC.loggedInUser.unread_notification=finalIds;
    }
    
    [delegate backgroundTapToPush];
}
//[[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:dictcount];
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
