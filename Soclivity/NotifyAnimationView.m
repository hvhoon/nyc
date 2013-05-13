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
@synthesize summaryLabel,delegate,inAppNotif;
- (id)initWithFrame:(CGRect)frame andNotif:(NotificationClass*)andNotif
{
    
        if(self=[super initWithFrame:frame]){
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            
            self.userInteractionEnabled = YES;
            self.opaque = NO;
            
            inAppNotif=[andNotif retain];
            UIView *notificationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            notificationView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"InAppAlertBar.png"]];
            
            
            UIImageView *leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 29)];
            
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
            btnclose.frame=CGRectMake(280, 7, 38, 38);
            [btnclose setContentMode:UIViewContentModeCenter];
            [btnclose setImage:[UIImage imageNamed:@"InAppRemove.png"] forState:UIControlStateNormal];
            [btnclose addTarget:self action:@selector(HideNotification) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize imgSize;
            
            switch ([andNotif.notificationType intValue]) {
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
                case 17:
                {

                    NSString *str=[NSString stringWithFormat:@"%@",andNotif.photoUrl];
                    leftImageView.frame=CGRectMake(14, 7.5, 37, 37);
                    leftImageView.layer.cornerRadius = 5;
                    leftImageView.layer.masksToBounds = YES;
                    NSData *bytes=[NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
                    NSLog(@"Bytes Length=%d",[bytes length]);
                    leftImageView.image=[UIImage imageWithData:bytes];
                    
                }
                    break;
                    
            }
            
            [notificationView addSubview:leftImageView];
            UIButton *btnaction=[UIButton buttonWithType:UIButtonTypeCustom];
            btnaction.frame=CGRectMake(0, 0, 275, 60);
            btnaction.backgroundColor=[UIColor clearColor];
            [btnaction setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btnaction addTarget:self action:@selector(backgroundtap:) forControlEvents:UIControlEventTouchUpInside];
            
            [notificationView addSubview:btnclose];
            [notificationView addSubview:self.summaryLabel];
            [notificationView addSubview:btnaction];
            [self addSubview:notificationView];



            counter=0;
            timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTracker:) userInfo:nil repeats:YES];

            CGRect popupStartRect=CGRectMake(0, -60, 320, 60);
            CGRect popupEndRect=CGRectMake(0,0, 320, 60);
            self.frame = popupStartRect;
            self.alpha = 1.0f;
            [UIView animateWithDuration:0.35 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
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
    
    CGRect popupStartRect=CGRectMake(0, -60, 320, 60);
    [UIView animateWithDuration:0.7 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = popupStartRect;
    } completion:^(BOOL finished) {
        self.alpha = 0.0f;
        if ([self.delegate respondsToSelector:@selector(notificationViewHide)]){
            [self.delegate notificationViewHide];
        }

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
    
    NSLog(@"backgroundtap on in app notification");

#if 1
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    
    if([inAppNotif.notificationType integerValue]!=17){
        
    }
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://dev.soclivity.com/received_notification.json?id=%i",inAppNotif.notificationId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"url=%@",url);
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSHTTPURLResponse *response = NULL;
	NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* resultsd = [[[NSString alloc] initWithData:returnData
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    SOC.loggedInUser.badgeCount=[[resultsd objectForKey:@"badge"]integerValue];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];

#endif
    if (inAppNotif.backgroundTap) {
        
        [self HideNotification];
        [delegate backgroundTapToPush:inAppNotif];    
    }


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
