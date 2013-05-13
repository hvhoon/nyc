//
//  SOCProfileViewController.m
//  Soclivity
//
//  Created by Kanav on 10/1/12.
//
//

#import "SOCProfileViewController.h"
#import "SocPlayerClass.h"
#import "SoclivityUtilities.h"
#import "InviteObjectClass.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "DetailedActivityInfoInvocation.h"
#import "ActivityEventViewController.h"
#import "UpComingCompletedEventsViewController.h"
#import "GetUserProfileInfoInvocation.h"
#import "MBProgressHUD.h"
#import "NotificationClass.h"
#define TAG_COMMENT 1234

@interface SOCProfileViewController ()<DetailedActivityInfoInvocationDelegate,GetUserProfileInfoInvocationDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@end

@implementation SOCProfileViewController
@synthesize playerObject,imageDownloadsInProgress,loadNFriendsAtTimeArray,friendId,commonFriendsArray,notIdObject;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBackgroundNotification:) name:@"RemoteNotificationReceivedWhileRunning" object:Nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatInAppNotification:) name:@"ChatNotification" object:Nil];
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoteNotificationReceivedWhileRunning" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChatNotification" object:nil];
    
}


-(void)didReceiveBackgroundNotification:(NSNotification*)object{
    
    NotificationClass *notifObject=[SoclivityUtilities getNotificationObject:object];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
}

-(void)chatInAppNotification:(NSNotification*)note{
    NotificationClass *notifObject=[SoclivityUtilities getNotificationChatPost:note];
    NotifyAnimationView *notif=[[NotifyAnimationView alloc]initWithFrame:CGRectMake(0, 0, 320, 60) andNotif:notifObject];
    notif.delegate=self;
    [self.view addSubview:notif];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([SoclivityUtilities deviceType] & iPhone5){
        bottomBarImageView.frame=CGRectMake(0, 508, 320, 40);
    }
    else{
        bottomBarImageView.frame=CGRectMake(0, 420, 320, 40);
    }

    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    
    [self getUserProfile];
    


}
-(void)getUserProfile{
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation:1];
        [devServer getUserProfileInfoInvocation:[SOC.loggedInUser.idSoc intValue] friendPlayer:friendId delegate:self];
        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }
    
}

-(void)startAnimation:(int)tag{
    
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    switch (tag) {
        case 1:
        {
            HUD.labelText = @"Loading...";
            
        }
            break;
            
            
            
            
        default:
            break;
    }
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)hideMBProgress{
    [HUD hide:YES];
}

-(void)backgroundTapToPush:(NotificationClass*)notification{
    
    NSLog(@"Activity Selected");
    
    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    notIdObject=[notification retain];
    GetPlayersClass *obj=SOC.loggedInUser;
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        isInAppNotif=TRUE;
        [devServer getDetailedActivityInfoInvocation:[obj.idSoc intValue]  actId:notification.activityId  latitude:[notification.latitude floatValue] longitude:[notification.longitude floatValue] delegate:self];
        
    }
    else{
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
}

-(void)UserProfileInfoInvocationDidFinish:(GetUserProfileInfoInvocation*)invocation
                             withResponse:(SocPlayerClass*)response
                                withError:(NSError*)error{
    
    [self hideMBProgress];
    playerObject=[response retain];
           commonFriendsArray=[[NSArray arrayWithArray:playerObject.commonFriends]retain];
    loadNFriendsAtTimeArray=[[NSMutableArray alloc]init];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadProfileImage:)
                                        object:playerObject.profilePhotoUrl];
    [queue addOperation:operation];
    [operation release];
    
    
    
    
    NSArray *listItems = [playerObject.playerName componentsSeparatedByString:@" "];
    
    NSString *firstName=nil;
    if(([listItems count]==2)||([listItems count]==1)){
        firstName=[listItems objectAtIndex:0];
    }
    
    profileNameLabel.text=[NSString stringWithFormat:@"%@'s Profile",firstName];
    
    profileNameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    profileNameLabel.textColor=[UIColor whiteColor];
    profileNameLabel.backgroundColor=[UIColor clearColor];
    
    profileUserNameLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    profileUserNameLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    profileUserNameLabel.text=[NSString stringWithFormat:@"%@",playerObject.playerName];
    CGSize  size = [playerObject.playerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15]];
    NSLog(@"width=%f",size.width);
    profileUserNameLabel.frame=CGRectMake(75, 73, size.width, 16);
    
    if(playerObject.DOS!=3){
        
        dosConnectionImageview.frame=CGRectMake(75+6+size.width, 74, 21, 12);
        switch (playerObject.DOS){
            case 1:
                dosConnectionImageview.image=[UIImage imageNamed:@"S05_dos1.png"];
                break;
                
            case 2:
                dosConnectionImageview.image=[UIImage imageNamed:@"S05_dos2.png"];
                break;
                
                
            default:
                break;
        }
        
        // Determing the user's relationship to the organizer
        profileTextLinkLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
        profileTextLinkLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        
        switch (playerObject.DOS){
            case 1:
                profileTextLinkLabel.text=[NSString stringWithFormat:@"You and %@ are friends",firstName];
                break;
                
            case 2:
                profileTextLinkLabel.text=[NSString stringWithFormat:@"You may know %@",firstName];
                break;
        }
        
        
        if(playerObject.DOS==1)
            [self.view addSubview:[self SetupHeaderView]];
        int delta=0;
        if(playerObject.DOS!=1){
            [self.view addSubview:[self commonFriendsView:127]];
             delta=93;
        }
        
        CGRect activityTableRect;
        if([SoclivityUtilities deviceType] & iPhone5)
            
            activityTableRect=CGRectMake(0, 220-delta+kSectionHeaderHeight, 320, 200+88+delta-kSectionHeaderHeight);
        
        else
            activityTableRect=CGRectMake(0, 220-delta+kSectionHeaderHeight, 320, 200+delta-kSectionHeaderHeight);
        
        commonFriendsTableView=[[UITableView alloc]initWithFrame:activityTableRect];
        [commonFriendsTableView setDelegate:self];
        [commonFriendsTableView setDataSource:self];
        [commonFriendsTableView setRowHeight:kCustomRowHeight];
        commonFriendsTableView.scrollEnabled=YES;
        //commonFriendsTableView.tableHeaderView=[self returnSectionHeader];
        commonFriendsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        commonFriendsTableView.separatorColor=[UIColor clearColor];
        commonFriendsTableView.showsVerticalScrollIndicator=YES;
        [self.view addSubview:commonFriendsTableView];
        
        
        commonFriendsTableView.clipsToBounds=YES;
        

        
        //[self SetUpDummyCommonFriends];
        
        
        goLoading=TRUE;
        numberOfFriendsWithPlayer=[commonFriendsArray count];
        [self SetupCountForImagesRefresh:numberOfFriendsWithPlayer];
        [self ImplementRefreshFunction];
        
        
    }
    // The user and you have no friends in common.  Do not show upcoming/completed activities or common friends
    else{
        profileUserNameLabel.frame=CGRectMake(75, 92, size.width, 16);
        
        CGRect topLabelRect=CGRectMake(60,140,280,15);
        UILabel *topLabel=[[UILabel alloc] initWithFrame:topLabelRect];
        topLabel.textAlignment=UITextAlignmentLeft;
        
        topLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        topLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        topLabel.backgroundColor=[UIColor clearColor];
        topLabel.text=@"You can only view the profile of a";
        [self.view addSubview:topLabel];
        [topLabel release];
        
        
        
        CGRect bottomLabelRect=CGRectMake(75,160,280,15);
        UILabel *bottomLabel=[[UILabel alloc] initWithFrame:bottomLabelRect];
        bottomLabel.textAlignment=UITextAlignmentLeft;
        
        bottomLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        bottomLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        bottomLabel.backgroundColor=[UIColor clearColor];
        bottomLabel.text=@"friend or a friend of a friend";
        [self.view addSubview:bottomLabel];
        [bottomLabel release];
        
    }
    
    

}

-(UIView*)returnSectionHeader{
    
    
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,kSectionHeaderHeight)]autorelease];
    sectionHeaderview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    //second section don't draw the first line
    
    
    UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
    [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]]];
    topDividerLineButton.tag=7770;
    [sectionHeaderview addSubview:topDividerLineButton];
    
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 19, 11)];
    
    CGRect DOSLabelRect=CGRectMake(38,7.5,240,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    DOSImageView.image=[UIImage imageNamed:@"dos1.png"];
    DOScountLabel.text=[NSString stringWithFormat:@"IN COMMON"];
    
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];
    
    
    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,kSectionHeaderHeight-1,320,1)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]];
    [sectionHeaderview addSubview:bottomDividerLineview];
    
    return sectionHeaderview;
    
}

-(void)SetupCountForImagesRefresh:(NSInteger)photosCount{
	mRemainingFriendsCount=photosCount;
	mCountFriends=mRemainingFriendsCount;
}

-(void)CreateManualLogicForRefresh{
	if(mRemainingFriendsCount==0)
	{
		mCountFriends=0;
	}
	if (mRemainingFriendsCount > 0) {
		if (mRemainingFriendsCount <= 5) {
			mCountFriends =  mRemainingFriendsCount;
			mRemainingFriendsCount = mCountFriends - mRemainingFriendsCount;
		}
		else {
			if (mRemainingFriendsCount >= 5) {
				mCountFriends = 5;
			}
			else {
				mCountFriends = mRemainingFriendsCount;
				mRemainingFriendsCount = 0;
			}
			mRemainingFriendsCount = (mRemainingFriendsCount - mCountFriends);
		}
        // If the remaining count is <= 3
		
	}
	
}

-(void)ImplementRefreshFunction{
	
	NSLog(@"ImplementRefreshFunction Func Called");
	NSMutableArray *localrefreshArray=[[NSMutableArray alloc]init];
	[self CreateManualLogicForRefresh];
    
	
	int idx=[self GetStaringIndex];
	int loopCounter = mCountFriends + idx;
	
	for(; idx < loopCounter; idx++){
		
        
        InviteObjectClass *obj=[commonFriendsArray objectAtIndex:idx];
        NSLog(@"Refresh idx=%d,obj=%@",idx,obj);
        
		[localrefreshArray addObject:obj];
	}
    [self setStartingIndex:idx];
    
    
    [loadNFriendsAtTimeArray addObjectsFromArray:localrefreshArray];
	
	
	
    if(!goLoading)
		[self stopLoadingMore];
    
    [commonFriendsTableView reloadData];
    
	goLoading=TRUE;

	
	
	
}

-(void)stopLoadingMore{
	[friendSpinnerLoadMore stopAnimating];
	for(UIView *subview in [commonFriendsTableView subviews])
	{
		if([subview isKindOfClass:[UIView class]] && [subview viewWithTag:TAG_COMMENT]) {
			[subview removeFromSuperview];
		}
    }
    
}


-(void)setStartingIndex:(NSInteger)value{
	currentCountIndex=value;
}
-(NSInteger)GetStaringIndex{
	return currentCountIndex;
}



-(UIView*)SetupHeaderView{
    UIView *contactHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 127, 320,93+kSectionHeaderHeight)];
    
    UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
    [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]]];
    [contactHeaderView addSubview:topDividerLineButton];

    
    UIImageView*patternImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 25)];
    patternImage.image=[UIImage imageNamed:@"pattern.png"];
    [contactHeaderView addSubview:patternImage];
    
    CGRect eventLabelRect=CGRectMake(12,7.5,180,12);
    UILabel *eventLabel=[[UILabel alloc] initWithFrame:eventLabelRect];
    eventLabel.textAlignment=UITextAlignmentLeft;
    
    eventLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    eventLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    eventLabel.backgroundColor=[UIColor clearColor];
    if([SoclivityUtilities ValidActivityDate:playerObject.activityTime])
        eventLabel.text=[NSString stringWithFormat:@"NEXT - %@",[SoclivityUtilities upcomingTimeOfActivity:playerObject.activityTime]];
    else{
        eventLabel.text=[NSString stringWithFormat:@"LAST SEEN - %@",[SoclivityUtilities upcomingTimeOfActivity:playerObject.activityTime]];
    }
    [contactHeaderView addSubview:eventLabel];
    [eventLabel release];
    
    
    
    UIButton *viewAllButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    viewAllButton.frame = CGRectMake(258,7.5,50,12);
    [viewAllButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [viewAllButton setTitle:@"VIEW ALL" forState:UIControlStateNormal];
    [viewAllButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];
    viewAllButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    viewAllButton.backgroundColor=[UIColor clearColor];
    [viewAllButton addTarget:self action:@selector(tapViewAll:) forControlEvents:UIControlEventTouchUpInside];
    [contactHeaderView addSubview:viewAllButton];
    
    
    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,26,320,1)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]];
    [contactHeaderView addSubview:bottomDividerLineview];


    
    UIImageView *contactGraphicImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 27, 25, 66)];
    switch (playerObject.activityType) {
        case 1:
        {
            contactGraphicImgView.image=[UIImage imageNamed:@"S04_play.png"];
        }
            break;
        case 2:
        {
            contactGraphicImgView.image=[UIImage imageNamed:@"S04_eat.png"];
            
        }
            break;
        case 3:
        {
            contactGraphicImgView.image=[UIImage imageNamed:@"S04_see.png"];
            
        }
            break;
        case 4:
        {
            contactGraphicImgView.image=[UIImage imageNamed:@"S04_create.png"];
            
        }
            break;
        case 5:
        {
            contactGraphicImgView.image=[UIImage imageNamed:@"S04_learn.png"];
            
        }
            break;
            
    }

    [contactHeaderView addSubview:contactGraphicImgView];
    [contactGraphicImgView release];
    
    
    CGRect latestActivityLabelFrame = CGRectMake(35,40,210,22);
    UILabel *latestActivitytitleLabel = [[UILabel alloc] initWithFrame:latestActivityLabelFrame];
    latestActivitytitleLabel.text = playerObject.latestActivityName;
    latestActivitytitleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:20];
    latestActivitytitleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    latestActivitytitleLabel.backgroundColor = [UIColor clearColor];
    [contactHeaderView addSubview:latestActivitytitleLabel];
    [latestActivitytitleLabel release];
    
    CGRect distanceLabelRect=CGRectMake(35,65,143,15);
    UILabel *mileslabel=[[UILabel alloc] initWithFrame:distanceLabelRect];
    mileslabel.textAlignment=UITextAlignmentLeft;
    mileslabel.text=[NSString stringWithFormat:@"%.02f miles away",playerObject.distance];
    mileslabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    mileslabel.textColor=[SoclivityUtilities returnTextFontColor:1];
    mileslabel.backgroundColor=[UIColor clearColor];
    [contactHeaderView addSubview:mileslabel];
    [mileslabel release];

    if([SoclivityUtilities ValidActivityDate:playerObject.activityTime]){
    UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    disclosureButton.frame = CGRectMake(296, 51.5, 9, 14);
    [disclosureButton setBackgroundImage:[UIImage imageNamed:@"smallNextArrow.png"] forState:UIControlStateNormal];
    disclosureButton.tag=555;
    [disclosureButton addTarget:self action:@selector(viewDetailActivity:) forControlEvents:UIControlEventTouchUpInside];
    [contactHeaderView addSubview:disclosureButton];
    }
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithFrame:CGRectMake(290.0f, 47.0f, 20.0f, 20.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.tag=[[NSString stringWithFormat:@"666"]intValue];
    [activityIndicator setHidden:YES];
    [contactHeaderView addSubview:activityIndicator];
    // release it
    [activityIndicator release];
        
        
        
    [contactHeaderView addSubview:[self commonFriendsView:93]];

    
    
    return contactHeaderView;
    
}

-(UIView*)commonFriendsView:(int)height{
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,height,320,kSectionHeaderHeight)]autorelease];
    sectionHeaderview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    //second section don't draw the first line
    
    
    UIButton *topDividerLineButton2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    topDividerLineButton2.frame = CGRectMake(0, 0, 320, 1);
    [topDividerLineButton2 setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]]];
    [sectionHeaderview addSubview:topDividerLineButton2];
    
    // Added the DOS image
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 19, 11)];
    DOSImageView.image=[UIImage imageNamed:@"dos1.png"];
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    
    // Add the count of common friends
    CGRect commonFriendLabelRect=CGRectMake(38,7.5,19,12);
    UILabel *commonCountLabel=[[UILabel alloc] initWithFrame:commonFriendLabelRect];
    commonCountLabel.textAlignment=UITextAlignmentLeft;
    
    commonCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    commonCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    commonCountLabel.backgroundColor=[UIColor clearColor];
    commonCountLabel.text=[NSString stringWithFormat:@"%d",[commonFriendsArray count]];
    commonCountLabel.tag=567;
    CGSize textSize = [[commonCountLabel text] sizeWithFont:[commonCountLabel font]];
    CGFloat strikeWidth = textSize.width;
    commonCountLabel.frame=CGRectMake(38, 7.5, strikeWidth, 12);
    
    [sectionHeaderview addSubview:commonCountLabel];
    [commonCountLabel release];
    
    // Add the common friends text
    CGRect DOSLabelRect=CGRectMake(strikeWidth+38,7.5,240,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    DOScountLabel.text=[NSString stringWithFormat:@" FRIENDS IN COMMON"];
    
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];
    
    
    UIView *bottomDividerLineview2=[[[UIView alloc]initWithFrame:CGRectMake(0,kSectionHeaderHeight-1,320,1)]autorelease];
    bottomDividerLineview2.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]];
    [sectionHeaderview addSubview:bottomDividerLineview2];
    
    return sectionHeaderview;
    

}
-(void)viewDetailActivity:(id)sender{
    
    

    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        
        isInAppNotif=FALSE;
        [(UIButton*)[self.view viewWithTag:555] setHidden:YES];
        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:666];
        [tmpimg startAnimating];
        [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:playerObject.activityId  latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude delegate:self];
    }
    else{
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }

}

#pragma mark -
#pragma mark DetailedActivityInfoInvocationDelegate Method

-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)responses
                                     withError:(NSError*)error{
    
    
    if(!isInAppNotif){
    NSString*nibNameBundle=nil;
    
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"ActivityEventViewController_iphone5";
    }
    else{
        nibNameBundle=@"ActivityEventViewController";
    }
    
    ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    
    activityEventViewController.activityInfo=responses;
    [[self navigationController] pushViewController:activityEventViewController animated:YES];
    [activityEventViewController release];
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    
    [(UIButton*)[self.view viewWithTag:555] setHidden:NO];
    
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:666];
    [tmpimg stopAnimating];
    [tmpimg setHidden:YES];

    }
    else{
        
        
        
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        
        
        
        switch ([notIdObject.notificationType integerValue]) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 11:
            case 17:
            default:
                
                
            {
                NSString*nibNameBundle=nil;
                
                if([SoclivityUtilities deviceType] & iPhone5){
                    nibNameBundle=@"ActivityEventViewController_iphone5";
                }
                else{
                    nibNameBundle=@"ActivityEventViewController";
                }
                
                ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];
                activityEventViewController.activityInfo=responses;
                if([notIdObject.notificationType integerValue]==17){
                    activityEventViewController.footerActivated=YES;
                }
                [[self navigationController] pushViewController:activityEventViewController animated:YES];
                [activityEventViewController release];
                
            }
                break;
                
                
            case 7:
            case 8:
            case 9:
            case 10:
            case 13:
            case 16:
                
            {
                SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
                socProfileViewController.friendId=notIdObject.referredId;
                [[self navigationController] pushViewController:socProfileViewController animated:YES];
                [socProfileViewController release];
                
            }
                
                break;
        }
        
        
    }
    
}


-(void) SetUpDummyCommonFriends{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Friends" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        InviteObjectClass *play = [[InviteObjectClass alloc] init];
        play.userName = [playDictionary objectForKey:@"userName"];
        NSNumber * n = [playDictionary objectForKey:@"typeOfRelation"];
        play.typeOfRelation= [n intValue];
        NSNumber * DOS = [playDictionary objectForKey:@"DOS"];
        play.DOS= [DOS intValue];
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[playDictionary objectForKey:@"profilePhotoUrl"]];
        
        
        [entries addObject:play];
    }
    //commonFriendsArray=[[NSArray arrayWithArray:entries]retain];
    
}

-(void)tapViewAll:(id)sender{
    
    
    NSString*nibNameBundle=nil;
    
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
    }
    else{
        nibNameBundle=@"UpComingCompletedEventsViewController";
    }
    
    UpComingCompletedEventsViewController *upComingCompletedEventsViewController=[[UpComingCompletedEventsViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    upComingCompletedEventsViewController.isNotSettings=TRUE;
    upComingCompletedEventsViewController.isNotLoggedInUser=TRUE;
    upComingCompletedEventsViewController.player2Id=friendId;
    NSArray *listItems = [playerObject.playerName componentsSeparatedByString:@" "];
    
    NSString *firstName=nil;
    if(([listItems count]==2)||([listItems count]==1)){
        firstName=[listItems objectAtIndex:0];
    }
    

    upComingCompletedEventsViewController.playersName=firstName;
    [[self navigationController] pushViewController:upComingCompletedEventsViewController animated:YES];
    [upComingCompletedEventsViewController release];

}

-(void)pushToUserProfileView:(NSIndexPath*)indexPath rType:(NSInteger)rType{
 
    
    InviteObjectClass*player = [self.loadNFriendsAtTimeArray objectAtIndex:indexPath.row];
    if(!player.isOnFacebook){
    
    SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
    socProfileViewController.friendId=player.inviteId;
    [[self navigationController] pushViewController:socProfileViewController animated:YES];
    [socProfileViewController release];

    }
}


#pragma mark -
#pragma mark Profile Picture Functions
// Profile picture loading functions
- (void)loadProfileImage:(NSString*)url {
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
    [imageData release];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}
- (void)displayImage:(UIImage *)image {
    
    
    if(image.size.height != image.size.width)
        image = [SoclivityUtilities autoCrop:image];
    
    // If the image needs to be compressed
    if(image.size.height > 50 || image.size.width > 50)
        profileImageview.image = [SoclivityUtilities compressImage:image size:CGSizeMake(50,50)];
    
    // Make circle
    profileImageview.layer.cornerRadius = profileImageview.image.size.width/2;
    profileImageview.layer.masksToBounds = YES;
    
    [profileImageview setImage:image]; //UIImageView
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)profileBackButtonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma  mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        int count=[self.loadNFriendsAtTimeArray count];
        NSLog(@"Count=%d",count);
        return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MediaTableCell";
    
    InviteUserTableViewCell *cell =  (InviteUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[InviteUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
        InviteObjectClass*product = [self.loadNFriendsAtTimeArray objectAtIndex:indexPath.row];
        int count=[self.loadNFriendsAtTimeArray count];
        
    
	
    if(indexPath.row==count-1){
        cell.noSeperatorLine=TRUE;
    }
    else{
        cell.noSeperatorLine=FALSE;
    }
    cell.delegate=self;
    cell.userName=product.userName;
    cell.DOS=product.DOS;
    cell.cellIndexPath=indexPath;
    cell.typeOfRelation=product.typeOfRelation;
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!product.profileImage)
    {
        if (commonFriendsTableView.dragging == NO && commonFriendsTableView.decelerating == NO)
        {
           [self startIconDownload:product forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.profileImage = [UIImage imageNamed:@"picbox.png"];
        
    }
    else
    {
        cell.profileImage = [product.profileImage retain];
    }
    
    [cell setNeedsDisplay];
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return kCustomRowHeight;
}

#if 1

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}



#if 0
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,kSectionHeaderHeight)]autorelease];
    sectionHeaderview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    //second section don't draw the first line
    
    NSLog(@"section =%d",section);
    
    UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
    [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]]];
    topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
    [sectionHeaderview addSubview:topDividerLineButton];
    
    // Added the DOS image
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 19, 11)];
    DOSImageView.image=[UIImage imageNamed:@"dos1.png"];
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    
    // Add the count of common friends
    CGRect commonFriendLabelRect=CGRectMake(38,7.5,19,12);
    UILabel *commonCountLabel=[[UILabel alloc] initWithFrame:commonFriendLabelRect];
    commonCountLabel.textAlignment=UITextAlignmentLeft;
    
    commonCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    commonCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    commonCountLabel.backgroundColor=[UIColor clearColor];
    commonCountLabel.text=[NSString stringWithFormat:@"%d",[commonFriendsArray count]];
    
    CGSize textSize = [[commonCountLabel text] sizeWithFont:[commonCountLabel font]];
    CGFloat strikeWidth = textSize.width;
    commonCountLabel.frame=CGRectMake(38, 7.5, strikeWidth, 12);
    
    [sectionHeaderview addSubview:commonCountLabel];
    [commonCountLabel release];

    // Add the common friends text
    CGRect DOSLabelRect=CGRectMake(strikeWidth+38,7.5,240,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    DOScountLabel.text=[NSString stringWithFormat:@" FRIENDS IN COMMON"];

    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];
    
    
    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,kSectionHeaderHeight-1,320,1)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]];
    [sectionHeaderview addSubview:bottomDividerLineview];
    
    return sectionHeaderview;
    
}
#else
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
       return [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
}
#endif

#endif
#pragma mark -
#pragma mark Lazy Loading

- (void)startIconDownload:(InviteObjectClass*)appRecord forIndexPath:(NSIndexPath *)indexPath{
 IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.inviteRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload:kInviteUsers];
        [iconDownloader release];
    }
}
- (void)loadImagesForOnscreenRows{
    if ([self.loadNFriendsAtTimeArray count] > 0)
    {
        NSArray *visiblePaths = [commonFriendsTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            InviteObjectClass *appRecord = (InviteObjectClass *)[self.loadNFriendsAtTimeArray objectAtIndex:indexPath.row];
            
            
            if (!appRecord.profileImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
    
    
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        InviteUserTableViewCell *cell = (InviteUserTableViewCell*)[commonFriendsTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.profileImage = [iconDownloader.inviteRecord.profileImage retain];
        
    }
    
    [commonFriendsTableView reloadData];
}

#define REFRESH_HEADER_HEIGHT 52.0f

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
#if 0
        if(mSetLoadMoreFooter){
            if (scrollView.contentOffset.y <= footerHeight) {
                [friendSpinnerLoadMore startAnimating];
                
                
                [self ImplementRefreshFunction];
                
                
            commonFriendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 3*REFRESH_HEADER_HEIGHT/2, 0);//see the logic
                mSetLoadMoreFooter=FALSE;
            }
            
        }
        
        else if(mSetLoadNoMoreFriendsFooter){
            commonFriendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 3*REFRESH_HEADER_HEIGHT/2, 0);//see the logic
            
        }
#endif
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self loadImagesForOnscreenRows];
    
        if (numberOfFriendsWithPlayer>[loadNFriendsAtTimeArray count]) {
            
            NSArray *visiblePaths = [commonFriendsTableView indexPathsForVisibleRows];
            
            for (NSIndexPath *indexPath in visiblePaths) {
                
                if ((indexPath.row +2)>[loadNFriendsAtTimeArray count]) {
                    
                    if(goLoading){
                        
                        goLoading=FALSE;
                        mSetLoadMoreFooter=TRUE;
                        footerHeight=[self tableViewHeight];
                        [self addLoadingMoreFooter:footerHeight];
                        commonFriendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 3*REFRESH_HEADER_HEIGHT/2, 0);//see the logic
                        
                        [self performSelector:@selector(ImplementRefreshFunction) withObject:nil afterDelay:1.5];
                        //[self ImplementRefreshFunction];

                        
                    }
                }
                
            }
			//	 [mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else {
            [self stopLoadingMore];
            footerHeight=[self tableViewHeight];
            mSetLoadNoMoreFriendsFooter=TRUE;
            [self addLoadingMoreFooter:footerHeight];
            [friendSpinnerLoadMore stopAnimating];
        }
		
    
    
}

-(void)addLoadingMoreFooter:(NSInteger)loadMoreFooterHeight{
	
	
    loadMoreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, loadMoreFooterHeight, 320, REFRESH_HEADER_HEIGHT)];
    loadMoreFooterView.backgroundColor = [UIColor whiteColor];
	loadMoreFooterView.tag=TAG_COMMENT;
    loadMoreFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 180, 16)];
    
    loadMoreFriendsLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    loadMoreFriendsLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    loadMoreFriendsLabel.textAlignment = UITextAlignmentLeft;
    
	if(mSetLoadMoreFooter){
        loadMoreFriendsLabel.text=[NSString stringWithFormat:@"Loading..."];
        friendSpinnerLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        friendSpinnerLoadMore.frame = CGRectMake(30, 25, 25, 25);
        [friendSpinnerLoadMore startAnimating];
        [loadMoreFooterView addSubview:friendSpinnerLoadMore];
    }
    
	if(mSetLoadNoMoreFriendsFooter)
        loadMoreFriendsLabel.text=@"No More Common Friends";
	
	[loadMoreFooterView addSubview:loadMoreFriendsLabel];
    [commonFriendsTableView addSubview:loadMoreFooterView];
	
    //if(mSetLoadMoreFooter)
    //	self.mTableView.contentInset = UIEdgeInsetsMake(loadMoreFooterHeight+REFRESH_HEADER_HEIGHT, 0, 0, 0);
}


- (NSInteger)tableViewHeight
{
	[commonFriendsTableView layoutIfNeeded];
	NSInteger tableheight;
	tableheight=[commonFriendsTableView contentSize].height;
	return tableheight;
}


@end
