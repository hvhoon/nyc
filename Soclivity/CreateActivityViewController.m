//
//  CreateActivityViewController.m
//  Soclivity
//
//  Created by Kanav on 10/8/12.
//
//

#import "CreateActivityViewController.h"
#import "SoclivityUtilities.h"
#import "UIViewController+MJPopupViewController.h"
#import "SoclivityManager.h"
#import "PlacemarkClass.h"
#import "ActivityAnnotation.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MainServiceManager.h"
#import "NewActivityInvocation.h"
#import "MBProgressHUD.h"
#import "GetPlayersClass.h"
#import "DetailedActivityInfoInvocation.h"
#import "EditActivityEventInvocation.h"
#import "SoclivitySqliteClass.h"
#import "PostActivityRequestInvocation.h"
#define kActivityNameNot 10
#define kDeleteActivityRequest 21
#define kDeleteActivity 12
#define FOURSQUARE 1
@interface CreateActivityViewController ()<NewActivityRequestInvocationDelegate,MBProgressHUDDelegate,DetailedActivityInfoInvocationDelegate,EditActivityEventInvocationDelegate,PostActivityRequestInvocationDelegate>

@end

@implementation CreateActivityViewController
@synthesize delegate,addressSearchBar;
@synthesize mapView = _mapView,_geocodingResults,activityObject,newActivity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    devServer=[[MainServiceManager alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (showInAppNotificationsUsingRocketSocket:) name:@"WaitingonyouNotification" object:nil];

    
    if(newActivity){
        activityObject=[[InfoActivityClass alloc]init];
        activityObject.type=1;
        activityObject.access=@"public";
        activityObject.num_of_people=-1;
        crossEditButton.hidden=YES;
        tickEditButton.hidden=YES;
        deleteActivityButton.hidden=YES;
        activityObject.activityTime=[NSDate date];
        activityObject.activityDate=[NSDate date];
        [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"ActivityDate"];
        [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"ActivityTime"];


    }
    else{
        pickALocationButton.hidden=YES;
        crossButton.hidden=YES;
        step1_of2Label.hidden=YES;
        crossEditButton.hidden=NO;
        tickEditButton.hidden=NO;
        deleteActivityButton.hidden=NO;
        activityNameTextField.text=activityObject.activityName;
        dateSelected=TRUE;
        timeSelected=TRUE;
        validAcivityName=TRUE;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        activityObject.activityTime=activityObject.activityDate = [dateFormatter dateFromString:activityObject.when];

    }
    _geocodingResults=[NSMutableArray new];
    _geocoder = [[CLGeocoder alloc] init];
    SOC=[SoclivityManager SharedInstance];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundtap:)];
    [createActivityView addGestureRecognizer:tapGesture];
    [tapGesture release];

   if(newActivity)
    createActivtyStaticLabel.text=@"Create Activity";
   else{
    createActivtyStaticLabel.text=@"Edit Activity";       
   }
    createActivtyStaticLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    createActivtyStaticLabel.textColor=[UIColor whiteColor];
    createActivtyStaticLabel.backgroundColor=[UIColor clearColor];
    createActivtyStaticLabel.shadowColor = [UIColor blackColor];
    createActivtyStaticLabel.shadowOffset = CGSizeMake(0,-1);
    
    
    
    step1_of2Label.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    step1_of2Label.textColor=[UIColor whiteColor];
    step1_of2Label.backgroundColor=[UIColor clearColor];
    step1_of2Label.shadowColor = [UIColor blackColor];
    step1_of2Label.shadowOffset = CGSizeMake(0,-1);
    step1_of2Label.text=@"Step 1 of 2";
    
    
    locationTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    locationTextLabel.textColor=[UIColor whiteColor];
    locationTextLabel.backgroundColor=[UIColor clearColor];
    locationTextLabel.shadowColor=[UIColor blackColor];
    locationTextLabel.shadowOffset=CGSizeMake(0,-1);
    locationTextLabel.text=[NSString stringWithFormat:@"Exact location will only be visible to participants"];

    
    
    // Play button
    UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    playButton.frame = CGRectMake(0,0,64,50);
    playButton.tag=kPlayActivity;
    [playButton setImage:[UIImage imageNamed:@"S06_play.png"] forState:UIControlStateNormal];
    
    [playButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [createActivityView addSubview:playButton];
    
    UIImageView *playTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    playTickImageView.frame=CGRectMake(24,7, 16, 15);
    playTickImageView.tag=kPlayTickImage;
    [createActivityView addSubview:playTickImageView];
    
    CGRect playTypeLabelRect=CGRectMake(0,28,64,16);
    UILabel *playTypeLabel=[[UILabel alloc] initWithFrame:playTypeLabelRect];
    playTypeLabel.textAlignment=UITextAlignmentCenter;
    playTypeLabel.text=[NSString stringWithFormat:@"Play"];
    playTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    playTypeLabel.textColor=[UIColor whiteColor];
    playTypeLabel.textAlignment = UITextAlignmentCenter;
    playTypeLabel.tag=kPlayLabelText;
    playTypeLabel.backgroundColor=[UIColor clearColor];
    [createActivityView addSubview:playTypeLabel];
    
    [playTickImageView release];
    [playTypeLabel release];
    
    // Eat Button
    UIButton *eatButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    eatButton.frame = CGRectMake(64,0,64,50);
    eatButton.tag=kEatActivity;
    [eatButton setImage:[UIImage imageNamed:@"S06_eat.png"] forState:UIControlStateNormal];
    
    [eatButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [createActivityView addSubview:eatButton];
    
    UIImageView *eatTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    eatTickImageView.frame=CGRectMake(88, 7, 16, 15);
    eatTickImageView.tag=kEatTickImage;
    [createActivityView addSubview:eatTickImageView];
    
    
    CGRect eatTypeLabelRect=CGRectMake(64,28,64,15);
    UILabel *eatTypeLabel=[[UILabel alloc] initWithFrame:eatTypeLabelRect];
    eatTypeLabel.textAlignment=UITextAlignmentCenter;
    eatTypeLabel.text=[NSString stringWithFormat:@"Eat"];
    eatTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    eatTypeLabel.textColor=[UIColor whiteColor];
    eatTypeLabel.textAlignment = UITextAlignmentCenter;
    eatTypeLabel.tag=kEatLabelText;
    eatTypeLabel.backgroundColor=[UIColor clearColor];
    [createActivityView addSubview:eatTypeLabel];
    
    [eatTickImageView release];
    [eatTypeLabel release];
    
    
    // See Button
    UIButton *seeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    seeButton.frame = CGRectMake(128,0,64,50);
    seeButton.tag=kSeeActivity;
    [seeButton setImage:[UIImage imageNamed:@"S06_see.png"] forState:UIControlStateNormal];
    
    [seeButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [createActivityView addSubview:seeButton];
    
    UIImageView *seeTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    seeTickImageView.frame=CGRectMake(152, 7, 16, 15);
    seeTickImageView.tag=kSeeTickImage;
    [createActivityView addSubview:seeTickImageView];
    
    
    CGRect seeTypeLabelRect=CGRectMake(128,28,64,15);
    UILabel *seeTypeLabel=[[UILabel alloc] initWithFrame:seeTypeLabelRect];
    seeTypeLabel.textAlignment=UITextAlignmentCenter;
    seeTypeLabel.text=[NSString stringWithFormat:@"See"];
    seeTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    seeTypeLabel.textColor=[UIColor whiteColor];
    seeTypeLabel.textAlignment = UITextAlignmentCenter;
    seeTypeLabel.tag=kSeeLabelText;
    seeTypeLabel.backgroundColor=[UIColor clearColor];
    [createActivityView addSubview:seeTypeLabel];
    
    [seeTickImageView release];
    [seeTypeLabel release];
    
    
    // Create Button
    UIButton *createButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    createButton.frame = CGRectMake(192,0,64,50);
    createButton.tag=kCreateActivity;
    [createButton setImage:[UIImage imageNamed:@"S06_create.png"] forState:UIControlStateNormal];
    
    [createButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [createActivityView addSubview:createButton];
    
    UIImageView *createTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    createTickImageView.frame=CGRectMake(216, 7, 16, 15);
    createTickImageView.tag=kCreateTickImage;
    [createActivityView addSubview:createTickImageView];
    
    
    CGRect createTypeLabelRect=CGRectMake(192,28,64,15);
    UILabel *createTypeLabel=[[UILabel alloc] initWithFrame:createTypeLabelRect];
    createTypeLabel.textAlignment=UITextAlignmentCenter;
    createTypeLabel.text=[NSString stringWithFormat:@"Create"];
    createTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    createTypeLabel.textColor=[UIColor whiteColor];
    createTypeLabel.textAlignment = UITextAlignmentCenter;
    createTypeLabel.tag=kCreateLabelText;
    createTypeLabel.backgroundColor=[UIColor clearColor];
    [createActivityView addSubview:createTypeLabel];
    
    [createTickImageView release];
    [createTypeLabel release];
    
    
    // Learn button
    UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    learnButton.frame = CGRectMake(256,0,64,50);
    learnButton.tag=kLearnActivity;
    [learnButton setImage:[UIImage imageNamed:@"S06_learn.png"] forState:UIControlStateNormal];
    
    [learnButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [createActivityView addSubview:learnButton];
    
    UIImageView *learnTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    learnTickImageView.frame=CGRectMake(280, 7, 16, 15);
    learnTickImageView.tag=kLearnTickImage;
    [createActivityView addSubview:learnTickImageView];
    
    
    CGRect learnTypeLabelRect=CGRectMake(256,28,64,15);
    UILabel *learnTypeLabel=[[UILabel alloc] initWithFrame:learnTypeLabelRect];
    learnTypeLabel.textAlignment=UITextAlignmentCenter;
    learnTypeLabel.text=[NSString stringWithFormat:@"Learn"];
    learnTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    learnTypeLabel.textColor=[UIColor whiteColor];
    learnTypeLabel.textAlignment = UITextAlignmentCenter;
    learnTypeLabel.tag=kLearnLabelText;
    learnTypeLabel.backgroundColor=[UIColor clearColor];
    [createActivityView addSubview:learnTypeLabel];
    
    [learnTickImageView release];
    [learnTypeLabel release];
    
    if(newActivity)
    [self updateActivityType:kPlayActivity];
    else{
        
        switch (activityObject.type) {
            case 1:
            {
                    [self updateActivityType:kPlayActivity];
            }
                break;
                
            case 2:
            {
                    [self updateActivityType:kEatActivity];
            }
                break;

            case 3:
            {
                 [self updateActivityType:kSeeActivity];
            }
                break;

            case 4:
            {
                    [self updateActivityType:kCreateActivity];
            }
                break;

            case 5:
            {
                    [self updateActivityType:kLearnActivity];
            }
                break;
}
    }

    activityNameTextField.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    activityNameTextField.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    descriptionTextView.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    descriptionTextView.textColor=[SoclivityUtilities returnTextFontColor:5];
    descriptionTextView.backgroundColor=[UIColor clearColor];
    descriptionTextView.textAlignment=UITextAlignmentLeft;
    descriptionTextView.editable = YES;
    descriptionTextView.delegate = self;
    descriptionTextView.contentSize = descriptionTextView.frame.size;
    
    if(!newActivity){
        if((activityObject.what==(NSString*)[NSNull null])||([activityObject.what isEqualToString:@""]||activityObject.what==nil)||([activityObject.what isEqualToString:@"(null)"])){
            
            placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.0, descriptionTextView.frame.size.width - 20.0, 34.0)];
            [placeholderLabel setText:@"Tell us more..."];
            // placeholderLabel is instance variable retained by view controller
            [placeholderLabel setBackgroundColor:[UIColor clearColor]];
            placeholderLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
            placeholderLabel.textColor=[UIColor lightGrayColor];
            
            // textView is UITextView object you want add placeholder text to
            [descriptionTextView addSubview:placeholderLabel];

        }
        else
            descriptionTextView.text=activityObject.what;
        
        
        countTextLabel.text= [[NSString alloc] initWithFormat:@"%i/",[descriptionTextView.text length]];


    }
    else{
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.0, descriptionTextView.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Tell us more..."];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    placeholderLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    placeholderLabel.textColor=[UIColor lightGrayColor];
    
    // textView is UITextView object you want add placeholder text to
    [descriptionTextView addSubview:placeholderLabel];
    
    }
    onlyInviteesIphone5Label.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    onlyInviteesIphone5Label.textColor=[SoclivityUtilities returnTextFontColor:4];

    totalCountTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    totalCountTextLabel.textColor=[UIColor lightGrayColor];
    totalCountTextLabel.backgroundColor=[UIColor clearColor];

    countTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    countTextLabel.textColor=[UIColor lightGrayColor];
    countTextLabel.backgroundColor=[UIColor clearColor];
    
    
    pickADayButton.titleLabel.textAlignment=UITextAlignmentLeft;
    pickADayButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    pickADayButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    [pickADayButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [pickADayButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];
    
    

    
    pickATimeButton.titleLabel.textAlignment=UITextAlignmentLeft;
    pickATimeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    pickATimeButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    [pickATimeButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [pickATimeButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];
    
    
    
    if(!newActivity){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        NSDate *activityDate = [dateFormatter dateFromString:activityObject.when];
        
        NSDate *date = activityDate;
        NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [prefixDateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
        NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
        
        
        
        [prefixDateFormatter setDateFormat:@"h:mm a"];
        
        NSString *prefixTimeString = [prefixDateFormatter stringFromDate:date];
        
        
        
        int yOrigin;
        if([SoclivityUtilities deviceType] & iPhone5){
            yOrigin=274;
        }
        else
            yOrigin=263;
        
        pickATimeButton.frame=CGRectMake(65, yOrigin, 208, 44);

        
        [pickATimeButton setTitle:prefixTimeString forState:UIControlStateNormal];
        [pickATimeButton setTitle:prefixTimeString forState:UIControlStateHighlighted];
        
        if([SoclivityUtilities deviceType] & iPhone5){
            yOrigin=224;
        }
        else
            yOrigin=213;
        pickADayButton.frame=CGRectMake(65, yOrigin, 208, 44);

        [pickADayButton setTitle:prefixDateString forState:UIControlStateNormal];
        [pickADayButton setTitle:prefixDateString forState:UIControlStateHighlighted];
        
    }


    
    publicPrivateButton.titleLabel.textAlignment=UITextAlignmentLeft;
    publicPrivateButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    publicPrivateButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    [publicPrivateButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [publicPrivateButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];
    
    if(newActivity){
        onlyInviteesIphone5Label.text=@"Anyone can see this event";
    }
    else{
        if([activityObject.access caseInsensitiveCompare:@"private"] == NSOrderedSame){
            [publicPrivateButton setTitle:@"Private" forState:UIControlStateNormal];
            [publicPrivateButton setTitle:@"Private" forState:UIControlStateHighlighted];
   
            onlyInviteesIphone5Label.text=@"Only invitees can see this event";
        }
        else{
            onlyInviteesIphone5Label.text=@"Anyone can see this event";
            [publicPrivateButton setTitle:@"Public" forState:UIControlStateNormal];
            [publicPrivateButton setTitle:@"Public" forState:UIControlStateHighlighted];

        }
        
    }


    capacityTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    capacityTextField.textColor=[SoclivityUtilities returnTextFontColor:4];
    
    capacityLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    capacityLabel.textColor = [SoclivityUtilities returnTextFontColor:5];
    capacityLabel.backgroundColor=[UIColor clearColor];
    
    blankTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    blankTextLabel.textColor=[SoclivityUtilities returnTextFontColor:4];
    blankTextLabel.backgroundColor=[UIColor clearColor];
    
    if(!newActivity){
        if(activityObject.num_of_people!=-1){
            capacityTextField.text=[NSString stringWithFormat:@"%d",activityObject.num_of_people];
        }
    }
    //map Section
    
    self.addressSearchBar = [[[CustomSearchbar alloc] initWithFrame:CGRectMake(320,0, 320, 44)] autorelease];
    self.addressSearchBar.delegate = self;
    self.addressSearchBar.CSDelegate=self;
    if(self.addressSearchBar.text!=nil){
        self.addressSearchBar.showsCancelButton = YES;
    }
    
    self.addressSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.addressSearchBar.placeholder=@"Place or Address";
    self.addressSearchBar.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
    [createActivityView addSubview:self.addressSearchBar];

    CGRect rect=CGRectMake(320, 44, 320, 272);
    if([SoclivityUtilities deviceType] & iPhone5)
        
        rect = CGRectMake(320, 44, 320, 272+88);
 
    
    _mapView = [[MKMapView alloc] initWithFrame:rect];
    _mapView.delegate = self;
    [createActivityView addSubview:_mapView];
    
    self.mapView.mapType = MKMapTypeStandard;
    searching=FALSE;
    self.addressSearchBar.text=@"";
    
    [self gotoLocation];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    [lpgr release];



    if([SoclivityUtilities deviceType] & iPhone5){
        rect = CGRectMake(320, 316+88, 320, 60);
        
        
    }
    else
    {
        rect = CGRectMake(320, 316, 320, 60);
        
    }

    
    UIView *locationInfoView=[[UIView alloc]initWithFrame:rect];
    locationInfoView.alpha=0.8999;
    locationInfoView.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@".png"]];
    
    leftPinImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 17, 16, 26)];
    leftPinImageView.image=[UIImage imageNamed:@"S05.1_pin.png"];
    [locationInfoView addSubview:leftPinImageView];
    
    
    
    CGRect firstLineLabelRect=CGRectMake(54,10,228,21);
    firstALineddressLabel=[[UILabel alloc] initWithFrame:firstLineLabelRect];
    firstALineddressLabel.textAlignment=UITextAlignmentLeft;
    firstALineddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
    firstALineddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    firstALineddressLabel.backgroundColor=[UIColor clearColor];
    [locationInfoView addSubview:firstALineddressLabel];
    firstALineddressLabel.hidden=YES;
    
    
    CGRect secondLineLabelRect=CGRectMake(54,28,228,21);
    secondLineAddressLabel=[[UILabel alloc] initWithFrame:secondLineLabelRect];
    secondLineAddressLabel.textAlignment=UITextAlignmentLeft;
    secondLineAddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    secondLineAddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    secondLineAddressLabel.backgroundColor=[UIColor clearColor];
    [locationInfoView addSubview:secondLineAddressLabel];
    secondLineAddressLabel.hidden=YES;
    
    
    phoneIconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 33, 14, 14)];
    phoneIconImageView.image=[UIImage imageNamed:@"S05.1_phoneIcon.png"];
    [locationInfoView addSubview:phoneIconImageView];
    [phoneIconImageView setHidden:YES];
    
    
    
    
    
    phoneButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    phoneButton.frame = CGRectMake(16,33,164,21);
    [phoneButton addTarget:self action:@selector(phoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [locationInfoView addSubview:phoneButton];
    
    
    phoneButton.enabled=NO;

    CGRect phoneLabelRect=CGRectMake(37,30,142,21);
    phoneLabel=[[UILabel alloc] initWithFrame:phoneLabelRect];
    phoneLabel.textAlignment=UITextAlignmentLeft;
    phoneLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    phoneLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    phoneLabel.backgroundColor=[UIColor clearColor];
    [locationInfoView addSubview:phoneLabel];
    [phoneLabel setHidden:YES];
    
    ratingIconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(165, 30, 18, 18)];
    ratingIconImageView.image=[UIImage imageNamed:@"S05.1_4squareIcon.png"];
    [locationInfoView addSubview:ratingIconImageView];
    [ratingIconImageView setHidden:YES];
    
    CGRect ratingLabelRect=CGRectMake(190,30,80,21);
    ratingLabel=[[UILabel alloc] initWithFrame:ratingLabelRect];
    ratingLabel.textAlignment=UITextAlignmentLeft;
    ratingLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    ratingLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    ratingLabel.backgroundColor=[UIColor clearColor];
    [locationInfoView addSubview:ratingLabel];
    [ratingLabel setHidden:YES];



    
    
    activityInfoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    activityInfoButton.frame = CGRectMake(285,15,28,27);
    [activityInfoButton setImage:[UIImage imageNamed:@"S05.1_drivingDirectionsIcon.png"] forState:UIControlStateNormal];
    
    [activityInfoButton addTarget:self action:@selector(activityInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [locationInfoView addSubview:activityInfoButton];
    activityInfoButton.hidden=YES;
    
    
    leftMagifyImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 18, 18, 19)];
    leftMagifyImageView.image=[UIImage imageNamed:@"S05.1_magnify.png"];
    [locationInfoView addSubview:leftMagifyImageView];
    
    CGRect searchLabelRect=CGRectMake(44,10,72,21);
    searchTextLabel=[[UILabel alloc] initWithFrame:searchLabelRect];
    searchTextLabel.textAlignment=UITextAlignmentLeft;
    searchTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    searchTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    searchTextLabel.backgroundColor=[UIColor clearColor];
    searchTextLabel.text=@"Search";
    [locationInfoView addSubview:searchTextLabel];

    
    CGRect placeAddressLabelRect=CGRectMake(44,25,148,21);
    placeAndAddressLabel=[[UILabel alloc] initWithFrame:placeAddressLabelRect];
    placeAndAddressLabel.textAlignment=UITextAlignmentLeft;
    placeAndAddressLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    placeAndAddressLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    placeAndAddressLabel.backgroundColor=[UIColor clearColor];
    placeAndAddressLabel.text=@"For place or address";
    [locationInfoView addSubview:placeAndAddressLabel];

    
    

    verticalMiddleLine=[[UIImageView alloc]initWithFrame:CGRectMake(159, 5, 2, 49)];
    verticalMiddleLine.image=[UIImage imageNamed:@"S05.1_verticalLine.png"];
    [locationInfoView addSubview:verticalMiddleLine];

    
    rightPinImageView=[[UIImageView alloc]initWithFrame:CGRectMake(170, 17, 12, 20)];
    rightPinImageView.image=[UIImage imageNamed:@"S05.1_smallPin.png"];
    [locationInfoView addSubview:rightPinImageView];
    
    
    CGRect dropPinLabelRect=CGRectMake(194,10,91,21);
    dropPinLabel=[[UILabel alloc] initWithFrame:dropPinLabelRect];
    dropPinLabel.textAlignment=UITextAlignmentLeft;
    dropPinLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    dropPinLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    dropPinLabel.backgroundColor=[UIColor clearColor];
    dropPinLabel.text=@"Drop pin";
    [locationInfoView addSubview:dropPinLabel];
    
    
    
    
    CGRect touchandHoldLabelRect=CGRectMake(194,25,131,21);
    touchAndHoldMapLabel=[[UILabel alloc] initWithFrame:touchandHoldLabelRect];
    touchAndHoldMapLabel.textAlignment=UITextAlignmentLeft;
    touchAndHoldMapLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    touchAndHoldMapLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    touchAndHoldMapLabel.backgroundColor=[UIColor clearColor];
    touchAndHoldMapLabel.text=@"Touch and hold map";
    [locationInfoView addSubview:touchAndHoldMapLabel];

    
    


    
    [createActivityView addSubview:locationInfoView];
    [locationInfoView release];


    
    [self setUpLabelViewElements:YES];


    // Do any additional setup after loading the view from its nib.
}

-(void)showInAppNotificationsUsingRocketSocket:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 58) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
}

-(void)backgroundTapToPush:(NotificationClass*)notification{
    
}

-(void)setUpLabelViewElements:(BOOL)show{
    
    
    if(show){
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        firstALineddressLabel.hidden=YES;
        secondLineAddressLabel.hidden=YES;
        leftPinImageView.hidden=YES;
        searchTextLabel.hidden=NO;
        placeAndAddressLabel.hidden=NO;
        
        dropPinLabel.hidden=NO;
        touchAndHoldMapLabel.hidden=NO;
        verticalMiddleLine.hidden=NO;
        leftMagifyImageView.hidden=NO;
        rightPinImageView.hidden=NO;
    }
    else{
        
        firstALineddressLabel.hidden=NO;
        secondLineAddressLabel.hidden=YES;
        leftPinImageView.hidden=NO;
        searchTextLabel.hidden=YES;
        placeAndAddressLabel.hidden=YES;
        
        dropPinLabel.hidden=YES;
        touchAndHoldMapLabel.hidden=YES;
        verticalMiddleLine.hidden=YES;
        leftMagifyImageView.hidden=YES;
        rightPinImageView.hidden=YES;
        
    }
    
}

-(void)updateSelectLocation{
    
    
    PlacemarkClass * selectedPlacemark = [currentLocationArray objectAtIndex:pointTag];
    activityObject.where_lat=[NSString stringWithFormat:@"%f",selectedPlacemark.latitude];
    activityObject.where_lng=[NSString stringWithFormat:@"%f",selectedPlacemark.longitude];
    activityObject.where_address = [NSString stringWithFormat:@"%@#%@",selectedPlacemark.formattedAddress,selectedPlacemark.vicinityAddress];
    activityObject.venueId=selectedPlacemark.foursquareId;
    
    activityObject.where_state=selectedPlacemark.where_state;
    activityObject.where_city=selectedPlacemark.where_city;
    activityObject.where_zip=selectedPlacemark.where_zip;

    NSArray *hashCount=[activityObject.where_address componentsSeparatedByString:@"#"];
    NSLog(@"hashCount=%d",[hashCount count]);
    switch (selectedPlacemark.addType) {
         case 3:
        {
            firstALineddressLabel.text=[NSString stringWithFormat:@"%@, %@",selectedPlacemark.formattedAddress,selectedPlacemark.vicinityAddress];
        }
            break;
        case 1:
        {
            firstALineddressLabel.text=[NSString stringWithFormat:@"%@, %@",selectedPlacemark.formattedAddress,selectedPlacemark.vicinityAddress];
            
        }
            break;
        case 2:
        {
          firstALineddressLabel.text=[hashCount objectAtIndex:1];            
        }
            break;
    }

    [secondLineAddressLabel setHidden:YES];
}

-(void)activityInfoButtonClicked:(id)sender{
    [self updateSelectLocation];
    [self openMapUrlApplication];
}

-(void)openMapUrlApplication{
    
    
    BOOL canHandle = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]];
    
    if (canHandle) {
//        NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f&zoom=14&views=traffic",[activityObject.where_lat floatValue],[activityObject.where_lng floatValue]];
        
        //NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f&directionsmode=driving&views=satellite&mapmode=standard",[activityObject.where_lat floatValue],[activityObject.where_lng floatValue]];
        
        
        NSString *str = [activityObject.where_address stringByReplacingOccurrencesOfString:@"#"
                                                                     withString:@"+"];
        
            str=[str stringByReplacingOccurrencesOfString:@" "
                                           withString:@"+"];

        NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?q=%@&center=%f,%f&views=traffic&zoom=15",str,[activityObject.where_lat floatValue],[activityObject.where_lng floatValue]];

        
        

        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlString]];
    } else {
        // Use Apple maps?
        NSLog(@"iphone has Apple app");
        
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([activityObject.where_lat floatValue],[activityObject.where_lng floatValue]);
        
        //create MKMapItem out of coordinates
        MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
        
        if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
        {
            //using iOS6 native maps app
            [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
        }
        else
        {
            //using iOS 5 which has the Google Maps application
            //            NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", latitude, longitude];
            //            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            
            NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude, [activityObject.where_lat floatValue], [activityObject.where_lng floatValue]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        }
        
        [placeMark release];
        [destination release];
        
        
    }
    
    
}

- (void)gotoLocation
{
    self.mapView.showsUserLocation=YES;
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = SOC.currentLocation.coordinate.latitude;
    newRegion.center.longitude = SOC.currentLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.06;
    newRegion.span.longitudeDelta = 0.06;
    
    [self.mapView setRegion:newRegion animated:YES];
}


-(IBAction)pickADateButtonPressed:(id)sender{
    
    
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] initWithNibName:@"MJDetailViewController" bundle:nil];
    detailViewController.delegate=self;
    if(newActivity){
        detailViewController.type=PickADateViewAnimationNew;
    }
    else{
        detailViewController.type=PickADateViewAnimationEdit;
    }
    detailViewController.dateOfTheActivity=activityObject.activityDate;
    detailViewController.timeOfTheActivity=activityObject.activityTime;

    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomBottom];

}

-(IBAction)pickATimeButtonPressed:(id)sender{
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] initWithNibName:@"MJDetailViewController" bundle:nil];
    detailViewController.delegate=self;
    if(newActivity){
        detailViewController.type=PickATimeViewAnimationNew;
    }
    else{
        detailViewController.type=PickATimeViewAnimationEdit;
    }
    detailViewController.dateOfTheActivity=activityObject.activityDate;
    detailViewController.timeOfTheActivity=activityObject.activityTime;

    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}
-(IBAction)publicOrPrivateActivityButtonPressed:(id)sender{
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] initWithNibName:@"MJDetailViewController" bundle:nil];
    detailViewController.delegate=self;
    if(newActivity){
        detailViewController.type=PrivatePublicViewAnimationNew;
        if([activityObject.access caseInsensitiveCompare:@"private"] == NSOrderedSame)
            detailViewController.privacy=1;
        
        else
            detailViewController.privacy=0;
    }
    else{
        
        if([activityObject.access caseInsensitiveCompare:@"private"] == NSOrderedSame)
            detailViewController.privacy=1;
        
        else
            detailViewController.privacy=0;
        
        detailViewController.type=PrivatePublicViewAnimationEdit;
    }

    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}

-(BOOL)checkValidations{
    
    BOOL validate=FALSE;
    if(!activityNameTextField.text.length){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:@"Need a name to create an activity."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kActivityNameNot;
        [alert show];
        [alert release];
        return validate;
        
    }
    
    // Alert if the name is not valid
    if(!validAcivityName){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really?"
                                                        message:@"Activityname should not be left blank."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kActivityNameNot;
        [alert show];
        [alert release];
        return validate;
    }
    
    if(!dateSelected){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Date...!!!"
                                                        message:@"Please select a suitable date for your activity"
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
        return validate;
        
    }
    
    
    if(!timeSelected){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Time...!!!"
                                                        message:@"Please select a suitable time for your activity"
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
        return validate;
        
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:activityObject.activityTime];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    
    
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                               fromDate:activityObject.activityDate];
    [components setHour: hour];
    [components setMinute:minute];
    [components setSecond:00];
    NSDate *setFinishDate=[myCalendar dateFromComponents:components];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    activityObject.when=[dateFormatter stringFromDate:setFinishDate];
    NSLog(@"Date is =%@ and date s",activityObject.when);

    
    validate=TRUE;
    
    return validate;

}

-(IBAction)pickALocationButtonPressed:(id)sender{
    
    if([self checkValidations]){
    
    
    
// logic for getting the date
    


    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        createActivityView.transform = CGAffineTransformMakeTranslation(-320.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        backButton.hidden=NO;
        crossButton.hidden=YES;
       step1_of2Label.text=@"Step 2 of 2";
        pickALocationButton.hidden=YES;
        createActivtyStaticLabel.text=@"Pick Location";
        centerLocationButton.hidden=NO;
        locationTextLabel.hidden=NO;
        isTransition=TRUE;
        activityInfoButton.hidden=YES;
        
    }];
        
    }
}
#define kUrlRedirect 24
-(void)moreInfoUrlToSafariBrowser:(UIButton*)sender{
    urlIndex=sender.tag%777;
    
    // Setup an alert for the missing email address
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exiting Soclivity"
                                                    message:@"Open link in Safari?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.tag=kUrlRedirect;
    [alert show];
    [alert release];
    return;
    
    
}


#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView resignFirstResponder];
    
    if(alertView.tag==kUrlRedirect){
        if (buttonIndex == 1) {
            PlacemarkClass *loc=[currentLocationArray objectAtIndex:urlIndex];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loc.fsqrUrl]];
        }
    }

    else{
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kActivityNameNot:
            {
                [activityNameTextField becomeFirstResponder];
            }
                break;
                
            case kDeleteActivity:
            {
                if([SoclivityUtilities hasNetworkConnection]){
                    [self startAnimation:kDeleteActivityRequest];
                    [devServer postActivityRequestInvocation:10  playerId:[SOC.loggedInUser.idSoc intValue] actId:activityObject.activityId delegate:self];
                }
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alert show];
                    [alert release];
                    return;
                    
                    
                }
            }
                break;

            default:
                break;
        }
    }

    else{
        NSLog(@"Clicked Cancel Button");
    }
 }
}


-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{
    
    [HUD hide:YES];
    
    switch (relationTypeTag) {
            
            
        case 10:
        {
            SOC.localCacheUpdate=TRUE;
            [SoclivitySqliteClass deleteActivityRecords:activityObject.activityId];
            [SOC deleteASingleEvent:activityObject.activityId];

            
            
            [delegate deleteActivityEventByOrganizer];
            
        }
            break;
            
            
        default:
            break;
    }
}


-(IBAction)backButtonPressed:(id)sender{
    
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        createActivityView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        backButton.hidden=YES;
        crossButton.hidden=NO;
        step1_of2Label.text=@"Step 1 of 2";
        pickALocationButton.hidden=NO;
        createActivtyStaticLabel.text=@"Create Activity";
        centerLocationButton.hidden=YES;
        locationTextLabel.hidden=YES;
        createActivityButton.hidden=YES;
        isTransition=FALSE;
        activityInfoButton.hidden=YES;
    }];

}

-(IBAction)currentLocationButtonClicked:(id)sender{
    [self gotoLocation];
}

-(IBAction)createActivityButtonClicked:(id)sender{
    
    [self updateSelectLocation];
    activityObject.activityName=activityNameTextField.text;
    activityObject.what=descriptionTextView.text;
    if([capacityTextField.text length]!=0)
      activityObject.num_of_people=[capacityTextField.text intValue];
    // time to start the activity monitor
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:0];
        [devServer postCreateANewActivityInvocation:activityObject delegate:self];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

    
}

-(void)startAnimation:(NSInteger)type{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    switch (type) {
        case 0:
        {
            HUD.labelText = @"Creating Activity";
            
        }
            break;
            
        case 1:
        {
            HUD.labelText = @"Editing";
            
        }
            break;
            
        case kDeleteActivityRequest:
        {
            HUD.labelText = @"Deleting Activity";
            
        }
            break;

    }

    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)PostNewActivityRequestInvocationDidFinish:(NewActivityInvocation*)invocation
                                    withResponse:(InfoActivityClass*)response
                                       withError:(NSError*)error{
    
    [HUD hide:YES];
    
    NSLog(@"Responses=%@",response);
    if(response!=nil){
        if([SoclivityUtilities hasNetworkConnection]){
        [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:response.activityId  latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude delegate:self];
        }
        
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            return;
            
            
        }


    }
    else{
        NSLog(@"Some Error");
    }
}

#pragma mark -
#pragma mark DetailedActivityInfoInvocationDelegate Method

-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)responses
                                     withError:(NSError*)error{
    

        if(responses!=nil){
            
            [SOC deltaUpdateSyncCalendar:responses];

            [delegate pushToNewActivity:responses];
            
            

            
        }
        else{
            NSLog(@"Some Error");

        }
}
-(void)backgroundtap:(UITapGestureRecognizer*)sender{
    
    [activityNameTextField resignFirstResponder];
    [capacityTextField resignFirstResponder];
    [descriptionTextView resignFirstResponder];
    
    [self enableOrDisablePickerElements:YES];

    CGRect clearTextRect=CGRectMake(250, 60, 57, 30);
    CGPoint translate = [sender locationInView:self.view.superview];
    if(CGRectContainsPoint(clearTextRect,translate)&& isTransition){
        [self customCancelButtonHit];
    }

    
   NSLog(@"Start Point_X=%f,Start Point_Y=%f",translate.x,translate.y);
}

-(void)updateActivityType:(NSInteger)type{
    
    activityType=type;
    switch (activityType) {
            
    case kPlayActivity:
    {
        activityObject.type=1;

        [(UILabel*)[createActivityView viewWithTag:kPlayLabelText] setAlpha:1.0f];
        [(UIImageView*)[createActivityView viewWithTag:kPlayTickImage]setAlpha:1.0f];
        
        [(UILabel*)[createActivityView viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:10];
        
    }
        break;
        
        
        
    case kEatActivity:
    {
        activityObject.type=2;

        [(UILabel*)[createActivityView viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kEatLabelText] setAlpha:1.0f];
        [(UIImageView*)[createActivityView viewWithTag:kEatTickImage]setAlpha:1.0f];
        
        [(UILabel*)[createActivityView viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:11];
        
    }
        break;
        
    case kSeeActivity:
    {
        activityObject.type=3;

        [(UILabel*)[createActivityView viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kSeeLabelText] setAlpha:1.0f];
        [(UIImageView*)[createActivityView viewWithTag:kSeeTickImage]setAlpha:1.0f];
        
        [(UILabel*)[createActivityView viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:12];
        
        
        
        
        
    }
        break;
    case kCreateActivity:
    {
        activityObject.type=4;

        [(UILabel*)[createActivityView viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kCreateLabelText] setAlpha:1.0f];
        [(UIImageView*)[createActivityView viewWithTag:kCreateTickImage]setAlpha:1.0f];
        
        [(UILabel*)[createActivityView viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:13];
        
        
        
        
        
    }
        break;
    case kLearnActivity:
    {
        activityObject.type=5;

        [(UILabel*)[createActivityView viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[createActivityView viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[createActivityView viewWithTag:kLearnLabelText] setAlpha:1.0f];
        [(UIImageView*)[createActivityView viewWithTag:kLearnTickImage]setAlpha:1.0f];
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:14];
        
        
    }
        break;
        
        
        
    default:
        break;
}
}
-(void)activityButtonPressed:(UIButton*)sender{
    [self updateActivityType:sender.tag];
}

-(IBAction)crossClicked:(id)sender{
    
    [delegate cancelCreateActivityEventScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) geocodeFromSearchBar:(NSInteger)type{
    // in case of error use api key like
    
    responseData = [[NSMutableData data] retain];
    selectionType=type;
    NSString*urlString=nil;
    switch (selectionType) {
            
            
        case 1:
        {
            urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&bounds=%f,%f|%f,%f&sensor=false",addressSearchBar.text,SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude,SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude];
            
            urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
        }
            break;
            
        case 2:
        {
            urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=80000&name=%@&sensor=false&key=AIzaSyDYk5wlP6Pg6uA7PGJn853bnIj5Y8bmNnk",SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude,[addressSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
        }
            break;
            
            
        case 3:
        {
            urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?keyword=%@&location=%f,%f&rankby=distance&sensor=false&key=AIzaSyDYk5wlP6Pg6uA7PGJn853bnIj5Y8bmNnk",[addressSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude];
            
        }
            break;
            
    }
	
	
    // Create NSURL string from formatted string
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSLog(@"Connection failed: %@", [error description]);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
													message:@"Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	return;
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
    NSDictionary* resultsd = [[[NSString alloc] initWithData:responseData
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    if(selectionType==6){
        NSDictionary *response=[resultsd objectForKey:@"response"];
        NSDictionary*pins=[response objectForKey:@"venue"];
        PlacemarkClass * placemark = [currentLocationArray objectAtIndex:pointTag];
        placemark.addType=2;
        
        if([pins objectForKey:@"rating"]!=nil && [[pins objectForKey:@"rating"] class]!=[NSNull null]){
            placemark.ratingValue=ratingLabel.text=[NSString stringWithFormat:@"Rating: %@",[[pins objectForKey:@"rating"]stringValue]];
            
        }
        else{
            placemark.ratingValue=ratingLabel.text=[NSString stringWithFormat:@"Rating: N/A"];
        }
        
         createActivityButton.hidden=NO;
        
        
        return;
    }
    
    if(selectionType==4){
        NSDictionary *dict = [resultsd objectForKey:@"results"];
        for(id object in dict){
            
            PlacemarkClass * placemark = [currentLocationArray objectAtIndex:pointTag];
            
            
            NSArray *addressComponents=[object objectForKey:@"address_components"];
            
            for(id comp in addressComponents){
                
                NSArray *geometryDict = [comp objectForKey:@"types"];
                for(NSString *type in geometryDict){
                    if([type isEqualToString:@"street_number"]){
                        placemark.streetNumber=[comp valueForKey:@"long_name"];
                        NSLog(@"street_number=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    if([type isEqualToString:@"route"]){
                        placemark.route=[comp valueForKey:@"short_name"];
                        NSLog(@"route=%@",[comp valueForKey:@"short_name"]);
                    }
                    
                    if([type isEqualToString:@"administrative_area_level_2"]){
                        NSLog(@"administrative_area_level_2=%@",[comp valueForKey:@"long_name"]);
                        placemark.where_city=[comp valueForKey:@"long_name"];
                    }
                    
                    if([type isEqualToString:@"administrative_area_level_1"]){
                        
                        placemark.where_state=[comp valueForKey:@"short_name"];                        NSLog(@"administrative_area_level_1=%@",[comp valueForKey:@"short_name"]);
                    }
                    
                    if([type isEqualToString:@"postal_code"]){
                        
                        placemark.where_zip=[comp valueForKey:@"long_name"];                NSLog(@"postal_code=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    
                    
                }
                
            }
            NSString *localString=nil;
            if(((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""]))&&((placemark.route==nil) || ([placemark.route isEqualToString:@""]))){
                NSString *commaSeperated=[object objectForKey:@"formatted_address"];
                NSArray *results=[commaSeperated componentsSeparatedByString:@","];
                if([results count]>0){
                    localString=[results objectAtIndex:0];
                    placemark.addType=1;
                }
            }
            else if((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""])){
                localString =[NSString stringWithFormat:@"%@",placemark.route];
                placemark.addType=2;
            }
            else if((placemark.route==nil) || ([placemark.route isEqualToString:@""])){
                localString =[NSString stringWithFormat:@"%@",placemark.streetNumber];
                placemark.addType=3;
            }
            else{
                localString =[NSString stringWithFormat:@"%@ %@",placemark.streetNumber,placemark.route];
                placemark.addType=4;
                
            }
            placemark.vicinityAddress=secondLineAddressLabel.text=[NSString stringWithFormat:@"%@, %@, %@",localString,placemark.where_city,placemark.where_state];
            
        }
        
         createActivityButton.hidden=NO;
        
        return;
    }
    
    [_geocodingResults removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    searching=FALSE;
    
    [responseData release];
  
#if FOURSQUARE
    
    if(selectionType==1){
        NSDictionary *dict = [resultsd objectForKey:@"results"];
        indexRE=1;
        for(id object in dict){
            PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
            placemark.moreInfoAvailable=NO;
            placemark.category=@"Address";
            placemark.ratingValue=@"Rating: N/A";
            placemark.formattedPhNo=@"Not Available";
            placemark.addType=1;
            phoneButton.enabled=NO;
            NSArray *addressComponents=[object objectForKey:@"address_components"];
            for(id comp in addressComponents){
                
                NSArray *geometryDict = [comp objectForKey:@"types"];
                for(NSString *type in geometryDict){
                    if([type isEqualToString:@"street_number"]){
                        placemark.streetNumber=[comp valueForKey:@"long_name"];
                        NSLog(@"street_number=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    if([type isEqualToString:@"route"]){
                        placemark.route=[comp valueForKey:@"long_name"];
                        NSLog(@"route=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    if([type isEqualToString:@"administrative_area_level_2"]){
                        NSLog(@"administrative_area_level_2=%@",[comp valueForKey:@"long_name"]);
                        placemark.where_city=[comp valueForKey:@"long_name"];
                    }
                    
                    if([type isEqualToString:@"administrative_area_level_1"]){
                        
                        placemark.where_state=[comp valueForKey:@"short_name"];                        NSLog(@"administrative_area_level_1=%@",[comp valueForKey:@"short_name"]);
                    }
                    
                    if([type isEqualToString:@"postal_code"]){
                        
                        placemark.where_zip=[comp valueForKey:@"long_name"];                        NSLog(@"postal_code=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    
                    
                }
                
            }
            NSDictionary *geometryLocDict = [object objectForKey:@"geometry"];
            placemark.latitude = [[[geometryLocDict objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            placemark.longitude = [[[geometryLocDict objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            
            
            if(((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""]))&&((placemark.route==nil) || ([placemark.route isEqualToString:@""]))){
                NSString *commaSeperated=[object objectForKey:@"formatted_address"];
                NSArray *results=[commaSeperated componentsSeparatedByString:@","];
                if([results count]>0){
                    placemark.formattedAddress=[results objectAtIndex:0];
                }
            }
            else{
                
                if((placemark.route==nil) || ([placemark.route isEqualToString:@""])){
                    placemark.formattedAddress =[NSString stringWithFormat:@"%@",placemark.streetNumber];
                }
                else if((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""])){
                    placemark.formattedAddress =[NSString stringWithFormat:@"%@",placemark.route];
                }
                
                
                else{
                    if([[placemark.streetNumber lowercaseString] isEqualToString:[placemark.route lowercaseString]]){
                        placemark.formattedAddress =[NSString stringWithFormat:@"%@",placemark.streetNumber];
                    }else
                        placemark.formattedAddress =[NSString stringWithFormat:@"%@ %@",placemark.streetNumber,placemark.route];
                    
                }
                
            }
            
            if(((placemark.where_state==nil) || ([placemark.where_state isEqualToString:@""]))&&((placemark.where_city==nil) || ([placemark.where_city isEqualToString:@""]))){
                
                placemark.vicinityAddress =@"";
            }
            else if((placemark.where_city==nil) || ([placemark.where_city isEqualToString:@""])){
                placemark.vicinityAddress  =[NSString stringWithFormat:@"%@",placemark.where_state];
            }
            else if((placemark.where_state==nil) || ([placemark.where_state isEqualToString:@""])){
                placemark.vicinityAddress  =[NSString stringWithFormat:@"%@",placemark.where_city];
            }
            
            
            else{
                
                if([[placemark.where_state lowercaseString] isEqualToString:[placemark.where_city lowercaseString]]){
                    placemark.vicinityAddress =[NSString stringWithFormat:@"%@",placemark.where_state];
                }else
                    
                    placemark.vicinityAddress =[NSString stringWithFormat:@"%@, %@",placemark.where_city,placemark.where_state];
                
            }
            [_geocodingResults addObject:placemark];
            
        }
        
    }
    
    else if(selectionType==5){
        indexRE=5;
        NSDictionary *response=[resultsd objectForKey:@"response"];
        
        NSArray *groups=[response objectForKey:@"groups"];
        NSDictionary *list = [groups objectAtIndex:0];
        NSArray *items=[list objectForKey:@"items"];
        
        for(NSDictionary *item in items){
            
            NSDictionary *pins=[item objectForKey:@"venue"];
            
            PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
            placemark.addType=2;
            placemark.queryName=[pins objectForKey:@"name"];
            placemark.foursquareId=[pins objectForKey:@"id"];
            
            if([[pins objectForKey:@"contact"]objectForKey:@"formattedPhone"]!=nil && [[[pins objectForKey:@"contact"]objectForKey:@"formattedPhone"] class]!=[NSNull null]){
                placemark.formattedPhNo=[[pins objectForKey:@"contact"]objectForKey:@"formattedPhone"];
                    phoneButton.enabled=YES;
            }
            else{
                placemark.formattedPhNo=phoneLabel.text=@"Not Available";
                    phoneButton.enabled=NO;
            }
            
            
            if([pins objectForKey:@"url"]!=nil && [[pins objectForKey:@"url"] class]!=[NSNull null]){
                placemark.moreInfoAvailable=YES;
                placemark.fsqrUrl=[pins objectForKey:@"url"];
            }
            
            if([pins objectForKey:@"categories"]!=nil && [[pins objectForKey:@"categories"] class]!=[NSNull null]){
                NSArray *category=[pins objectForKey:@"categories"];
                for(NSDictionary *text in category)
                    placemark.category=[text objectForKey:@"name"];
            }
            // Pulling rating information
            if([pins objectForKey:@"rating"]!=nil && [[pins objectForKey:@"rating"] class]!=[NSNull null]) {
                placemark.ratingValue=[NSString stringWithFormat:@"Rating: %@",[[pins objectForKey:@"rating"]stringValue]];
            }
            else
                placemark.ratingValue=[NSString stringWithFormat:@"Rating: N/A"];
            
            if([pins objectForKey:@"location"]!=nil && [[pins objectForKey:@"location"] class]!=[NSNull null]){
                
                placemark.latitude = [[[pins objectForKey:@"location"]objectForKey:@"lat"] floatValue];
                placemark.longitude =[[[pins objectForKey:@"location"]objectForKey:@"lng"] floatValue];
                placemark.where_zip=[[pins objectForKey:@"location"]objectForKey:@"postalCode"];
                placemark.where_city=[[pins objectForKey:@"location"]objectForKey:@"city"];
                placemark.where_state=[[pins objectForKey:@"location"]objectForKey:@"state"];
                
                
                if([[pins objectForKey:@"location"]objectForKey:@"address"]!=nil && [[[pins objectForKey:@"location"]objectForKey:@"address"] class]!=[NSNull null]){
                    placemark.address=[[pins objectForKey:@"location"]objectForKey:@"address"];
                    
                    placemark.formattedAddress =[NSString stringWithFormat:@"%@",placemark.queryName];
                    
                    NSString *localString=nil;
                    if(((placemark.where_city==nil) || ([placemark.where_city isEqualToString:@""]))&&((placemark.where_state==nil) || ([placemark.where_state isEqualToString:@""]))){
                        
                        localString=@"";
                    }
                    else if((placemark.where_city==nil) || ([placemark.where_city isEqualToString:@""])){
                        localString =[NSString stringWithFormat:@"%@",placemark.where_state];
                    }
                    else if((placemark.where_state==nil) || ([placemark.where_state isEqualToString:@""])){
                        localString =[NSString stringWithFormat:@"%@",placemark.where_city];
                    }
                    else{
                        
                        if([[placemark.where_state lowercaseString] isEqualToString:[placemark.where_city lowercaseString]]){
                            localString =[NSString stringWithFormat:@"%@",placemark.where_city];
                        }
                        else{
                            localString =[NSString stringWithFormat:@"%@, %@",placemark.where_city,placemark.where_state];
                            
                        }
                        
                    }
                    
                    placemark.vicinityAddress=[NSString stringWithFormat:@"%@, %@",placemark.address,localString];
                    
                    [_geocodingResults addObject:placemark];
                    
                }
                
            }
            
        }
        
    }
    if([_geocodingResults count]!=0){
        searching=TRUE;
        
        [self addPinAnnotationForPlacemark:_geocodingResults droppedStatus:NO];
        currentLocationArray =[NSMutableArray arrayWithCapacity:[_geocodingResults count]];
        currentLocationArray=[_geocodingResults retain];
        
        //Zoom in all results.
        
        CLLocation* avgLoc = [self ZoomToAllResultPointsOnMap];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenAllResultPointsOnMap:avgLoc], [self maxDistanceBetweenAllResultPointsOnMap:avgLoc]);
        adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
        
        [self setUpLabelViewElements:NO];
        firstALineddressLabel.text=@"Pick a Location";
        
        [secondLineAddressLabel setHidden:NO];
        [self showFourSquareComponents:NO];
        secondLineAddressLabel.text=@"Select a pin above to see it's full address";
        
        
        
    }
    else{
        //firstTime
        if(indexRE==1)
            [self getVenuesFromFourSquareApi];
        else if(indexRE==5){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                            message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
            [alert release];
            return;
            
        }
    }
    
#else
    
    
    if(selectionType==1){
        indexRE=1;
        for(id object in dict){
            PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
            
            NSArray *addressComponents=[object objectForKey:@"address_components"];
            for(id comp in addressComponents){
                
                NSArray *geometryDict = [comp objectForKey:@"types"];
                for(NSString *type in geometryDict){
                    if([type isEqualToString:@"street_number"]){
                        placemark.streetNumber=[comp valueForKey:@"long_name"];
                        NSLog(@"street_number=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    if([type isEqualToString:@"route"]){
                        placemark.route=[comp valueForKey:@"long_name"];
                        NSLog(@"route=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    if([type isEqualToString:@"administrative_area_level_2"]){
                        NSLog(@"administrative_area_level_2=%@",[comp valueForKey:@"long_name"]);
                        placemark.adminLevel2=[comp valueForKey:@"long_name"];
                    }
                    
                    if([type isEqualToString:@"administrative_area_level_1"]){
                        
                        placemark.adminLevel1=[comp valueForKey:@"short_name"];                        NSLog(@"administrative_area_level_1=%@",[comp valueForKey:@"short_name"]);
                    }
                    
                    if([type isEqualToString:@"postal_code"]){
                        
                        placemark.whereZip=[comp valueForKey:@"long_name"];                        NSLog(@"postal_code=%@",[comp valueForKey:@"long_name"]);
                    }
                    
                    
                    
                }
                
            }
            NSDictionary *geometryLocDict = [object objectForKey:@"geometry"];
            placemark.latitude = [[[geometryLocDict objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            placemark.longitude = [[[geometryLocDict objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            
            
            if(((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""]))&&((placemark.route==nil) || ([placemark.route isEqualToString:@""]))){
                NSString *commaSeperated=[object objectForKey:@"formatted_address"];
                NSArray *results=[commaSeperated componentsSeparatedByString:@","];
                if([results count]>0){
                    placemark.formattedAddress=[results objectAtIndex:0];
                }
            }
            else{
                placemark.formattedAddress =[NSString stringWithFormat:@"%@ %@",placemark.streetNumber,placemark.route];
            }
            placemark.vicinityAddress=[NSString stringWithFormat:@"%@ ,%@",placemark.adminLevel2,placemark.adminLevel1];
            [_geocodingResults addObject:placemark];
            
        }
        
    }
    else if(selectionType==2){
        
        indexRE=2;
        
        for(id object in dict){
            PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
            NSDictionary *geometryDict = [object objectForKey:@"geometry"];
            placemark.latitude = [[[geometryDict objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            placemark.longitude = [[[geometryDict objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            
            placemark.formattedAddress =[object objectForKey:@"name"];
            [_geocodingResults addObject:placemark];
        }
        
    }
    
    else if(selectionType==3){
        
        indexRE=3;
        
        for(id object in dict){
            PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
            NSDictionary *geometryDict = [object objectForKey:@"geometry"];
            placemark.latitude = [[[geometryDict objectForKey:@"location"] objectForKey:@"lat"] floatValue];
            placemark.longitude = [[[geometryDict objectForKey:@"location"] objectForKey:@"lng"] floatValue];
            
            placemark.formattedAddress =[object objectForKey:@"name"];
            [_geocodingResults addObject:placemark];
        }
        
    }
    if([_geocodingResults count]>0){
        searching=TRUE;
        [self addPinAnnotationForPlacemark:_geocodingResults droppedStatus:NO];
        currentLocationArray =[NSMutableArray arrayWithCapacity:[_geocodingResults count]];
        currentLocationArray=[_geocodingResults retain];
        
        //Zoom in all results.
        
        CLLocation* avgLoc = [self ZoomToAllResultPointsOnMap];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(avgLoc.coordinate.latitude, avgLoc.coordinate.longitude), [self maxDistanceBetweenAllResultPointsOnMap:avgLoc], [self maxDistanceBetweenAllResultPointsOnMap:avgLoc]);
        adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        [self setUpLabelViewElements:NO];
        firstALineddressLabel.text=@"Pick a Location";
        secondLineAddressLabel.text=@"Select a pin above to see it's full address";
        
        
        
    }
    else{
        //firstTime
        if(indexRE==1)
            [self geocodeFromSearchBar:2];
        else if(indexRE==2)
            [self geocodeFromSearchBar:3];
        else if(indexRE==3){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found "
                                                            message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            [alert show];
            [alert release];
            return;
            
        }
    }
#endif
	
}

-(void)showFourSquareComponents:(BOOL)show{
    
    if(show){
        
        firstALineddressLabel.frame=CGRectMake(16, 7, 228+30, 21);
        phoneIconImageView.hidden=NO;
        phoneLabel.hidden=NO;
        ratingIconImageView.hidden=NO;
        ratingLabel.hidden=NO;
        activityInfoButton.hidden=NO;
        leftPinImageView.hidden=YES;
        
    }
    else{
        firstALineddressLabel.frame=CGRectMake(54, 10, 228, 21);
        phoneIconImageView.hidden=YES;
        phoneLabel.hidden=YES;
        ratingIconImageView.hidden=YES;
        ratingLabel.hidden=YES;
        activityInfoButton.hidden=YES;
        leftPinImageView.hidden=NO;
        
    }
}

-(CGFloat) maxDistanceBetweenAllResultPointsOnMap:(CLLocation*)avgLocation{
    if (currentLocationArray.count==1) {
        return 2*METERS_PER_MILE;
    }
    else{
        CGFloat distance=0;
        CLLocation *newCenter;
        
        for (int i=0; i<currentLocationArray.count; i++) {
            
            PlacemarkClass * placemark = [currentLocationArray objectAtIndex:i];
            newCenter = [[CLLocation alloc] initWithLatitude:placemark.latitude
                                                   longitude:placemark.longitude];
            
            distance =(distance>[avgLocation distanceFromLocation:(CLLocation*)newCenter]?distance:[avgLocation distanceFromLocation:(CLLocation*)newCenter]);
        }
        return 2*distance;
    }
}


-(CLLocation*)ZoomToAllResultPointsOnMap{
    CGFloat xAvg=0;
    CGFloat yAvg=0;
    for (int i=0; i<currentLocationArray.count; i++) {
        
        PlacemarkClass * placemark = [currentLocationArray objectAtIndex:i];
        xAvg+=placemark.latitude;
        yAvg+=placemark.longitude;
        
    }
    return [[CLLocation alloc] initWithLatitude:xAvg/currentLocationArray.count longitude:yAvg/currentLocationArray.count];
}


- (void) addPinAnnotationForPlacemark:(NSArray*)placemarks droppedStatus:(BOOL)droppedStatus {
    
    for(int i=0;i<[placemarks count];i++){
        
        PlacemarkClass * placemark = [placemarks objectAtIndex:i];
        NSString*tryIndex=[NSString stringWithFormat:@"777%d",i];
        
        
        ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithAnnotation:placemark  tag:[tryIndex intValue] pin:droppedStatus]autorelease];
        
        [self.mapView addAnnotation:sfAnnotation];
        
        preSelectionIndex=selectionType;
        
        
    }
}



#define kOFFSET_FOR_KEYBOARD 20.0

#pragma mark -
#pragma mark UITextViewDelegate Methods

-(void)textViewDidChange:(UITextView *)textView{
    
    if(![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
    else{
        placeholderLabel.hidden = YES;
    }
    
}

-(void)enableOrDisablePickerElements:(BOOL)show{
    
    if(show){
        
        pickADayButton.enabled=YES;
        pickATimeButton.enabled=YES;
        publicPrivateButton.enabled=YES;
        pickADayImageButton.enabled=YES;
        pickATimeImageButton.enabled=YES;
        privacyImageButton.enabled=YES;

    }
    else{
        pickADayButton.enabled=NO;
        pickATimeButton.enabled=NO;
        publicPrivateButton.enabled=NO;
        pickADayImageButton.enabled=NO;
        pickATimeImageButton.enabled=NO;
        privacyImageButton.enabled=NO;

    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    [self enableOrDisablePickerElements:NO];
 
   if(!([SoclivityUtilities deviceType] & iPhone5)){
        [self setViewMovedUp:YES];
        
    }

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	BOOL flag = NO;
	
	
	if ([text isEqualToString:@"\n"]){
		[descriptionTextView resignFirstResponder];
        return NO;
	}
	
	if([text length] == 0)
	{
		if([textView.text length] != 0)
		{
			flag = YES;
			NSString *Temp = countTextLabel.text;
			int j = [Temp intValue];
            NSLog(@"j=%d",j);
            
			j = j-1 ;
			countTextLabel.text= [[NSString alloc] initWithFormat:@"%i/",j];

			return YES;
		}
		else {
			return NO;
		}
		
		
	}
	else if([[textView text] length] > 159)
	{
		return NO;
	}
	if(flag == NO)
	{
        NSLog(@"[descriptionTextView.text length]=%i",[descriptionTextView.text length]);
		countTextLabel.text= [[NSString alloc] initWithFormat:@"%i/",[descriptionTextView.text length]+1];
		
		
	}
	
	
	return YES;
	
	
}
#if 1
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}

#else
-(void)setViewMovedUp:(BOOL)movedUp
{

    if(movedUp){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];

        CGRect rect = CGRectMake(0, -20, 320, 480);
            
        self.view.frame = rect;
        [UIView commitAnimations];
    }else{
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        
        CGRect rect = CGRectMake(0, 0, 320, 480);
        self.view.frame = rect;
        [UIView commitAnimations];

    }

}
#endif

-(void)textViewDidEndEditing:(UITextView *)textView{
	NSLog(@"The string is %@",textView.text);
	
    
    [self enableOrDisablePickerElements:YES];


    if (![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
    
    if(!([SoclivityUtilities deviceType] & iPhone5)){
        
        [self setViewMovedUp:NO];
        
    }

	[descriptionTextView resignFirstResponder];
    
    
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //set color for placeholder text
    textField.textColor = [SoclivityUtilities returnTextFontColor:1];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
    [self enableOrDisablePickerElements:NO];

    
    if(textField==capacityTextField){

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        
        CGRect rect;
        if([SoclivityUtilities deviceType] & iPhone5){

            rect = CGRectMake(0, -140, 320, 568);
        }
        else{
            rect = CGRectMake(0, -175, 320, 480);

        }
        self.view.frame = rect;
        [UIView commitAnimations];

        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
    
    // Checking the name field
    if(textField == activityNameTextField) {
        // Check length of the name
        NSInteger length;
        length = [textField.text length];
        if (length==0)
            validAcivityName = NO;
        else
            validAcivityName = YES;
    }
    
    NSLog(@"textFieldShouldReturn");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.view.frame = rect;
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    [self enableOrDisablePickerElements:YES];


    [textField resignFirstResponder];

    
     return NO;
}
#pragma mark -
#pragma mark PopUpPickerView Methods


- (void)dismissPickerFromView:(id)sender{
 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void)pickADateSelectionDone:(NSDate*)activityDate{
    
    
    activityObject.activityDate=activityDate;
    
    NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE, MMMM d, YYYY"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:activityDate];


    
    dateSelected=TRUE;
    int yOrigin;
    if([SoclivityUtilities deviceType] & iPhone5){
        yOrigin=224;
    }
    else
        yOrigin=213;
    pickADayButton.frame=CGRectMake(65, yOrigin, 208, 44);
    [pickADayButton setTitle:prefixDateString forState:UIControlStateNormal];
    [pickADayButton setTitle:prefixDateString forState:UIControlStateHighlighted];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];

    
}
-(void)pickATimeSelectionDone:(NSDate*)activityTime{
    
    timeSelected=TRUE;
    activityObject.activityTime=activityTime;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"]; //24hr time format
    NSString *timeString = [outputFormatter stringFromDate:activityTime];
    [outputFormatter release];

    
    int yOrigin;
    if([SoclivityUtilities deviceType] & iPhone5){
        yOrigin=274;
    }
    else
        yOrigin=263;

    pickATimeButton.frame=CGRectMake(65, yOrigin, 208, 44);
    [pickATimeButton setTitle:timeString forState:UIControlStateNormal];
    [pickATimeButton setTitle:timeString forState:UIControlStateHighlighted];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}
-(void)privacySelectionDone:(int)row{
    
    int yOrigin=313;


    switch (row) {
        case 0:
        {
            if([SoclivityUtilities deviceType] & iPhone5){
                yOrigin=320;
            }
            activityObject.access=@"public";
            
            publicPrivateButton.frame=CGRectMake(65, yOrigin,208, 44);

            [privacyImageButton setBackgroundImage:[UIImage imageNamed:@"S05_public5.png"] forState:UIControlStateNormal];
            
            [privacyImageButton setBackgroundImage:[UIImage imageNamed:@"S05_public5.png"] forState:UIControlStateHighlighted];
            
            [publicPrivateButton setTitle:@"Public" forState:UIControlStateNormal];
            [publicPrivateButton setTitle:@"Public" forState:UIControlStateHighlighted];
            
            onlyInviteesIphone5Label.text=@"Anyone can see this event";

            
        }
            break;
            
        case 1:
        {
            activityObject.access=@"private";
            
            if([SoclivityUtilities deviceType] & iPhone5){
                yOrigin=320;
            }
            
            publicPrivateButton.frame=CGRectMake(65, yOrigin, 208, 44);
            [privacyImageButton setBackgroundImage:[UIImage imageNamed:@"S05_private5.png"] forState:UIControlStateNormal];
            
            [privacyImageButton setBackgroundImage:[UIImage imageNamed:@"S05_private5.png"] forState:UIControlStateHighlighted];
            
            [publicPrivateButton setTitle:@"Private" forState:UIControlStateNormal];
            [publicPrivateButton setTitle:@"Private" forState:UIControlStateHighlighted];
            
            onlyInviteesIphone5Label.text=@"Only invitees can see this event";

            
        }
            break;
    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}

#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing=%@",searchBar.text);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if([self.addressSearchBar.text isEqualToString:@""]){
        
        [searchBar setShowsCancelButton:NO animated:YES];
        self.addressSearchBar.showClearButton=NO;
        
    }
    else{
        [searchBar setShowsCancelButton:NO animated:NO];
        self.addressSearchBar.showClearButton=YES;
        
    }
    [searchBar setShowsCancelButton:YES animated:NO];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    self.addressSearchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self.addressSearchBar resignFirstResponder];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    [self.addressSearchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    
#if FOURSQUARE

    if([SoclivityUtilities hasLeadingNumberInString:self.addressSearchBar.text]){
        [self geocodeFromSearchBar:1];
        
    }
    else{
        [self getVenuesFromFourSquareApi];
        
    }
    
#else
    if([SoclivityUtilities hasLeadingNumberInString:self.addressSearchBar.text]){
        [self geocodeFromSearchBar:1];
        
    }
    else{
        [self geocodeFromSearchBar:2];
        
    }
    
    
#endif
}


-(void)getVenuesFromFourSquareApi{
    // in case of error use api key like
    
    responseData = [[NSMutableData data] retain];
    NSString*urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT&client_secret=UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR&v=20130117&query=%@&ll=%f,%f",addressSearchBar.text,SOC.currentLocation.coordinate.latitude,SOC.currentLocation.coordinate.longitude];
    urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"urlString=%@",urlString);
    selectionType=5;
    // Create NSURL string from formatted string
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)customCancelButtonHit{
    
    
    searching=FALSE;
    self.addressSearchBar.text=@"";
    self.addressSearchBar.showClearButton=NO;
    [addressSearchBar setShowsCancelButton:NO animated:YES];
    [self.addressSearchBar resignFirstResponder];
    [self showFourSquareComponents:NO];
    [self setUpLabelViewElements:YES];
    
    createActivityButton.hidden=YES;
    
}

-(IBAction)crossLocationButtonClicked:(id)sender{
    
    
    locationTextLabel.hidden=NO;
    createActivityButton.hidden=YES;
    locationCrossButton.hidden=YES;
    
    backButton.hidden=NO;
    [self.addressSearchBar resignFirstResponder];
    
    self.mapView.showsUserLocation=YES;
    searching=FALSE;
    self.addressSearchBar.text=@"";
    [self gotoLocation];
    [self showFourSquareComponents:NO];
    [self setUpLabelViewElements:YES];

}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    
    else if ([annotation isKindOfClass:[ActivityAnnotation class]]){
        
        ActivityAnnotation *location = (ActivityAnnotation *) annotation;
        static NSString* SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        static NSString* ActivityAnnotationIdentifier = @"ActivityAnnotationIdentifier";
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        //if (!pinView)
        {
            MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:ActivityAnnotationIdentifier] autorelease];
#if 0
            UIImage *flagImage=[UIImage imageNamed:@"S05.1_pinUnselected.png"];
            
            
            CGRect resizeRect;
            
            resizeRect.size = flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         10.0f,
                                         10.0f).size;
            maxSize.height -= 44 +  40.0f;
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [flagImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
#endif
            annotationView.image = [UIImage imageNamed:@"S05.1_pinUnselected.png"];
            annotationView.opaque = NO;
            
            if(location.pinDrop){
                CGRect pinDropLabelRect=CGRectMake(10,0,80,16);
                UILabel *pinDropLabel=[[UILabel alloc] initWithFrame:pinDropLabelRect];
                pinDropLabel.textAlignment=UITextAlignmentCenter;
                pinDropLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
                pinDropLabel.textColor=[UIColor whiteColor];
                pinDropLabel.backgroundColor=[UIColor clearColor];
                pinDropLabel.text=@"Dropped Pin";
                annotationView.leftCalloutAccessoryView=pinDropLabel;
                [pinDropLabel release];
                
            }
            else{
                annotationView.leftCalloutAccessoryView=[self DrawAMapLeftAccessoryView:location];
                if(location.annotation.moreInfoAvailable){
                    
                    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
                    rightView.backgroundColor=[UIColor clearColor];
                    disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
                    disclosureButton.frame = CGRectMake(0.0, 0.0, 29.0, 30.0);
                    [disclosureButton setImage:[UIImage imageNamed:@"S02.1_rightarrow.png"] forState:UIControlStateNormal];
                    disclosureButton.tag=location.annotTag;
                    [disclosureButton addTarget:self action:@selector(moreInfoUrlToSafariBrowser:) forControlEvents:UIControlEventTouchUpInside];
                    [rightView addSubview:disclosureButton];
                    switch (selectionType) {
                        case 7:
                        {
                            [disclosureButton setHidden:YES];
                            
                        }
                            break;
                            
                        default:
                        {
                            [disclosureButton setHidden:NO];
                            
                        }
                            break;
                    }
                    
                    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                                  initWithFrame:CGRectMake(4.5, 5.0f, 20.0f, 20.0f)];
                    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                    activityIndicator.tag=location.annotTag;
                    [activityIndicator setHidden:YES];
                    [rightView addSubview:activityIndicator];
                    // release it
                    [activityIndicator release];
                    
                    annotationView.rightCalloutAccessoryView=rightView;
                }

            }
            
            annotationView.canShowCallout=YES;
            pinView.animatesDrop=YES;
            return annotationView;
        }
        /*else
         {
         pinView.annotation = annotation;
         }*/
        return pinView;
    }
    
    return nil;
}





- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    MKAnnotationView *aV;
    for (aV in views) {
        
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = aV.frame;
        
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.mapView.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationOptionCurveLinear animations:^{
            
            aV.frame = endFrame;
            
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    [UIView animateWithDuration:0.1 animations:^{
                        aV.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
    
    if(pinDrop){
        
        //[self.mapView selectAnnotation:[[self.mapView annotations]lastObject] animated:YES];
        for (id<MKAnnotation> currentAnnotation in self.mapView.annotations) {
            if ([currentAnnotation isKindOfClass:[ActivityAnnotation class]]) {
                [self.mapView selectAnnotation:currentAnnotation animated:YES];
                //[self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
            }
        }
        
        //[self.mapView selectAnnotation:[[self.mapView annotations]lastObject] animated:YES];
    }
    
}

-(void)getAddressDetailsFromLatLong:(float)latitude lng:(float)longitude{
    
    
#if 1
    // in case of error use api key like
    selectionType=4;
    responseData = [[NSMutableData data] retain];
    NSString*urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",latitude,longitude];
    
    urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
#else
    if ([_geocoder isGeocoding])
        [_geocoder cancelGeocode];
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:latitude
                                                       longitude:longitude];
    
    
    
    
    [_geocoder reverseGeocodeLocation:location
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (!error)
                            [self processReverseGeocoding:placemarks];
                    }];
#endif
    
}



-(UIView*)DrawAMapLeftAccessoryView:(ActivityAnnotation *)locObject{
	
    CGSize  size = [locObject.annotation.formattedAddress sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14]];
    
    CGSize  size2 = [locObject.annotation.category sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:12]];
    
    if(size.width<size2.width){
        size.width=size2.width;
    }
    
    UIView *mapLeftView=[[UIView alloc] initWithFrame:CGRectMake(0,0, size.width, 30)];
    
    switch (locObject.annotation.addType) {
        case 1:
        case 2:
        {
            CGRect categoryLabelRect=CGRectMake(5,18,size.width,12);
            categoryTextLabel=[[UILabel alloc] initWithFrame:categoryLabelRect];
            categoryTextLabel.textAlignment=UITextAlignmentLeft;
            categoryTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
            categoryTextLabel.textColor=[UIColor whiteColor];
            categoryTextLabel.backgroundColor=[UIColor clearColor];
            categoryTextLabel.text=locObject.annotation.category;
            categoryTextLabel.tag=345;
            [mapLeftView addSubview:categoryTextLabel];
            
        }
            break;
            
        default:
            break;
    }
    
    if(size.width>300){
        size.width=300;
    }
	
    CGRect nameLabelRect=CGRectMake(5,0,size.width,16);
	UILabel *nameLabel=[[UILabel alloc] initWithFrame:nameLabelRect];
	nameLabel.textAlignment=UITextAlignmentLeft;
	nameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
	nameLabel.textColor=[UIColor whiteColor];
	nameLabel.backgroundColor=[UIColor clearColor];
	nameLabel.text=locObject.annotation.formattedAddress;
	[mapLeftView addSubview:nameLabel];
	[nameLabel release];
	
	
	
	return mapLeftView;
	
	
}
-(void)getFourSquareVenueDetailsWithRatingUrlPhoneCategory:(NSString*)venue{
    
    
    selectionType=7;
    responseData = [[NSMutableData data] retain];
    NSString*urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT&client_secret=UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR&v=20130117",venue];
    
    urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlstring=%@",urlString);
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

-(void)getFourSquareRating:(PlacemarkClass*)pin{
    
    
    selectionType=6;
    responseData = [[NSMutableData data] retain];
    NSString*urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT&client_secret=UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR&v=20130117",pin.foursquareId];
    
    urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlstring=%@",urlString);
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    
    if(searching){
        
        ActivityAnnotation *loc=view.annotation;
        
        view.image=[UIImage imageNamed:@"S05.1_pinSelected.png"];
        
        //now ask the table to scrollAtThat Row in the table and become highlighted
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        NSLog(@"pointTag=%d",pointTag);
        
        
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        NSLog(@"pointTag=%d",pointTag);
        switch (preSelectionIndex) {
            case 4:
            {
                firstALineddressLabel.text=loc.annotation.formattedAddress;
                secondLineAddressLabel.text=loc.annotation.vicinityAddress;
                
            }
                break;
                
            case 2:
            case 3:
            {
                //reverse geo code
                firstALineddressLabel.text=[NSString stringWithFormat:@"%@, %@",loc.annotation.formattedAddress,loc.annotation.vicinityAddress];
                CLLocationCoordinate2D coordinate=[loc coordinate];
            [self getAddressDetailsFromLatLong:coordinate.latitude lng:coordinate. longitude];
            }
                break;
                
            case 1:
                
            {
                firstALineddressLabel.text=[NSString stringWithFormat:@"%@, %@",loc.annotation.formattedAddress,loc.annotation.vicinityAddress];
                secondLineAddressLabel.hidden=YES;
                
                [self showFourSquareComponents:YES];
                
                if(loc.annotation.formattedPhNo!=nil && [loc.annotation.formattedPhNo class]!=[NSNull null]){
                    phoneLabel.text=loc.annotation.formattedPhNo;
                }
                else{
                    phoneLabel.text=@"Not Available";
                    
                }
                
                ratingLabel.text=@"Rating: N/A";
                
                createActivityButton.hidden=NO;
                
                
            }
                break;
                
            case 5:
            {
                firstALineddressLabel.text=[NSString stringWithFormat:@"%@",loc.annotation.vicinityAddress];
                secondLineAddressLabel.hidden=YES;
                
                [self showFourSquareComponents:YES];
                
                if(loc.annotation.formattedPhNo!=nil && [loc.annotation.formattedPhNo class]!=[NSNull null]&& ![loc.annotation.formattedPhNo isEqualToString:@"Not Available"]){
                    phoneLabel.text=loc.annotation.formattedPhNo;
                    phoneButton.enabled=YES;
                }
                else{
                    phoneLabel.text=@"Not Available";
                    phoneButton.enabled=NO;
                    
                }
                
                //ratingLabel.text=@"Rating: N/A";
                //[self getFourSquareRating:loc.annotation];

                
                ratingLabel.text=loc.annotation.ratingValue;
                createActivityButton.hidden=NO;
                
                
                
                
            }
                break;

                
        }

        locationCrossButton.hidden=NO;
        locationTextLabel.hidden=YES;
       
        backButton.hidden=YES;
        activityInfoButton.hidden=NO;
        
        
    }
    else if(pinDrop){
        ActivityAnnotation *loc=view.annotation;
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        view.image=[UIImage imageNamed:@"S05.1_pinSelected.png"];
        firstALineddressLabel.text=loc.annotation.formattedAddress;
        [secondLineAddressLabel setHidden:YES];
        
        
        locationTextLabel.hidden=YES;
        backButton.hidden=YES;
        locationCrossButton.hidden=NO;
        
    }
    
    
}


-(void)phoneButtonPressed:(id)sender{
    
    PlacemarkClass *loc=[currentLocationArray objectAtIndex:pointTag];
    
    NSString *str = [loc.formattedPhNo stringByReplacingOccurrencesOfString:@"("
                                                                        withString:@""];
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    str= [str stringByReplacingOccurrencesOfString:@" "
                                        withString:@""];
    str= [str stringByReplacingOccurrencesOfString:@")"
                                        withString:@""];
    str= [str stringByReplacingOccurrencesOfString:@"-"
                                        withString:@""];


    
    NSLog(@"URL=%@",[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",str]]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",str]]];

}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    if(searching){
        
        pinDrop=FALSE;
        ActivityAnnotation *loc=view.annotation;
        view.image=[UIImage imageNamed:@"S05.1_pinUnselected.png"];
        
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        [secondLineAddressLabel setHidden:NO];
        [self showFourSquareComponents:NO];
        firstALineddressLabel.text=@"Pick a Location";
        secondLineAddressLabel.text=@"Select a pin above to see it's full address";
        
        createActivityButton.hidden=YES;
        backButton.hidden=NO;
        locationTextLabel.hidden=NO;
        locationCrossButton.hidden=YES;
        activityInfoButton.hidden=YES;
        
        
    }
    else if(pinDrop){
        ActivityAnnotation *loc=view.annotation;
        pointTag=loc.annotTag;
        pointTag=pointTag%777;
        
        pinDrop=FALSE;
        [self showFourSquareComponents:NO];

        [self setUpLabelViewElements:YES];
        createActivityButton.hidden=YES;
        backButton.hidden=NO;
        locationTextLabel.hidden=NO;
        locationCrossButton.hidden=YES;
        activityInfoButton.hidden=YES;
    }
    
}


- (void) didLongPress:(UILongPressGestureRecognizer *)gr {
    
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        
        // convert the touch point to a CLLocationCoordinate & geocode
        CGPoint touchPoint = [gr locationInView:self.mapView];
        CLLocationCoordinate2D coord = [self.mapView convertPoint:touchPoint
                                             toCoordinateFromView:self.mapView];
        [self reverseGeocodeCoordinate:coord];
    }
}

- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coord {
    if ([_geocoder isGeocoding])
        [_geocoder cancelGeocode];
    
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coord.latitude
                                                       longitude:coord.longitude];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    searching=FALSE;
    pinDrop=TRUE;
    
    
    PlacemarkClass *touchPin=[[PlacemarkClass alloc]init];
    touchPin.longitude=coord.longitude;
    touchPin.latitude=coord.latitude;
    touchPin.moreInfoAvailable=NO;
    touchPin.formattedPhNo=@"Not Available";
    touchPin.ratingValue=@"Rating: N/A";
    touchPin.addType=3;
    touchPin.category=nil;
    
    phoneButton.enabled=NO;
    
    ActivityAnnotation *sfAnnotation = [[[ActivityAnnotation alloc] initWithAnnotation:touchPin  tag:7770 pin:YES]autorelease];

    
    
    [self.mapView addAnnotation:sfAnnotation];
    
    
    [_geocoder reverseGeocodeLocation:location
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (!error)
                            [self processReverseGeocodingResults:placemarks];
                    }];
}

- (void) processReverseGeocodingResults:(NSArray *)placemarks {
    
    
    self.addressSearchBar.text=@"";
    [_geocodingResults removeAllObjects];
    //[self.mapView removeAnnotations:self.mapView.annotations];
    searching=FALSE;
    
    if([placemarks count]>0){
        CLPlacemark * placemark1 = [placemarks objectAtIndex:0];
        PlacemarkClass *placemark=[[[PlacemarkClass alloc]init]autorelease];
        placemark.latitude = placemark1.location.coordinate.latitude;
        placemark.longitude = placemark1.location.coordinate.longitude;
        
        placemark.streetNumber=placemark1.subThoroughfare;
        placemark.route=placemark1.thoroughfare;
        placemark.where_zip=placemark1.postalCode;
        placemark.where_city=placemark1.locality;
        placemark.where_state=[SoclivityUtilities getStateAbbreviation:placemark1.administrativeArea];
        
        
        
        NSString *localString=nil;
        if(((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""]))&&((placemark.route==nil) || ([placemark.route isEqualToString:@""]))){
            localString=placemark.formattedAddress =ABCreateStringWithAddressDictionary(placemark1.addressDictionary, NO);
            placemark.addType=0;
        }
        else if((placemark.streetNumber==nil) || ([placemark.streetNumber isEqualToString:@""])){
            localString =[NSString stringWithFormat:@"%@",placemark.route];
            placemark.addType=0;
        }
        else if((placemark.route==nil) || ([placemark.route isEqualToString:@""])){
            localString =[NSString stringWithFormat:@"%@",placemark.streetNumber];
            placemark.addType=0;
        }
        else{
            localString =[NSString stringWithFormat:@"%@ %@",placemark.streetNumber,placemark.route];
            placemark.addType=0;
            
        }
        
        placemark.formattedAddress=[NSString stringWithFormat:@"%@",localString];
        
        if(((placemark.where_state==nil) || ([placemark.where_state isEqualToString:@""]))&&((placemark.where_city==nil) || ([placemark.where_city isEqualToString:@""]))){
            placemark.vicinityAddress=@"";
        }
        else if((placemark.where_state==nil) || ([placemark.where_state isEqualToString:@""])){
            placemark.vicinityAddress =[NSString stringWithFormat:@"%@",placemark.where_city];
        }
        else if((placemark.where_city==nil) || ([placemark.where_city isEqualToString:@""])){
            placemark.vicinityAddress =[NSString stringWithFormat:@"%@",placemark.where_state];
        }
        else{
            placemark.vicinityAddress =[NSString stringWithFormat:@"%@, %@",placemark.where_city,placemark.where_state];
            
        }

        
        placemark.formattedAddress = [placemark.formattedAddress stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        
        
        
        
        
#if 0
        placemark.formattedAddress =ABCreateStringWithAddressDictionary(placemark1.addressDictionary, NO);
        
        NSLog(@"placemark.formattedAddress=%@",placemark.formattedAddress);
        placemark.formattedAddress = [placemark.formattedAddress stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        placemark.formattedAddress = [[placemark.formattedAddress componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        
        if([placemark1.addressDictionary objectForKey:@"City"]==nil||[[placemark1.addressDictionary objectForKey:@"City"] isEqualToString:@""]|| [[placemark1.addressDictionary objectForKey:@"City"] isEqualToString:@"(null)"])
        {
            
        }else{
            NSString *param = nil;
            NSRange start = [placemark.formattedAddress rangeOfString:[placemark1.addressDictionary objectForKey:@"City"]];
            if (start.location != NSNotFound)
            {
                param=[placemark.formattedAddress substringWithRange:NSMakeRange(0, start.location)];
                placemark.formattedAddress=param;
                
                
            }
        }
        NSString * zipAddress=nil;
        
        if(placemark1.postalCode==nil || [placemark1.postalCode isEqualToString:@""]){
            zipAddress=[NSString stringWithFormat:@"%@ %@",[placemark1.addressDictionary objectForKey:@"City"],placemark1.administrativeArea];
            
        }
        else{
            zipAddress=[NSString stringWithFormat:@"%@ %@ %@",[placemark1.addressDictionary objectForKey:@"City"],placemark1.administrativeArea,placemark1.postalCode];
        }
        placemark.vicinityAddress =zipAddress;
        NSArray *stringValues=[placemark.vicinityAddress componentsSeparatedByString:@" "];
        NSMutableArray*mutableArray=[NSMutableArray arrayWithArray:stringValues];
        NSArray *copy = [mutableArray copy];
        NSInteger index = [copy count] - 1;
        for (id object in [copy reverseObjectEnumerator]) {
            if ([mutableArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
                [mutableArray removeObjectAtIndex:index];
            }
            index--;
        }
        [copy release];
        NSMutableString*zipString=[NSMutableString string];
        for(NSString*duplicate in mutableArray){
            
            if(duplicate==nil||[duplicate isEqualToString:@""]|| [duplicate isEqualToString:@"(null)"])
                
                NSLog(@"dont add nil or null values");
            else
                [zipString appendString:duplicate];
        }
        NSLog(@"Zip=%@",zipString);
        placemark.vicinityAddress =zipString;
#endif
        [_geocodingResults addObject:placemark];
    }
    if([_geocodingResults count]>0){
        searching=FALSE;
        
        pinDrop=TRUE;
        locationCrossButton.hidden=NO;
        
        for (id<MKAnnotation> currentAnnotation in self.mapView.annotations) {
            if ([currentAnnotation isKindOfClass:[ActivityAnnotation class]]) {
                NSLog(@"annotation %@", currentAnnotation);
                
                ActivityAnnotation *location = (ActivityAnnotation *) currentAnnotation;
                PlacemarkClass * placemark = [_geocodingResults objectAtIndex:0];
                placemark.addType=3;
                
                placemark.category=nil;
                CLLocationCoordinate2D theCoordinate;
                theCoordinate.latitude = placemark.latitude;
                theCoordinate.longitude =placemark.longitude;
                
                location.annotation.formattedAddress=placemark.formattedAddress;
                location.annotation.vicinityAddress=placemark.vicinityAddress;
                
                [self setUpLabelViewElements:NO];
                if([location.annotation.vicinityAddress length]!=0)
                    firstALineddressLabel.text=[NSString stringWithFormat:@"%@, %@",location.annotation.formattedAddress,location.annotation.vicinityAddress];
                else{
                    firstALineddressLabel.text=[NSString stringWithFormat:@"%@",location.annotation.formattedAddress];
                    
                }
                [secondLineAddressLabel setHidden:YES];
                
                [self showFourSquareComponents:YES];
                
                placemark.formattedPhNo=phoneLabel.text=@"Not Available";
                phoneButton.enabled=NO;
                placemark.ratingValue=ratingLabel.text=@"Rating: N/A";
                
                
                
            }
        }
        activityInfoButton.hidden=NO;
        currentLocationArray =[NSMutableArray arrayWithCapacity:[_geocodingResults count]];
        currentLocationArray=[_geocodingResults retain];
        
        createActivityButton.hidden=NO;
        
    }
    
    
}

-(IBAction)crossClickedByOrganizer:(id)sender{
    
    
  [delegate cancelCreateActivityEventScreen];
    
}

#define kEditStep1Elements 11

-(IBAction)tickClickedByOrganizer:(id)sender{
    
    //update the activity
    
    if([self checkValidations]){
    activityObject.activityName=activityNameTextField.text;
    activityObject.what=descriptionTextView.text;
    if([capacityTextField.text length]!=0)
    activityObject.num_of_people=[capacityTextField.text intValue];
    else{
    activityObject.num_of_people=-1;
    }

    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:1];
        [devServer editActivityEventRequestInvocation:activityObject requestType:kEditStep1Elements delegate:self];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
        
 }
    
}
-(void)EditActivityEventInvocationDidFinish:(EditActivityEventInvocation*)invocation
                               withResponse:(NSString*)responses requestType:(int)requestType withError:(NSError*)error{
    
    
    NSLog(@"responses=%@",responses);
    [HUD hide:YES];
    switch (requestType) {
        case kEditStep1Elements:
        {
            [SOC deltaUpdateSyncCalendar:activityObject];
            
            
            [delegate updateDetailedActivityScreen:activityObject];
            
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)deleteActivtyPressed:(id)sender{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete the Activity"
                                                        message:nil
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
        alert.tag=kDeleteActivity;
        [alert show];
        [alert release];
        return;
    
    
}



@end
