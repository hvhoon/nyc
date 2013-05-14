//
//  FeedbackBugReport.h
//  Soclivity
//
//  Created by Kanav Gupta on 14/05/13.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@interface FeedbackBugReport : NSObject<MFMailComposeViewControllerDelegate>{
    NSString *messageTitle;
    NSString *message;

}
@property (nonatomic, copy) NSString *messageTitle;
@property (nonatomic, copy) NSString *message;

+ (FeedbackBugReport *)sharedInstance;
- (BOOL)canSendFeedback;
- (UINavigationController *)sendFeedbackController;
-(UINavigationController*)sendBugAlertController;
@end
