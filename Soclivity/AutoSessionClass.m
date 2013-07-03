//
//  AutoSessionClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 02/07/13.
//
//

#import "AutoSessionClass.h"
#import "SoclivityUtilities.h"
#import "AppDelegate.h"
@implementation AutoSessionClass
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)isFacebookTokenValid{
    if([SoclivityUtilities hasNetworkConnection]){
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FacebookLogin *fbLogin=[appDelegate SetUpFacebook];
        fbLogin.tagUniqKey=kAutoLoginProperty;
        fbLogin.FBdelegate=self;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
    }

}
-(void)sessionLogout{
    [delegate sessionLogout];
}
-(void)pushToHomeViewController{
    NSLog(@"Auto Session Mainatined");
    [delegate pushSlidingViewController];
}
@end
