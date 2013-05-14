//
//  SlideViewController.m
//  SlideViewController
//

#import "SlideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "SoclivityUtilities.h"
#import "ProfileViewController.h"
#import "NotificationsViewController.h"
#import "UpComingCompletedEventsViewController.h"
#import "InvitesViewController.h"
#import "AboutViewController.h"
#import "JMC.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "MBProgressHUD.h"
#import "MainServiceManager.h"
#import "RegistrationDetailInvocation.h"
#import "FeedbackBugReport.h"
#define kSVCLeftAnchorX                 100.0f
#define kSVCRightAnchorX                190.0f
#define kSVCSwipeNavigationBarOnly      YES


#define kProfileView 1
#define kActivityFeed 2
#define kWaitingOnU 3
#define kUpcoming_Completed 4
#define kInvite 5
#define kSendUsFeedback 6
#define kBugAlert 7
#define kBlockedList 8
#define kAbout 9
#define kCalendarSync 10
#define kSignOut 11

#define cellHeightDefault 44
#define cellHeightSmall 35
#define cellHeightLarge  64
#define cellHeightSignOut 44

@interface SlideViewController (private)<HomeScreenDelegate,ProfileScreenViewDelegate,NotificationsScreenViewDelegate,UpcomingCompletedEventsViewDelegate,InvitesViewDelegate,AboutViewDelegate,MBProgressHUDDelegate,RegistrationDetailDelegate,GetUpcomingActivitiesInvocationDelegate>
@end

@interface SlideViewNavigationBar : UINavigationBar {
@private
    
    id <SlideViewNavigationBarDelegate> _slideViewNavigationBarDelegate;
    
}

@property (nonatomic, assign) id <SlideViewNavigationBarDelegate> slideViewNavigationBarDelegate;

@end

@implementation SlideViewNavigationBar

@synthesize slideViewNavigationBarDelegate = _slideViewNavigationBarDelegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    [self.slideViewNavigationBarDelegate slideViewNavigationBar:self touchesEnded:touches withEvent:event];
    
}

@end

@interface SlideViewTableCell : UITableViewCell {
@private
    
}
@end

@implementation SlideViewTableCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.textLabel.textColor = [SoclivityUtilities returnTextFontColor:0];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 34.0f, 34.0f);
    
}

@end

@implementation SlideViewController

@synthesize delegate = _delegate;
@synthesize lstrnotificationscount,_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SlideViewController" bundle:nil];
    if (self) {
                
        _touchView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        _touchView.exclusiveTouch = NO;
        
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 420.0f)];
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
    }
    
    return self;
}

- (void)dealloc {
    
    [_touchView release];
    [_overlayView release];
    [_slideNavigationController release];
    
    [super dealloc];
    
}

#pragma mark - View Lifecycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (WaitingOnYou_Count) name:@"WaitingOnYou_Count" object:nil];

}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WaitingOnYou_Count" object:nil];
    
    
}

- (void)viewDidLoad {
    
    self.view.backgroundColor= [SoclivityUtilities returnBackgroundColor:3];
    //self.view.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S7_background.png"]];
    _tableView.scrollEnabled=NO;
    _tableView.bounces=NO;
    if (![self.delegate respondsToSelector:@selector(configureSearchDatasourceWithString:)] || ![self.delegate respondsToSelector:@selector(searchDatasource)]) {
        _tableView.frame = CGRectMake(0.0f, 0.0f, 269.0f, 460.0f);
    }
    _slideNavigationController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    _slideNavigationController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _slideNavigationController.view.layer.shadowRadius = 4.0f;
    _slideNavigationController.view.layer.shadowOpacity = 0.75f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_slideNavigationController.view.bounds cornerRadius:4.0];
    _slideNavigationController.view.layer.shadowPath = path.CGPath;
    
    //[(SlideViewNavigationBar *)_slideNavigationController.navigationBar setSlideViewNavigationBarDelegate:self];
    
    
    UIViewController *initalViewController = [self.delegate initialViewController];
    
    
    if([initalViewController isKindOfClass:[HomeViewController class]]){
        
        HomeViewController *homeController=(HomeViewController*)initalViewController;
        homeController.delegate=self;
    }
    [self configureViewController:initalViewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:initalViewController] animated:NO];
    
    [self addChildViewController:_slideNavigationController];
    
    [self.view addSubview:_slideNavigationController.view];
    
    if ([self.delegate respondsToSelector:@selector(initialSelectedIndexPath)])
        [_tableView selectRowAtIndexPath:[self.delegate initialSelectedIndexPath] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    
}

#pragma mark Instance Methods

- (void)configureViewController:(UIViewController *)viewController {
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuBarButtonItemPressed:)];
    if ([viewController isKindOfClass:[HomeViewController class]]) {
        
        NSLog(@"HomeViewController class");  
       // viewController.delegate=self;
    }
    
    viewController.navigationItem.leftBarButtonItem = [barButtonItem autorelease];
    
}

- (void)menuBarButtonItemPressed:(id)sender {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        [self slideInSlideNavigationControllerView];
        return;
        
    }
    
    UIViewController *currentViewController = [[_slideNavigationController viewControllers] objectAtIndex:0];
    
    if ([currentViewController conformsToProtocol:@protocol(SlideViewControllerSlideDelegate)] && [currentViewController respondsToSelector:@selector(shouldSlideOut)]) {
        
        
        if ([(id <SlideViewControllerSlideDelegate>)currentViewController shouldSlideOut]) {
            
            [self slideOutSlideNavigationControllerView];
            
        }
        
        
    } else {
        
        [self slideOutSlideNavigationControllerView];
        
    }
    
}

- (void)slideOutSlideNavigationControllerView {
        
    _slideNavigationControllerState = kSlideNavigationControllerStatePeeking;

    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(270.0f, 0.0f);//260
        
    } completion:^(BOOL finished) {
        
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    
}

- (void)slideInSlideNavigationControllerView {
            
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        [_overlayView removeFromSuperview];
        
    }];
    
}

- (void)slideSlideNavigationControllerViewOffScreen {
    
    _slideNavigationControllerState = kSlideNavigationControllerStateSearching;

    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(320.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        [_slideNavigationController.view addSubview:_overlayView];
        
    }];
    
}

#pragma mark UITouch Logic

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (_slideNavigationControllerState == kSlideNavigationControllerStateDrilledDown || _slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return;
    
    UITouch *touch = [touches anyObject];
    
    _startingDragPoint = [touch locationInView:self.view];
    
    if ((CGRectContainsPoint(_slideNavigationController.view.frame, _startingDragPoint)) && _slideNavigationControllerState == kSlideNavigationControllerStatePeeking) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;
    }
    
    // we only trigger a swipe if either navigationBarOnly is deactivated
    // or we swiped in the navigationBar
#if 0    
    if (!kSVCSwipeNavigationBarOnly || _startingDragPoint.y <= 44.0f) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;

    }
#endif    
    if (!kSVCSwipeNavigationBarOnly) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDragging;
        _startingDragTransformTx = _slideNavigationController.view.transform.tx;
        
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState != kSlideNavigationControllerStateDragging)
        return;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self.view];
  
    [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{

        _slideNavigationController.view.transform = CGAffineTransformMakeTranslation(MAX(_startingDragTransformTx + (location.x - _startingDragPoint.x), 0.0f), 0.0f);

    } completion:^(BOOL finished) {
        
    }];
    
      
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateDragging) {
        UITouch *touch = [touches anyObject];
        CGPoint endPoint = [touch locationInView:self.view];
        
        // Check in which direction we were dragging
        if (endPoint.x < _startingDragPoint.x) {
            if (_slideNavigationController.view.transform.tx <= kSVCRightAnchorX) {
                [self slideInSlideNavigationControllerView];
            } else {
                [self slideOutSlideNavigationControllerView]; 
            }
        } else {
            if (_slideNavigationController.view.transform.tx >= kSVCLeftAnchorX) {
                [self slideOutSlideNavigationControllerView];
            } else {
                [self slideInSlideNavigationControllerView];
            }
        }
    }
    
}

#pragma mark SlideViewNavigationBarDelegate Methods

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesBegan:touches withEvent:event];
    
}

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesMoved:touches withEvent:event];
    
}

- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
    
}

#pragma mark UINavigationControlerDelgate Methods 

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    if ([[navigationController viewControllers] count] > 1) {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateDrilledDown;
        
    } else {
        
        _slideNavigationControllerState = kSlideNavigationControllerStateNormal;
        
    }
}

-(void)WaitingOnYou_Count
{
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate / UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return [[self.delegate searchDatasource] count];
    } else {
        return [[[[self.delegate datasource] objectAtIndex:section] objectForKey:kSlideViewControllerSectionViewControllersKey] count]; 
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *viewControllerDictionary = nil;
    
    viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    
    NSNumber *tagNumber = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTagKey];

    
    switch ([tagNumber integerValue]) {
        case kSignOut:
            return cellHeightDefault;
        case kCalendarSync:
            return cellHeightDefault;
        case kBlockedList:
            if([SoclivityUtilities deviceType] & iPhone5)
                return 88.0f;
            else
                return 0.0f;
        case kProfileView:
            return cellHeightLarge;
        default:
            return cellHeightDefault;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *resuseIdentifier = @"SlideViewControllerTableCell";
    
    SlideViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (!cell) {
        
        cell = [[[SlideViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier] autorelease];
    
    }

    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }//END  for (UIView *view in cell.contentView.subviews)
    
    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSNumber *tagNumber = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTagKey];

    
    float yCompLine;
    float yLeftImage;
    float yTextLabel;
    BOOL showLineOrSwitch;
    
    
    switch ([tagNumber intValue]) {
        case kActivityFeed:
        {
            showLineOrSwitch=TRUE;
            yCompLine=43.0f;
            yLeftImage=7.0f;
            yTextLabel=13.0f;

        }
            break;
            
        case kProfileView:
        {
            yCompLine=64.0f;
            yTextLabel=29.0f;
            showLineOrSwitch=TRUE;
        }
            break;
            
            
        case kWaitingOnU:
        {
            yCompLine=44.0f;
            yTextLabel=13.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=9.0f;
            
        }
            break;
         case kUpcoming_Completed:
        {
            yCompLine=44.0f;
            yTextLabel=13.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=12.0f;
        }
            break;
            
        case kInvite:
        {
            yCompLine=44;
            yTextLabel=13.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=9.0f;
            
        }
            break;
            
        case kSendUsFeedback:
        {
            yCompLine=44;
            yTextLabel=13.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=10.0f;
        }
          break;
            
            
        case kBugAlert:
        {
            yCompLine=44;
            yTextLabel=13.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=9.0f;
        }
            break;

            
            
        case kBlockedList:
        {
            
            if([SoclivityUtilities deviceType] & iPhone5)
                yCompLine=86;
            else
                yCompLine=88;
            
            yTextLabel=15.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=9.0f;
            
        }
            break;
        case kCalendarSync:
        {
            yCompLine=44;
            yTextLabel=13.0f;
            showLineOrSwitch=FALSE;
            yLeftImage=7.0f;
            
        }
            break;
        case kAbout:
        {
            yCompLine=44;
            yTextLabel=13.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=7.0f;
            
        }
            break;
        case kSignOut:
        {
            yCompLine=44;
            showLineOrSwitch=TRUE;
            yLeftImage=8.0f;
            yTextLabel=13.0f;
            
            [cell.contentView setBackgroundColor:[SoclivityUtilities returnBackgroundColor:5]];
            
        }
            break;

    }
    
    // Setting the text for items in the settings menu
    CGRect textLabelRect=CGRectMake(64,yTextLabel,205,17);
    UILabel *descriptionLabel=[[UILabel alloc] initWithFrame:textLabelRect];
    descriptionLabel.textAlignment=UITextAlignmentLeft;
    descriptionLabel.text=[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTitleKey];
    descriptionLabel.backgroundColor=[UIColor clearColor];
    descriptionLabel.textColor=[UIColor whiteColor];
    
    // For the profile name
    if([tagNumber intValue]==kProfileView){
        descriptionLabel.frame=CGRectMake(82,yTextLabel,205,17);
        descriptionLabel.textColor=[UIColor whiteColor];
        descriptionLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    }
    // For all the system settings elements
    else if([tagNumber intValue]==kAbout || [tagNumber intValue]==kSignOut || [tagNumber intValue]==kCalendarSync) {
        descriptionLabel.alpha = 0.5;
        descriptionLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:16];
    }
    // Everything else
    else
        descriptionLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:16];
    
    [cell.contentView addSubview:descriptionLabel];
    [descriptionLabel release];

    if(showLineOrSwitch){
        UIImageView *longLineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_long-line.png"]];

        if([tagNumber intValue]==kAbout || [tagNumber intValue]==kCalendarSync || [tagNumber intValue]==kSignOut){
            longLineImageView.image=Nil;
        }
        
        if(([SoclivityUtilities deviceType] & iPhone5) && [tagNumber intValue]==kBugAlert){
              longLineImageView.image=Nil;
        }
        
        longLineImageView.frame=CGRectMake(0,yCompLine-1, longLineImageView.image.size.width, longLineImageView.image.size.height);
        [cell.contentView addSubview:longLineImageView];
        [longLineImageView release];
    }
    else{
    //draw a custom switch control
        [[UISwitch appearance] setTintColor:[UIColor grayColor]];
        [[UISwitch appearance] setOnTintColor:[UIColor grayColor]];
    
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(185, 8, 50, 50)];
        switchView.transform = CGAffineTransformMakeScale(0.75, 0.75);

        
        [cell.contentView addSubview:switchView];
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        GetPlayersClass *player=SOC.loggedInUser;
        [switchView setOn:player.calendarSync animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [switchView release];
    }
    
    
    // Setting up all the images and icons on the settings screen.
    if ([[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey] isKindOfClass:[UIImage class]]) {

        UIImage *imageProfile=[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey];
        
        UIImageView *slideImageView=[[UIImageView alloc] initWithImage:imageProfile];
                                     
        slideImageView.tag=[tagNumber intValue];
        
        // If it's the profile screen
        if([tagNumber intValue]==kProfileView){
        
            // First check to see if it's a square
            if(imageProfile.size.height != imageProfile.size.width)
                imageProfile = [SoclivityUtilities autoCrop:imageProfile];
        
            // If the image needs to be compressed
            if(imageProfile.size.height > 50 || imageProfile.size.width > 50)
                slideImageView.image = [SoclivityUtilities compressImage:imageProfile size:CGSizeMake(50,50)];

            // Turning it into a round image
            slideImageView.layer.cornerRadius = imageProfile.size.width/2;
            slideImageView.layer.masksToBounds=YES;
            
            /*
            slideImageView.layer.borderWidth = 2.0;
            slideImageView.layer.borderColor = [SoclivityUtilities returnBackgroundColor:4].CGColor;
            */
            
            slideImageView.frame=CGRectMake(14, 6, 50, 50);
            
            [cell.contentView addSubview:slideImageView];
        }
        else if([tagNumber intValue]==kWaitingOnU){
            slideImageView.frame=CGRectMake(16, yLeftImage, slideImageView.image.size.width, slideImageView.image.size.height);
            CGRect notificationNoLabelRect=CGRectMake(6,4,15,14);
            UILabel *notificationNoLabel=[[UILabel alloc] initWithFrame:notificationNoLabelRect];
            notificationNoLabel.textAlignment=UITextAlignmentCenter;
            SoclivityManager *SOC=[SoclivityManager SharedInstance];
            notificationNoLabel.text=[NSString stringWithFormat:@"%d",SOC.loggedInUser.badgeCount];
            notificationNoLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
            notificationNoLabel.textColor=[UIColor whiteColor];
            notificationNoLabel.backgroundColor=[UIColor clearColor];
            [slideImageView addSubview:notificationNoLabel];
            [notificationNoLabel release];
            [cell.contentView addSubview:slideImageView];
        }
        else {
            slideImageView.frame=CGRectMake(16, yLeftImage, slideImageView.image.size.width, slideImageView.image.size.height);
           [cell.contentView addSubview:slideImageView];
        }
        
        [slideImageView release];
        
    }
    else
        cell.imageView.image = nil;
    
    return cell;
    
}

- (void)startAnimation:(NSInteger)type{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    switch (type) {
        case 1:
        {
            HUD.labelText = @"Syncing...";
            
        }
            break;
            
        case 2:
        {
            HUD.labelText = @"Turning Off";
            
        }
            break;
            
        case 3:
        {
            HUD.labelText = @"Removing";
            
        }
            break;
            
    }
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
}


- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    GetPlayersClass *player=SOC.loggedInUser;
    player.calendarSync=switchControl.on;
    
    devServer=[[MainServiceManager alloc]init];
    if([SoclivityUtilities hasNetworkConnection]){
        
        if(player.calendarSync)
            [self startAnimation:1];
        else{
            [self startAnimation:2];
        }
        [devServer registrationDetailInvocation:self isFBuser:NO isActivityUpdate:3];
        
        
    }
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[alert show];
		[alert release];
		return;
		
	}

}

-(void)RegistrationDetailInvocationDidFinish:(RegistrationDetailInvocation*)invocation
                                  withResult:(NSArray*)result andUpdateType:(BOOL)andUpdateType
                                   withError:(NSError*)error{
    // Stop the animation
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    GetPlayersClass *player=SOC.loggedInUser;
    
    if(player.calendarSync){
        
        [devServer getUpcomingActivitiesForUserInvocation:[SOC.loggedInUser.idSoc intValue] player2:[SOC.loggedInUser.idSoc intValue] delegate:self];

    }
    else{
        [HUD hide:YES];
        
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        [SOC deleteAllEvents];
    }

    

}


-(void)UpcomingActivitiesInvocationDidFinish:(GetUpcomingActivitiesInvocation*)invocation
                                withResponse:(NSArray*)responses
                                   withError:(NSError*)error{
    
    [HUD hide:YES];
    
    if([responses count]>0){
        NSMutableArray *activitiesArray=[[NSMutableArray alloc]init];
        for(int i=0;i<[responses count];i++){
            NSNumber *activityType=[[responses objectAtIndex:i] objectForKey:@"activityType"];
            switch ([activityType intValue]) {
                case 1:
                {
                    NSLog(@"The user has got Organizing Activities");
                    
                    [activitiesArray addObjectsFromArray:[[responses objectAtIndex:i] objectForKey:@"Elements"]];
                    
                }
                    break;
                    
                case 2:
                {
                    NSLog(@"The user has got invitedToArray Activities");
                    [activitiesArray addObjectsFromArray:[[responses objectAtIndex:i] objectForKey:@"Elements"]];

                    
                }
                    break;
                case 3:
                {
                    NSLog(@"The user has got compeletedArray Activities");
                    
                }
                    break;
                case 4:
                {
                    NSLog(@"The user has got goingToArray Activities");
                    [activitiesArray addObjectsFromArray:[[responses objectAtIndex:i] objectForKey:@"Elements"]];

                    
                }
                    break;
            }
            
            
        }
        if([activitiesArray count]!=0){
            
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        [SOC grantedAccess:activitiesArray];

        // now Sync All Activities in the Calendar
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Events To Sync" message:nil
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            return;
            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Events To Sync" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return 1;
    } else {
        return [[self.delegate datasource] count];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return nil;
    
    NSDictionary *sectionDictionary = [[self.delegate datasource] objectAtIndex:section];
    
    if ([sectionDictionary objectForKey:kSlideViewControllerSectionTitleKey]) {
        
        NSString *sectionTitle = [sectionDictionary objectForKey:kSlideViewControllerSectionTitleKey];
        
        if ([sectionTitle isEqualToString:kSlideViewControllerSectionTitleNoTitle]) {
            
            return nil;
            
        } else {
            
            return sectionTitle;
            
        }
        
    } else {
        
        return nil;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching)
        return nil;
    
    NSString *titleString = [self tableView:tableView titleForHeaderInSection:section];
    
    if (!titleString)
        return nil;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)];
    imageView.image = [[UIImage imageNamed:@"section_background"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(imageView.frame, 10.0f, 0.0f)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithRed:125.0f/255.0f green:129.0f/255.0f blue:146.0f/255.0f alpha:1.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleString;
    [imageView addSubview:titleLabel];
    [titleLabel release];

    return [imageView autorelease];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        return 0.0f;
    }
    else if ([self tableView:tableView titleForHeaderInSection:section]) {
        return 22.0f;
    } else {
        return 0.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    
    NSString *tapAndDrawerEffect = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTapAndDrawerKey];
    
    NSNumber *tagNumber = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTagKey];

    
    if([tapAndDrawerEffect isEqualToString:@"TRUE"] && [tagNumber integerValue]==kSendUsFeedback){
        if ([[FeedbackBugReport sharedInstance] canSendFeedback]) {
            UINavigationController* tellAFriendController = [[FeedbackBugReport sharedInstance] sendFeedbackController];
             [self presentModalViewController:tellAFriendController animated:YES];
            
            
        }
        return;
    }
    
    
    if([tapAndDrawerEffect isEqualToString:@"TRUE"] && [tagNumber integerValue]==kBugAlert){
        if ([[FeedbackBugReport sharedInstance] canSendFeedback]) {
            UINavigationController* tellAFriendController = [[FeedbackBugReport sharedInstance] sendBugAlertController];
            [self presentModalViewController:tellAFriendController animated:YES];
            
            
        }
        return;
    }


    if(![tapAndDrawerEffect isEqualToString:@"TRUE"])
        return;

    
    Class viewControllerClass = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerClassKey];
    NSString *nibNameOrNil = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerNibNameKey];
    UIViewController *viewController = [[viewControllerClass alloc] initWithNibName:nibNameOrNil bundle:nil];
    
    
    if([viewController isKindOfClass:[HomeViewController class]]){
        
        HomeViewController *homeController=(HomeViewController*)viewController;
        homeController.delegate=self;
    }
    
    else if([viewController isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *profileController=(ProfileViewController*)viewController;
        profileController.delegate=self;
    }
    
    else if([viewController isKindOfClass:[NotificationsViewController class]]){
        NotificationsViewController *notifyController=(NotificationsViewController*)viewController;
        notifyController.delegate=self;
        
    }
    else if([viewController isKindOfClass:[UpComingCompletedEventsViewController class]]){
        UpComingCompletedEventsViewController *upcomingCompletedController=(UpComingCompletedEventsViewController*)viewController;
        upcomingCompletedController.delegate=self;
        
    }
    
    else if([viewController isKindOfClass:[InvitesViewController class]]){
        InvitesViewController *invitesController=(InvitesViewController*)viewController;
        invitesController.inviteFriends=NO;
        invitesController.delegate=self;
        
    }
    
    else if([viewController isKindOfClass:[AboutViewController class]]){
        AboutViewController *AboutController=(AboutViewController*)viewController;
        AboutController.delegate=self;
        
    }


    
    if ([self.delegate respondsToSelector:@selector(configureViewController:userInfo:)])
        [self.delegate configureViewController:viewController userInfo:[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerUserInfoKey]];
    
    [self configureViewController:viewController];
    
    [_slideNavigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:NO];
    [viewController release];
    
    [self slideInSlideNavigationControllerView];
    
}
- (void)showLeft:(id)sender{
    [self menuBarButtonItemPressed:sender];
}

@end
