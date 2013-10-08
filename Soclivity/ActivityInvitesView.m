//
//  ActivityInvitesView.m
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityInvitesView.h"
#import "InviteObjectClass.h"
#import "SoclivityUtilities.h"
#import "InvitesViewController.h"
#import "MainServiceManager.h"
#import "MBProgressHUD.h"
#define kAddressBookContacts 123

NSString * const kSearchTextKey = @"Search Text";

@interface ActivityInvitesView ()<GetUsersByFirstLastNameInvocationDelegate>
- (void)startIconDownload:(InviteObjectClass*)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ActivityInvitesView
@synthesize searchBarForInvites,InviteEntriesArray,filteredListContent,delegate,imageDownloadsInProgress,statusUpdate;
- (id)initWithFrame:(CGRect)frame andInviteListArray:(NSArray*)andInviteListArray isActivityUserList:(BOOL)isActivityUserList
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        slotBuffer=isActivityUserList;
        [self setBackgroundColor:[UIColor whiteColor]];
        devServer=[[MainServiceManager alloc]init];
        InviteEntriesArray =[andInviteListArray retain];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        searching=FALSE;
        filteredListContent=[NSMutableArray new];
        
        
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
            
            
                UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0, 320, 44)];
                searchBar.delegate=self;
                [searchBar setShowsCancelButton:NO animated:YES];
                searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
                [searchBar setTintColor:[SoclivityUtilities returnTextFontColor:5]];
                [searchBar setBarTintColor:[SoclivityUtilities returnBackgroundColor:6]];
                searchBar.placeholder=@"Search for people on Soclivity";
                [self addSubview:searchBar];
                
        }
        else{
        self.searchBarForInvites = [[[CustomSearchbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)] autorelease];
        self.searchBarForInvites.delegate = self;
        self.searchBarForInvites.CSDelegate=self;
        if(self.searchBarForInvites.text!=nil){
            self.searchBarForInvites.showsCancelButton = YES;
        }
        
        self.searchBarForInvites.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBarForInvites.placeholder=@"Search for people on Soclivity";
        self.searchBarForInvites.backgroundImage=[UIImage imageNamed: @"S4.1_search-background.png"];
        [self addSubview:self.searchBarForInvites];
    }
        
        
        
        CGRect activityTableRect;
        if([SoclivityUtilities deviceType] & iPhone5)
            activityTableRect=CGRectMake(0, 44, 320, 332+88);
        
        else
            activityTableRect=CGRectMake(0, 44, 320, 332);

        
        inviteUserTableView=[[UITableView alloc]initWithFrame:activityTableRect];
        [inviteUserTableView setDelegate:self];
        [inviteUserTableView setDataSource:self];
        [inviteUserTableView setRowHeight:kCustomRowHeight];
        inviteUserTableView.scrollEnabled=YES;
        //inviteUserTableView.tableHeaderView=[self SetupHeaderView];
        inviteUserTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        inviteUserTableView.sectionHeaderHeight = kSectionHeaderHeight;
        inviteUserTableView.separatorColor=[UIColor clearColor];
        inviteUserTableView.showsVerticalScrollIndicator=YES;
        [self addSubview:inviteUserTableView];
        
        
        inviteUserTableView.clipsToBounds=YES;
        
        
        // Sign-in button
        

        
        
        searchSoclivityUsersButton=[UIButton buttonWithType:UIButtonTypeCustom];
        searchSoclivityUsersButton.frame=CGRectMake(28,250, 263, 38);
        [searchSoclivityUsersButton addTarget:self action:@selector(searchGlobalNetwork:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchSoclivityUsersButton];
        [searchSoclivityUsersButton setHidden:YES];
        
        searchingLabel=[[UILabel alloc]initWithFrame:CGRectMake(87,253, 230, 35)];
        searchingLabel.text=@"Search across all Soclivity users...";
        searchingLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:17.0];
        
        searchingLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        searchingLabel.backgroundColor=[UIColor clearColor];
        searchingLabel.shadowColor = [UIColor whiteColor];
        searchingLabel.shadowOffset = CGSizeMake(0,0.5);
        
        [self addSubview:searchingLabel];
        [searchingLabel setHidden:YES];
        
        spinner=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(252,261, 20, 20)];
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [spinner hidesWhenStopped];
        [self addSubview:spinner];
        [spinner setHidden:YES];


        //[self SetUpDummyInvites];


        
    }
    return self;
}

-(void)searchGlobalNetwork:(id)sender{
    
    [searchBarForInvites resignFirstResponder];
    searchingLabel.text=@"Searching....";
    spinner.frame=CGRectMake(240, delta+75+4, 20, 20);
    [spinner setHidden:NO];
    [spinner startAnimating];
    [self setUserInteractionEnabled:NO];
    
    [self searchSoclivityNetwork:searchBarForInvites.text];
}

-(UIView*)SetupHeaderView{
    UIView *contactHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,55)];
    
    
    UIImageView *contactGraphicImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 32, 36)];
    contactGraphicImgView.image=[UIImage imageNamed:@"S05.4_addressBook.png"];
    [contactHeaderView addSubview:contactGraphicImgView];
    [contactGraphicImgView release];
    
    CGRect conatactsLabelRect=CGRectMake(50,17.5,140,12);
    UILabel *contactsLabel=[[UILabel alloc] initWithFrame:conatactsLabelRect];
    contactsLabel.textAlignment=NSTextAlignmentLeft;
    
    contactsLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
    contactsLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    contactsLabel.backgroundColor=[UIColor clearColor];
    contactsLabel.text=@"Contacts";
    [contactHeaderView addSubview:contactsLabel];
    [contactsLabel release];
    
    
    CGRect invitePeopleTextLabelRect=CGRectMake(50,32.5,200,12);
    UILabel *inviteLabel=[[UILabel alloc] initWithFrame:invitePeopleTextLabelRect];
    inviteLabel.textAlignment=NSTextAlignmentLeft;
    
    inviteLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    inviteLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    inviteLabel.backgroundColor=[UIColor clearColor];
    inviteLabel.text=@"Invite people from your address book";
    [contactHeaderView addSubview:inviteLabel];
    [inviteLabel release];
    
    UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    disclosureButton.frame = CGRectMake(296, 21.5, 9, 14);
    [disclosureButton setBackgroundImage:[UIImage imageNamed:@"smallNextArrow.png"] forState:UIControlStateNormal];
    disclosureButton.tag=555;
    [disclosureButton addTarget:self action:@selector(inviteUsersFromAddressBook:) forControlEvents:UIControlEventTouchUpInside];
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
- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[alertView resignFirstResponder];
    
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kAddressBookContacts:
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"TRUE" forKey:@"AddressBookConfirm"];

                [self UserConfirmationReceived];
            }
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
    
}


-(void)closeAnimation{
    
    [(UIButton*)[self viewWithTag:555] setHidden:NO];
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self viewWithTag:666];
    [tmpimg stopAnimating];
    [tmpimg setHidden:YES];

}
-(void)inviteUsersFromAddressBook:(id)sender{
    
    NSString *confirmationDialog=[[NSUserDefaults standardUserDefaults] valueForKey:@"AddressBookConfirm"];
    
    if([confirmationDialog isEqualToString:@"TRUE"]){
        [self UserConfirmationReceived];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Confirm"
                                                        message:@"Do you want to invite people from your address book"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
        
        alert.tag=kAddressBookContacts;
        [alert show];
        [alert release];
        
        
    }

}

-(void)UserConfirmationReceived{
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [(UIButton*)[self viewWithTag:555] setHidden:YES];
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self viewWithTag:666];
    [tmpimg setHidden:NO];
    [tmpimg startAnimating];

    
    
    [delegate pushContactsInvitesScreen];
 
    
    
}

-(void) SetUpDummyInvites{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Invites" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *content = [NSMutableArray new];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        
        NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
        NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
        NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
        
        bool insertNewElement = TRUE;

        
        InviteObjectClass *play = [[InviteObjectClass alloc] init];
        play.userName = [playDictionary objectForKey:@"userName"];
        NSNumber * n = [playDictionary objectForKey:@"typeOfRelation"];
        play.typeOfRelation= [n intValue];
        NSNumber * DOS = [playDictionary objectForKey:@"DOS"];
        play.DOS= [DOS intValue];
        play.profilePhotoUrl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[playDictionary objectForKey:@"profilePhotoUrl"]];
        NSNumber * status = [playDictionary objectForKey:@"status"];
        play.status=[status boolValue];
        
        switch (play.typeOfRelation) {
            case 0:
            {
                [row setValue:[NSNumber numberWithInt:0] forKey:@"relation"];
            }
                break;
            case 1:
            {
                [row setValue:[NSNumber numberWithInt:1] forKey:@"relation"];
                
            }
                break;

            case 2:
            {
                [row setValue:[NSNumber numberWithInt:2] forKey:@"relation"];
                
            }
                break;
                
        }
        
        
        for(NSDictionary *dict in content) {
            NSNumber *headerKey = [dict objectForKey:@"relation"];
            if ([headerKey intValue]==play.typeOfRelation) {
                NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
                [elements setValue:play forKey:@"ActivityInvite"];
                [oldEntries addObject:elements];
                insertNewElement = FALSE;
                break;
            }
            else {
                insertNewElement = TRUE;
            }
        }
        
        
        if (insertNewElement) {
            [elements setValue:play forKey:@"ActivityInvite"];
            [entries addObject:elements];
            [row setValue:entries forKey:@"Elements"];
            [content addObject:row];
        }



        
        
}
        InviteEntriesArray=content;
        [inviteUserTableView reloadData];

}

#pragma mark -
#pragma  mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if (searching)
	{
        return 1;
    }
	else
	{
        return [self.InviteEntriesArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
    int count=0;
	if (searching)
	{
        
        count=[self.filteredListContent count];
        NSLog(@"Count=%d",count);
        return count ;
        
    }
	else
	{
        count=[[[self.InviteEntriesArray objectAtIndex:section] objectForKey:@"Elements"] count];
        NSLog(@"Count=%d",count);
        return count;

    }
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
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	InviteObjectClass *product = nil;
    int count=0;
    if(searching){
        
          product = [self.filteredListContent objectAtIndex:indexPath.row];
          count=[self.filteredListContent count];

    }
	else
	{
        product = [[[[self.InviteEntriesArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]
                    objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
        count=[[[self.InviteEntriesArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]count];
    }
	
    if(indexPath.row==count-1){
        cell.noSeperatorLine=TRUE;
    }
    else{
        cell.noSeperatorLine=FALSE;
    }
    cell.delegate=self;
    cell.inviteStatus=product.status;
    cell.userName=product.userName;
    cell.DOS=product.DOS;
    cell.cellIndexPath=indexPath;
    cell.typeOfRelation=product.typeOfRelation;
    
    if(searching){
        
    if(slotBuffer && !product.isOnFacebook && (product.DOS==1 || product.DOS==2)){
    cell.typeOfRelation=7;
    }
    else if((product.DOS==1 || product.DOS==2)&& !product.isOnFacebook){
    cell.typeOfRelation=8;
    }
        
    }
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!product.profileImage)
    {
        if (inviteUserTableView.dragging == NO && inviteUserTableView.decelerating == NO)
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeaderHeight;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSNumber *sectionInfo;
    if(searching){
        
    //sectionInfo =[[self.filteredListContent objectAtIndex:section] objectForKey:@"relation"];
        sectionInfo=[NSNumber numberWithInt:-1];
    }
    else {
        
    sectionInfo = [[self.InviteEntriesArray objectAtIndex:section] objectForKey:@"relation"];
        
    }
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,kSectionHeaderHeight)]autorelease];
    sectionHeaderview.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    
    //second section don't draw the first line
    UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
    [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]]];
    topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
    [sectionHeaderview addSubview:topDividerLineButton];

     UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 19, 11)];
    
    CGRect DOSLabelRect=CGRectMake(38,7.5,240,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=NSTextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];

    
    switch ([sectionInfo intValue]) {
            
    case -1:
        {
            [DOSImageView setHidden:YES];
            DOScountLabel.frame=CGRectMake(12, 7.5, 240, 12);
            DOScountLabel.text=[NSString stringWithFormat:@"SEARCH RESULTS"];
            
        }
            break;

        case 0:
        {
            [DOSImageView setHidden:YES];
            DOScountLabel.frame=CGRectMake(12, 7.5, 240, 12);
            DOScountLabel.text=[NSString stringWithFormat:@"RECENTLY DONE STUFF WITH"];

        }
            break;
           
        case 1:
        case 5:
        {
            DOSImageView.image=[UIImage imageNamed:@"dos1.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"FRIENDS ON SOCLIVITY"];
            
        }
            break;
   
        case 2:
        {
            DOSImageView.image=[UIImage imageNamed:@"dos1.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"INVITE FRIENDS TO SOCLIVITY"];
            
        }
            break;
            
            
        case 6:
        {
            DOSImageView.frame=CGRectMake(12, 7.5, 16, 11);
            DOSImageView.image=[UIImage imageNamed:@"S03_mail.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"INVITE FRIENDS TO SOCLIVITY"];
            
        }
            break;

            

    }
    
    
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];
    
    
    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,kSectionHeaderHeight-1,320,1)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]];
    [sectionHeaderview addSubview:bottomDividerLineview];
    
    return sectionHeaderview;
    
}

-(void)pushToUserProfileView:(NSIndexPath*)indexPath rType:(NSInteger)rType{
    
    
    InviteObjectClass*product=nil;
    if(searching){
        product =[self.filteredListContent objectAtIndex:indexPath.row];
        
    }
    else {
        product = [[[[self.InviteEntriesArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]
                    objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
    }

    switch (rType) {
        case 0:
        case 1:
        case 5:
        case 7:
        case 8:
        {
            [delegate PushUserToProfileScreen:product];
        }
            break;
            
        default:
        {
            return;
        }
            break;
    }
}


-(void)inviteStatusUpdate:(NSIndexPath*)indexPath relationType:(NSInteger)relationType{
    
    
    
    InviteObjectClass*product=nil;
    if(searching){
        product =[self.filteredListContent objectAtIndex:indexPath.row];
        
    }
    else {
        product = [[[[self.InviteEntriesArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]
                    objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
        }

    
    if(product.status){
        return;
    }
    
    if(slotBuffer){
    
    if(![delegate CalculateOpenSlots]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry No Slots Open" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
        
    }

    statusUpdate=[product retain];
    switch (relationType) {
        case 0:
        case 1:
        case 7:
        {
            [delegate inviteSoclivityUser:product.inviteId];
        }
            break;
            

        case 2:
        {
            //facebook invite Pending
            [delegate sendInviteOnFacebookPrivateMessage:product.inviteId];
            
        }
            break;
            
        case 6:
        {
            //facebook invite Pending
            [delegate askUserToJoinSoclivityOnFacebook:product.inviteId];
            
        }
            break;


    }
    
}

-(void)activityInviteStatusUpdate{
    
    statusUpdate.status=!statusUpdate.status;
     [inviteUserTableView reloadData];

}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText{
	
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	   [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
        NSMutableArray *content = [NSMutableArray new];
        for (NSDictionary *dict in self.InviteEntriesArray)
        {
            NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
            
            for(NSDictionary *dict2 in oldEntries){
                
                InviteObjectClass*product = [dict2 objectForKey:@"ActivityInvite"];
                NSRange titleResultsRange = [product.userName rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                
                if (titleResultsRange.length > 0){
                    
                    [content addObject:product];
                    
                }
            }
        }
        [self.filteredListContent addObjectsFromArray:content];
        CGRect activityTableRect;
    delta=0.0f;
    if([self.filteredListContent count]>=4){
        

        if([SoclivityUtilities deviceType] & iPhone5){
            activityTableRect=CGRectMake(0, 44, 320, 227+88);
                    delta=227+88;
        }
        
        else{
            activityTableRect=CGRectMake(0, 44, 320, 227);
                    delta=227;
        }



      }
    else{

        if([SoclivityUtilities deviceType] & iPhone5){
            delta=[self.filteredListContent count]*50+27;
            activityTableRect=CGRectMake(0, 44, 320, [self.filteredListContent count]*50+27+88);
        }
        
        else{
            delta=[self.filteredListContent count]*50+27;
            activityTableRect=CGRectMake(0, 44, 320, [self.filteredListContent count]*50+27);
        }

    }
    
        searchingLabel.text=@"Search across all Soclivity users...";
        searchSoclivityUsersButton.frame=CGRectMake(29,delta+75, 263.0f, 38.0f);
        searchSoclivityUsersButton.hidden=NO;
        searchingLabel.frame=CGRectMake(29,delta+75, 263.0f, 25.0f);
        searchingLabel.hidden=NO;
    
        inviteUserTableView.frame=activityTableRect;
        [inviteUserTableView reloadData];
        
    
    
    
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
    
    
    int count=0;
    if(searching){
        count=[self.filteredListContent count];
    }
    else{
        count=[self.InviteEntriesArray count];
    }
    if (count> 0)
    {
        NSArray *visiblePaths = [inviteUserTableView indexPathsForVisibleRows];
        
        if(searching){
        for (NSIndexPath *indexPath in visiblePaths)
        {
            InviteObjectClass *appRecord = (InviteObjectClass*)[self.filteredListContent objectAtIndex:indexPath.row];
            
            if (!appRecord.profileImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
        else{
            for (NSIndexPath *indexPath in visiblePaths)
            {
                InviteObjectClass *appRecord = (InviteObjectClass *)[[[[self.InviteEntriesArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
                
                
                if (!appRecord.profileImage) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                }
            }
        }
 }
    
    
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        InviteUserTableViewCell *cell = (InviteUserTableViewCell*)[inviteUserTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.profileImage = [iconDownloader.inviteRecord.profileImage retain];

    }
    
    [inviteUserTableView reloadData];
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark UISearchBarDelegate


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    
    if([searchBar.text isEqualToString:@""]){
        
        [searchBar setShowsCancelButton:NO animated:YES];
        searching=NO;
        [self refreshTableView];
       // inviteUserTableView.tableHeaderView=[self SetupHeaderView];
        [inviteUserTableView reloadData];
 
    }
    else{
        [searchBar setShowsCancelButton:NO animated:NO];
       
        searching=YES;
        //inviteUserTableView.tableHeaderView=nil;
        [self filterContentForSearchText:searchBar.text];

        
    }
    
     }else{
         
         if([self.searchBarForInvites.text isEqualToString:@""]){
             
             [searchBar setShowsCancelButton:NO animated:YES];
             self.searchBarForInvites.showClearButton=NO;
             searching=NO;
             [self refreshTableView];
             // inviteUserTableView.tableHeaderView=[self SetupHeaderView];
             [inviteUserTableView reloadData];
             
         }
         else{
             [searchBar setShowsCancelButton:NO animated:NO];
             self.searchBarForInvites.showClearButton=YES;
             searching=YES;
             //inviteUserTableView.tableHeaderView=nil;
             [self filterContentForSearchText:searchBar.text];
             
             
         }
         
     }
    [searchBar setShowsCancelButton:YES animated:NO];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    searchBar.text=@"";
    self.searchBarForInvites.text=@"";
    searching=NO;
    //inviteUserTableView.tableHeaderView=[self SetupHeaderView];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        
        [self refreshTableView];
    }
    //inviteUserTableView.tableHeaderView=[self SetupHeaderView];
     [inviteUserTableView reloadData];

    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self.searchBarForInvites resignFirstResponder];
    [searchBar resignFirstResponder];
    
    
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searching=YES;
    inviteUserTableView.tableHeaderView=nil;
    

    [self filterContentForSearchText:searchBar.text];
    
   // load from soclivity Database
    

    
/*
    if ([_searchTimer isValid])
        [_searchTimer invalidate];
    
    const NSTimeInterval kSearchDelay = .25;
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:searchBar.text
                                                          forKey:kSearchTextKey];
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:kSearchDelay
                                                    target:self
                                                  selector:@selector(searchFromSoclivityDatabase:)
                                                  userInfo:userInfo
                                                   repeats:NO];

    */
    [self.searchBarForInvites resignFirstResponder];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
        for (UIView *possibleButton in [[searchBar.subviews objectAtIndex:0]subviews])
        {
            if ([possibleButton isKindOfClass:[UIButton class]])
            {
                UIButton *cancelButton = (UIButton*)possibleButton;
                cancelButton.enabled = YES;
                break;
            }
        }
    }
    
}

-(void)searchSoclivityNetwork:(NSString*)text{
    
    [delegate searchSoclivityPlayers:text];

}
- (void) searchFromSoclivityDatabase:(NSTimer *)timer {
    
   // NSString * searchString = [timer.userInfo objectForKey:kSearchTextKey];
    
    //[devServer searchUsersByNameInvocation:23 searchText:searchString delegate:self];
    // Cancel any active geocoding. Note: Cancelling calls the completion handler on the geocoder
}

-(void)SearchUsersInvocationDidFinish:(GetUsersByFirstLastNameInvocation*)invocation
                         withResponse:(NSArray*)responses type:(NSInteger)type
                            withError:(NSError*)error{
	
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
    NSMutableArray *content = [NSMutableArray new];
    for (NSDictionary *dict in responses)
    {
        NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
        NSLog(@"oldEntries count=%d",[oldEntries count]);
        
        for(NSDictionary *dict2 in oldEntries){
            
            InviteObjectClass*product = [dict2 objectForKey:@"ActivityInvite"];
            NSLog(@"product Name=%@",product.userName);
            
            
                [content addObject:product];
                
            }
    }
    [self.filteredListContent addObjectsFromArray:content];
    [inviteUserTableView reloadData];
    
    
    
    
}

-(void)searchPlayersLoad:(NSArray*)players{
    
    
    if([players count]!=0){
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
    NSMutableArray *content = [NSMutableArray new];
    for (NSDictionary *dict in players)
    {
        NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
        NSLog(@"oldEntries count=%d",[oldEntries count]);
        
        for(NSDictionary *dict2 in oldEntries){
            
            InviteObjectClass*product = [dict2 objectForKey:@"ActivityInvite"];
            NSLog(@"product Name=%@",product.userName);
            
            
            [content addObject:product];
            
        }
    }
    [self.filteredListContent addObjectsFromArray:content];
 }
    [self refreshTableView];
    [inviteUserTableView reloadData];

}

-(void)refreshTableView{
    
        
    CGRect activityTableRect;
    if([SoclivityUtilities deviceType] & iPhone5)
        activityTableRect=CGRectMake(0, 44, 320, 332+88);
    
    else
        activityTableRect=CGRectMake(0, 44, 320, 332);
    
    
    
    [spinner setHidden:YES];
    [spinner stopAnimating];
    [self setUserInteractionEnabled:YES];

    searchSoclivityUsersButton.hidden=YES;
    searchingLabel.hidden=YES;
    
    inviteUserTableView.frame=activityTableRect;
   
}

-(void)customCancelButtonHit{
    
    [self refreshTableView];
    searching=NO;
    //inviteUserTableView.tableHeaderView=[self SetupHeaderView];
    [inviteUserTableView reloadData];
    self.searchBarForInvites.text=@"";
    self.searchBarForInvites.showClearButton=NO;
    [searchBarForInvites setShowsCancelButton:NO animated:YES];
    [self.searchBarForInvites resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch =[touches anyObject];
    CGPoint startPoint =[touch locationInView:self];
        CGRect tapClearSearchRect =CGRectMake(260, 7, 57, 30);
        
        if(CGRectContainsPoint(tapClearSearchRect,startPoint)){
            
            if((searchBarForInvites.text==(NSString*)[NSNull null])||([searchBarForInvites.text isEqualToString:@""]||searchBarForInvites.text==nil)||([searchBarForInvites.text isEqualToString:@"(null)"])){
            }
            else{
                [self customCancelButtonHit];
            }
        }
        
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
