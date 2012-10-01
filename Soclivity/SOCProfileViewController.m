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
#define TAG_COMMENT 1234

@interface SOCProfileViewController ()

@end

@implementation SOCProfileViewController
@synthesize playerObject,commonFriendsArray,imageDownloadsInProgress,loadNFriendsAtTimeArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadNFriendsAtTimeArray=[[NSMutableArray alloc]init];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadProfileImage:)
                                        object:playerObject.profilePhotoUrl];
    [queue addOperation:operation];
    [operation release];
    
    
    
    profileNameLabel.text=[NSString stringWithFormat:@"%@'s Profile",playerObject.playerName];
    
    profileNameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    profileNameLabel.textColor=[UIColor whiteColor];
    profileNameLabel.backgroundColor=[UIColor clearColor];
    profileNameLabel.shadowColor = [UIColor blackColor];
    profileNameLabel.shadowOffset = CGSizeMake(0,-1);

    
    profileUserNameLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    profileUserNameLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    profileUserNameLabel.text=[NSString stringWithFormat:@"%@",playerObject.playerName];
    CGSize  size = [playerObject.playerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15]];
    NSLog(@"width=%f",size.width);
    profileUserNameLabel.frame=CGRectMake(70, 73, size.width, 16);
    
    dosConnectionImageview.frame=CGRectMake(70+6+size.width, 74, 21, 12);
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
    profileTextLinkLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    profileTextLinkLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    
    switch (playerObject.DOS){
        case 1:
            profileTextLinkLabel.text=[NSString stringWithFormat:@"You and %@ are friends",playerObject.playerName];
            break;
            
        case 2:
            profileTextLinkLabel.text=[NSString stringWithFormat:@"You may know %@",playerObject.playerName];
            break;
    }
    
    
    if([SoclivityUtilities deviceType] & iPhone5){
        bottomBarImageView.frame=CGRectMake(0, 508, 320, 40);
    }
    else{
        bottomBarImageView.frame=CGRectMake(0, 420, 320, 40);
    }
    [self.view addSubview:[self SetupHeaderView]];
    
    CGRect activityTableRect;
    if([SoclivityUtilities deviceType] & iPhone5)
        activityTableRect=CGRectMake(0, 220, 320, 200+88);
    
    else
        activityTableRect=CGRectMake(0, 220, 320, 200);
    
    commonFriendsTableView=[[UITableView alloc]initWithFrame:activityTableRect];
    [commonFriendsTableView setDelegate:self];
    [commonFriendsTableView setDataSource:self];
    [commonFriendsTableView setRowHeight:kCustomRowHeight];
    commonFriendsTableView.scrollEnabled=YES;
    commonFriendsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    commonFriendsTableView.sectionHeaderHeight = kSectionHeaderHeight;
    commonFriendsTableView.separatorColor=[UIColor clearColor];
    commonFriendsTableView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:commonFriendsTableView];
    
    
    commonFriendsTableView.clipsToBounds=YES;
    
    [self SetUpDummyCommonFriends];
    
    
    goLoading=TRUE;
    numberOfPhotosWithXling=[commonFriendsArray count];
    [self SetupCountForImagesRefresh:numberOfPhotosWithXling];
    [self ImplementRefreshFunction];




    // Do any additional setup after loading the view from its nib.
}

-(void)SetupCountForImagesRefresh:(NSInteger)photosCount{
	mRemainingRefreshImages=photosCount;
	mCountRefresh=mRemainingRefreshImages;
}

-(void)CreateManualLogicForRefresh{
	if(mRemainingRefreshImages==0)
	{
		mCountRefresh=0;
	}
	if (mRemainingRefreshImages > 0) {
		if (mRemainingRefreshImages <= 5) {
			mCountRefresh =  mRemainingRefreshImages;
			mRemainingRefreshImages = mCountRefresh - mRemainingRefreshImages;
		}
		else {
			if (mRemainingRefreshImages >= 5) {
				mCountRefresh = 5;
			}
			else {
				mCountRefresh = mRemainingRefreshImages;
				mRemainingRefreshImages = 0;
			}
			mRemainingRefreshImages = (mRemainingRefreshImages - mCountRefresh);
		}
        // If the remaining count is <= 3
		
	}
	
}

-(void)ImplementRefreshFunction{
	
	NSLog(@"ImplementRefreshFunction Func Called");
	NSMutableArray *localrefreshArray=[[NSMutableArray alloc]init];
	[self CreateManualLogicForRefresh];
    
	
	int idx=[self GetStaringIndex];
	int loopCounter = mCountRefresh + idx;
	
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
	[refreshSpinnerLoadMore stopAnimating];
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
    UIView *contactHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 130, 320,93)];
    
    UIImageView*patternImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
    patternImage.image=[UIImage imageNamed:@"pattern.png"];
    [contactHeaderView addSubview:patternImage];
    
    CGRect eventLabelRect=CGRectMake(18,7.5,180,12);
    UILabel *eventLabel=[[UILabel alloc] initWithFrame:eventLabelRect];
    eventLabel.textAlignment=UITextAlignmentLeft;
    
    eventLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    eventLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    eventLabel.backgroundColor=[UIColor clearColor];
    eventLabel.text=@"UPCOMING - IN 3 HOURS";
    [contactHeaderView addSubview:eventLabel];
    [eventLabel release];
    
    
    
    CGRect viewAllLabelRect=CGRectMake(258,7.5,50,12);
    UILabel *viewAllLabel=[[UILabel alloc] initWithFrame:viewAllLabelRect];
    viewAllLabel.textAlignment=UITextAlignmentRight;
    viewAllLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    viewAllLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    viewAllLabel.backgroundColor=[UIColor clearColor];
    viewAllLabel.text=@"VIEW ALL";
    [contactHeaderView addSubview:viewAllLabel];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAll:)];
    [viewAllLabel addGestureRecognizer:tapGesture];
    [tapGesture release];
    [viewAllLabel release];


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
            
        default:
        {
            contactGraphicImgView.image=[UIImage imageNamed:@"S04_learn.png"];
            
        }
            break;
    }

    [contactHeaderView addSubview:contactGraphicImgView];
    [contactGraphicImgView release];
    
    
    CGRect latestActivityLabelFrame = CGRectMake(35,40,210,22);
    UILabel *latestActivitytitleLabel = [[UILabel alloc] initWithFrame:latestActivityLabelFrame];
    latestActivitytitleLabel.text = @"Bike Ride With The Boys";
    latestActivitytitleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:20];
    latestActivitytitleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    latestActivitytitleLabel.backgroundColor = [UIColor clearColor];
    [contactHeaderView addSubview:latestActivitytitleLabel];
    [latestActivitytitleLabel release];
    
    CGRect distanceLabelRect=CGRectMake(35,65,143,15);
    UILabel *mileslabel=[[UILabel alloc] initWithFrame:distanceLabelRect];
    mileslabel.textAlignment=UITextAlignmentLeft;
    mileslabel.text=[NSString stringWithFormat:@"1.3 miles away"];
    mileslabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    mileslabel.textColor=[SoclivityUtilities returnTextFontColor:1];
    mileslabel.backgroundColor=[UIColor clearColor];
    [contactHeaderView addSubview:mileslabel];
    [mileslabel release];

    UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    disclosureButton.frame = CGRectMake(296, 51.5, 9, 14);
    [disclosureButton setBackgroundImage:[UIImage imageNamed:@"smallNextArrow.png"] forState:UIControlStateNormal];
    disclosureButton.tag=555;
    [disclosureButton addTarget:self action:@selector(viewDetailActivity:) forControlEvents:UIControlEventTouchUpInside];
    [contactHeaderView addSubview:disclosureButton];
    
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithFrame:CGRectMake(287.0f, 18.0f, 20.0f, 20.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.tag=[[NSString stringWithFormat:@"666"]intValue];
    [activityIndicator setHidden:YES];
    [contactHeaderView addSubview:activityIndicator];
    // release it
    [activityIndicator release];
    
    
    return contactHeaderView;
    
}
-(void)viewDetailActivity:(id)sender{
    
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
        
        NSLog(@"Value=%d",[n intValue]);
        
        [entries addObject:play];
    }
    commonFriendsArray=[[NSArray arrayWithArray:entries]retain];
    
}

-(IBAction)tapViewAll:(UITapGestureRecognizer*)sender{
    
    
    CGPoint translate = [sender locationInView:self.view.superview];
    NSLog(@"Start Point_X=%f,Start Point_Y=%f",translate.x,translate.y);
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
    if(image.size.height > 42 || image.size.width > 42)
        profileImageview.image = [SoclivityUtilities compressImage:image size:CGSizeMake(42,42)];
    
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
        NSLog(@"Product=%@",product.userName);
        NSLog(@"Product_profileImage=%@",product.profileImage);
        cell.profileImage = [product.profileImage retain];
    }
    
    [cell setNeedsDisplay];
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return kCustomRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeaderHeight;
}




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
    
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 19, 11)];
    
    CGRect DOSLabelRect=CGRectMake(38,7.5,240,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
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
        NSLog(@"cell=%@",cell.profileImage);
        
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
    
        if(mSetLoadMoreFooter){
            if (scrollView.contentOffset.y <= footerHeight) {
                [refreshSpinnerLoadMore startAnimating];
                
                
                [self ImplementRefreshFunction];
                
                
            commonFriendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 3*REFRESH_HEADER_HEIGHT/2, 0);//see the logic
                mSetLoadMoreFooter=FALSE;
            }
            
        }
        
        else if(mSetLoadNoMorePhotosFooter){
            commonFriendsTableView.contentInset = UIEdgeInsetsMake(0, 0, 3*REFRESH_HEADER_HEIGHT/2, 0);//see the logic
            
        }
        
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self loadImagesForOnscreenRows];
    
        if (numberOfPhotosWithXling>[loadNFriendsAtTimeArray count]) {
            
            NSArray *visiblePaths = [commonFriendsTableView indexPathsForVisibleRows];
            
            for (NSIndexPath *indexPath in visiblePaths) {
                
                if ((indexPath.row +2)>[loadNFriendsAtTimeArray count]) {
                    
                    if(goLoading){
                        
                        goLoading=FALSE;
                        mSetLoadMoreFooter=TRUE;
                        footerHeight=[self tableViewHeight];
                        [self addLoadingMoreFooter:footerHeight];
                        
                    }
                }
                
            }
			//	 [mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else {
            [self stopLoadingMore];
            footerHeight=[self tableViewHeight];
            mSetLoadNoMorePhotosFooter=TRUE;
            [self addLoadingMoreFooter:footerHeight];
        }
		
    
    
}

-(void)addLoadingMoreFooter:(NSInteger)loadMoreFooterHeight{
	
	UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0,1, 320, 1)];
	v1.backgroundColor = [UIColor grayColor];
	v1.tag=TAG_COMMENT;
	
    loadMoreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, loadMoreFooterHeight, 320, REFRESH_HEADER_HEIGHT)];
    loadMoreFooterView.backgroundColor = [UIColor whiteColor];
	loadMoreFooterView.tag=TAG_COMMENT;
    loadMorePhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, REFRESH_HEADER_HEIGHT)];
    
    loadMorePhotosLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    loadMorePhotosLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    loadMorePhotosLabel.textAlignment = UITextAlignmentCenter;
	[loadMoreFooterView addSubview:v1];
    
	if(mSetLoadMoreFooter)
        loadMorePhotosLabel.text=[NSString stringWithFormat:@"Loading more friends..."];
    
	if(mSetLoadNoMorePhotosFooter)
        loadMorePhotosLabel.text=@"No More Friends";
	
	if(mSetLoadMoreFooter){
		
        
        
		
        
        refreshSpinnerLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinnerLoadMore.frame = CGRectMake(10+(REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
        refreshSpinnerLoadMore.hidesWhenStopped = YES;
        [loadMoreFooterView addSubview:refreshSpinnerLoadMore];
    }
	[loadMoreFooterView addSubview:loadMorePhotosLabel];
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
