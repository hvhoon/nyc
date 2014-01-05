//
//  FeedbackBugReport.m
//  Soclivity
//
//  Created by Kanav Gupta on 14/05/13.
//
//

#import "FeedbackBugReport.h"
static FeedbackBugReport *sharedInstance = nil;
@implementation FeedbackBugReport
@synthesize message;


+ (FeedbackBugReport *)sharedInstance
{
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- (BOOL)canSendFeedback
{
    if ([MFMailComposeViewController canSendMail]) {
        return true;
    }
    
    return false;
    
}

-(UINavigationController*)sendBugAlertController{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"help@soclivity.com"];
    [picker setSubject:@"Bug Alert!"];
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:[self messageBody] isHTML:NO];
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0))
        [[picker navigationBar] setTintColor:[UIColor clearColor]];
    return picker;
}

-(UINavigationController*)reportActivityController:(NSString *)flagMessage {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"flag@soclivity.com"];
    [picker setSubject:@"Flag Activity"];
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:flagMessage isHTML:NO];
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0))
        [[picker navigationBar] setTintColor:[UIColor clearColor]];
    return picker;
}

- (MFMailComposeViewController *)sendFeedbackController
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"ideas@soclivity.com"];
    
    [picker setSubject:@"Feedback"];
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:[self messageBody] isHTML:NO];
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0))
        [[picker navigationBar] setTintColor:[UIColor clearColor]];
    return picker;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:Nil];
}


- (NSString *)messageBody
{
    
    // Getting the iOS environment settings
    
    NSDictionary *appMetaData = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [appMetaData objectForKey:@"CFBundleShortVersionString"];
    NSString* gitCommit = [appMetaData objectForKey:@"CFBundleVersion"];
    NSString* osVersion = [[UIDevice currentDevice] systemVersion];
    
    NSLog(@"App Version: %@, (%@)", appVersion, gitCommit);
    NSLog(@"iOS Version: %@", osVersion);
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat:@"\n\n\n\n--\nSoclivity %@ (%@)\niPhone iOS: %@", appVersion, gitCommit, osVersion];
    
    return emailBody;
}

@end
