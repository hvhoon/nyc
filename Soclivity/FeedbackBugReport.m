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
@synthesize messageTitle;
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
//<<<<<<< HEAD
//    [picker setSubject:@"Report A Bug"];
//=======
    
    [picker setSubject:@"Bug Alert!"];
//>>>>>>> 377bff0fc3e9fec99936dac9ac71a89cb48d9312
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:[self messageBody] isHTML:NO];
    [[picker navigationBar] setTintColor:[UIColor clearColor]];
    return picker;
}

- (UINavigationController *)sendFeedbackController
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"ideas@soclivity.com"];
    
    [picker setSubject:@"Feedback"];
    [picker setToRecipients:toRecipients];
    [picker setMessageBody:[self messageBody] isHTML:NO];
    [[picker navigationBar] setTintColor:[UIColor clearColor]];
    return picker;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

- (NSString *)messageTitle
{
    if (messageTitle)
    {
        return messageTitle;
    }
    return [NSString stringWithFormat:@"Check out %@", @"Kanav"];
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
