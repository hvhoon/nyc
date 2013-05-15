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
    [picker setSubject:@"Report A Bug"];
    [picker setToRecipients:toRecipients];

    [picker setMessageBody:[self messageBody] isHTML:YES];
    
    
    [[[[(MFMailComposeViewController*)picker  navigationBar] items] objectAtIndex:0] setTitle:@"Bug Alert!"];
    
    
    [[picker navigationBar] setTintColor:[UIColor clearColor]];
    
     //picker.navigationController.navigationItem.titleView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S01.2_blackbar.png"]];
    
    //[[picker navigationBar] setBackgroundImage:[UIImage imageNamed:@"S01.2_blackbar.png"] forBarMetrics:UIBarMetricsDefault];
    //    UIImage *image = [UIImage imageNamed: @"S01.2_blackbar.png"];
    //    UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //    iv.image = image;
    //    iv.contentMode = UIViewContentModeCenter;
    //    [[[picker viewControllers] lastObject] navigationItem].titleView = iv;
    //    [[picker navigationBar] sendSubviewToBack:iv];
    //[iv release];
    
    //[picker release];
    
    return picker;
}

- (UINavigationController *)sendFeedbackController
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"ideas@soclivity.com"];
    
    [picker setSubject:@"Feedback"];
    [picker setToRecipients:toRecipients];

    [picker setMessageBody:[self messageBody] isHTML:YES];
    
    
    [[[[(MFMailComposeViewController*)picker  navigationBar] items] objectAtIndex:0] setTitle:@"Send us Feedback"];
    
    
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
    return [NSString stringWithFormat:@"Check out %@", @"kanav"];
}

- (NSString *)messageBody
{
    
    // Fill out the email body text
    NSMutableString *emailBody = [NSMutableString stringWithFormat:@"<div> \n"
                                  "<p style=\"font:10px Helvetica,Arial,sans-serif\">%@</p>"
                                  "<p style=\"font:10px Helvetica,Arial,sans-serif\">%@</p>"
                                  "</div>",
                                  @"iOS version",
                                  @"Soclivity Build ID"];
    
    return emailBody;
}

@end
