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
#import "BlockedListViewController.h"
#define kSVCLeftAnchorX                 100.0f
#define kSVCRightAnchorX                190.0f
#define kSVCSwipeNavigationBarOnly      YES


#define kProfileView 1
#define kActivityFeed 2
#define kWaitingOnU 3
#define kUpcoming_Completed 4
#define kInvite 5
#define kBlockedList 6
#define kCalendarSync 7
#define kLinkFacebook 8
#define kEmailNotifications 9
#define kSignOut 10

#define cellHeightMedium 45
#define cellHeightLarge  65

@interface SlideViewController (private)<HomeScreenDelegate,ProfileScreenViewDelegate,NotificationsScreenViewDelegate,UpcomingCompletedEvnetsViewDelegate,InvitesViewDelegate,BlockedListViewDelegate>
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
        
        
        //self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [SoclivityUtilities returnTextFontColor:0];
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.shadowColor = [SoclivityUtilities returnTextFontColor:9];
        //self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        //self.textLabel.backgroundColor = [UIColor clearColor];
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
    NSLog(@"viewWillAppear in slide View Controller Called");
}
- (void)viewDidLoad {
    
    self.view.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S7_background.png"]];
    _tableView.scrollEnabled=NO;
    _tableView.bounces=NO;
    _tableView.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S7_background.png"]];
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
        case kActivityFeed:
        case kWaitingOnU:
        case kUpcoming_Completed:
        case kInvite:
        case kBlockedList:
        case kCalendarSync:
        case kLinkFacebook:
        case kEmailNotifications:
        case kSignOut:
            return cellHeightMedium;
        case kProfileView:
            return cellHeightLarge;
        default:
            return 45.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *resuseIdentifier = @"SlideViewControllerTableCell";
    
    SlideViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (!cell) {
        
        cell = [[[SlideViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier] autorelease];
    
    }

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
            yLeftImage=11.0f;
            yTextLabel=15.0f;
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_arrow.png"]];

        }
            break;
            
        case kProfileView:
        {
            yCompLine=63.0f;
            yTextLabel=30.0f;
            showLineOrSwitch=TRUE;
            UIImageView *profilePicBorder=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_organizerPic.png"]];
            profilePicBorder.frame=CGRectMake(15, 7, 52, 52);
            [cell.contentView addSubview:profilePicBorder];
            [profilePicBorder release];
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_arrow.png"]];
        }
            break;
            
            
        case kWaitingOnU:
        {
            yCompLine=43.0f;
            yTextLabel=17.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=12.0f;
            CGRect notificationNoLabelRect=CGRectMake(25,17,15,14);
            UILabel *notificationNoLabel=[[UILabel alloc] initWithFrame:notificationNoLabelRect];
            notificationNoLabel.textAlignment=UITextAlignmentCenter;
            notificationNoLabel.text=@"0";
            notificationNoLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
            notificationNoLabel.textColor=[UIColor whiteColor];
            notificationNoLabel.shadowColor = [UIColor blackColor];
            notificationNoLabel.shadowOffset = CGSizeMake(0,-1);
            notificationNoLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:notificationNoLabel];
            [notificationNoLabel release];
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_arrow.png"]];


            
        }
            break;
         case kUpcoming_Completed:
        {
            yCompLine=43.0f;
            yTextLabel=17.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=15.0f;
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_arrow.png"]];


        }
            break;
            
        case kInvite:
        {
            yCompLine=43;
            yTextLabel=15.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=15.0f;
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_arrow.png"]];

            
        }
            break;
            
        case kBlockedList:
        {
            yCompLine=43;
            yTextLabel=15.0f;
            showLineOrSwitch=TRUE;
            yLeftImage=11.0f;
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_arrow.png"]];

            
        }
            break;
        case kCalendarSync:
        {
            yCompLine=43;
            yTextLabel=16.0f;
            showLineOrSwitch=FALSE;
            yLeftImage=10.0f;
            
        }
            break;
        case kLinkFacebook:
        {
            yCompLine=43;
            yTextLabel=15.0f;
            showLineOrSwitch=FALSE;
            yLeftImage=11.0f;
            
        }
            break;
        case kEmailNotifications:
        {
            yCompLine=43;
            showLineOrSwitch=FALSE;
            yLeftImage=16.0f;
            yTextLabel=17.0f;
            
        }
            break;
        case kSignOut:
        {
            yCompLine=43;
            showLineOrSwitch=FALSE;
            yLeftImage=16.0f;
            yTextLabel=10.0f;
            
        }
            break;

    }
    
    CGRect textLabelRect=CGRectMake(65,yTextLabel,205,16);
    UILabel *descriptionLabel=[[UILabel alloc] initWithFrame:textLabelRect];
    descriptionLabel.textAlignment=UITextAlignmentLeft;
    descriptionLabel.text=[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTitleKey];
    
    descriptionLabel.shadowColor = [UIColor blackColor];
    descriptionLabel.shadowOffset = CGSizeMake(0,-1);
    descriptionLabel.textColor=[UIColor whiteColor];
    descriptionLabel.backgroundColor=[UIColor clearColor];
    
    if([tagNumber intValue]==kProfileView){
        descriptionLabel.frame=CGRectMake(75,yTextLabel,205,17);
        descriptionLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:17];
    }
    else if([tagNumber intValue]==kProfileView || ([tagNumber intValue]==kCalendarSync)||([tagNumber intValue]==kLinkFacebook)||([tagNumber intValue]==kEmailNotifications)||([tagNumber intValue]==kSignOut))
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    
    else
        descriptionLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    
    [cell.contentView addSubview:descriptionLabel];
    [descriptionLabel release];

    if([tagNumber intValue]!=kSignOut){
    if(showLineOrSwitch){
    UIImageView *longLineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_long-line.png"]];
    
    if(([tagNumber intValue]==kWaitingOnU) ||([tagNumber intValue]==kUpcoming_Completed)||([tagNumber intValue]==kInvite)){
        longLineImageView.image=[UIImage imageNamed:@"S7_short-line.png"];
        longLineImageView.frame=CGRectMake(25,yCompLine, longLineImageView.image.size.width, longLineImageView.image.size.height);

    }
    else
    longLineImageView.frame=CGRectMake(0,yCompLine, longLineImageView.image.size.width, longLineImageView.image.size.height);
    [cell.contentView addSubview:longLineImageView];
    [longLineImageView release];
    }
    else{
        //draw a custom switch control
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(185, 10, 50, 50)];
        switchView.transform = CGAffineTransformMakeScale(0.75, 0.75);
        [cell.contentView addSubview:switchView];
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [switchView release];
    }
    }
    else{
        UIImageView *longLineImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S7_long-line.png"]];
        longLineImageView.frame=CGRectMake(0,0, longLineImageView.image.size.width, longLineImageView.image.size.height);
        [cell.contentView addSubview:longLineImageView];
        [longLineImageView release];


    }
    if ([[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey] isKindOfClass:[UIImage class]]) {

        UIImage *imageProfile=[viewControllerDictionary objectForKey:kSlideViewControllerViewControllerIconKey];
        
        UIImageView *slideImageView=[[UIImageView alloc]initWithImage:imageProfile];

        if([tagNumber intValue]==kProfileView){
        
        if(imageProfile.size.height != imageProfile.size.width)
            imageProfile = [SoclivityUtilities autoCrop:imageProfile];
        
        // If the image needs to be compressed
        if(imageProfile.size.height > 41 || imageProfile.size.width > 42)
            slideImageView.image = [SoclivityUtilities compressImage:imageProfile size:CGSizeMake(42,41)];
            
            slideImageView.frame=CGRectMake(19, 11, 42, 41);
        }
        else
         slideImageView.frame=CGRectMake(19, yLeftImage, slideImageView.image.size.width, slideImageView.image.size.height);
        
        [cell.contentView addSubview:slideImageView];
        [slideImageView release];
        
    } else {
        cell.imageView.image = nil;
    }
    
    return cell;
    
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}
#if 1

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
    titleLabel.shadowColor = [UIColor colorWithRed:40.0f/255.0f green:45.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
    titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
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
#endif
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSDictionary *viewControllerDictionary = nil;
    
    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
        viewControllerDictionary = [[self.delegate searchDatasource] objectAtIndex:indexPath.row];
    } else {
        viewControllerDictionary = [[[[self.delegate datasource] objectAtIndex:indexPath.section] objectForKey:kSlideViewControllerSectionViewControllersKey] objectAtIndex:indexPath.row];
    }
    
    NSString *tapAndDrawerEffect = [viewControllerDictionary objectForKey:kSlideViewControllerViewControllerTapAndDrawerKey];
    
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
    
    else if([viewController isKindOfClass:[BlockedListViewController class]]){
        BlockedListViewController *blockListController=(BlockedListViewController*)viewController;
        blockListController.delegate=self;
        
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
