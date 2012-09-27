//
//  ContactsListViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactsListViewController.h"
#import "SoclivityUtilities.h"
#import "InviteObjectClass.h"
#import "UserContactList.h"
@interface ContactsListViewController ()

- (void)startIconDownload:(InviteObjectClass*)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ContactsListViewController
@synthesize activityBackButton,inviteTitleLabel,openSlotsNoLabel,activityName,num_of_slots,searchBarForContacts,filteredListContent,contactsListContentArray,delegate,inviteFriends,imageDownloadsInProgress;

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
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    if(inviteFriends){
    inviteTitleLabel.text=[NSString stringWithFormat:@"%@",activityName];
    
    inviteTitleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    inviteTitleLabel.textColor=[UIColor whiteColor];
    inviteTitleLabel.backgroundColor=[UIColor clearColor];
    inviteTitleLabel.shadowColor = [UIColor blackColor];
    inviteTitleLabel.shadowOffset = CGSizeMake(0,-1);
    
    
    
    openSlotsNoLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    openSlotsNoLabel.textColor=[UIColor whiteColor];
    openSlotsNoLabel.backgroundColor=[UIColor clearColor];
    openSlotsNoLabel.shadowColor = [UIColor blackColor];
    openSlotsNoLabel.shadowOffset = CGSizeMake(0,-1);
    openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];
    }
    
    searching=FALSE;
    filteredListContent=[NSMutableArray new];
    self.searchBarForContacts = [[[CustomSearchbar alloc] initWithFrame:CGRectMake(0,44, 320, 44)] autorelease];
    self.searchBarForContacts.delegate = self;
    self.searchBarForContacts.CSDelegate=self;
    if(self.searchBarForContacts.text!=nil){
        self.searchBarForContacts.showsCancelButton = YES;
    }
    
    self.searchBarForContacts.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBarForContacts.placeholder=@"Search contacts";
    self.searchBarForContacts.backgroundImage=[UIImage imageNamed:@"S4.1_search-background.png"];
    [self.view addSubview:self.searchBarForContacts];
    
    
    
    [contactListTableView setRowHeight:kCustomRowHeight];
    contactListTableView.scrollEnabled=YES;
    contactListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    contactListTableView.sectionHeaderHeight = kSectionHeaderHeight;
    contactListTableView.separatorColor=[UIColor clearColor];
    contactListTableView.showsVerticalScrollIndicator=YES;
    contactListTableView.clipsToBounds=YES;
    
    //UserContactList *addressBook=[[UserContactList alloc]init];
    //self.contactsListContentArray=[addressBook GetAddressBook];
    
    self.contactsListContentArray=[self setUpDummyContactList];
    
    [contactListTableView reloadData];
    


    // Do any additional setup after loading the view from its nib.
}


-(NSArray*)setUpDummyContactList{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ContactList" withExtension:@"plist"];
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
#if 0
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:play.profilePhotoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            play.profileImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            play.profileImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
#endif
        NSNumber * status = [playDictionary objectForKey:@"status"];
        play.status=[status boolValue];
        
        NSLog(@"Value=%d",[n intValue]);
        
        switch (play.typeOfRelation) {
            case 3:
            {
                [row setValue:[NSNumber numberWithInt:3] forKey:@"relation"];
            }
                break;
            case 4:
            {
                [row setValue:[NSNumber numberWithInt:4] forKey:@"relation"];
                
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
     return content;
}

-(IBAction)popBackToActivityInviteScreen:(id)sender{
    
        [self.navigationController popViewControllerAnimated:YES];
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
        return [self.contactsListContentArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count=0;
	if (searching)
	{
        
        count=[self.filteredListContent count];
        NSLog(@"Count=%d",count);
        return count ;
        
    }
	else
	{
        count=[[[self.contactsListContentArray objectAtIndex:section] objectForKey:@"Elements"] count];
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
        product = [[[[self.contactsListContentArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]
                    objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
        count=[[[self.contactsListContentArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]count];
        
    }
	
    if(indexPath.row==count-1){
        cell.noSeperatorLine=TRUE;
    }
    else{
        cell.noSeperatorLine=FALSE;
    }
    cell.delegate=self;
    cell.cellIndexPath=indexPath;
    cell.inviteStatus=product.status;
    cell.userName=product.userName;
    cell.DOS=product.DOS;
    cell.typeOfRelation=product.typeOfRelation;
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!product.profileImage)
    {
        if (contactListTableView.dragging == NO && contactListTableView.decelerating == NO)
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
        
        sectionInfo=[NSNumber numberWithInt:-1];
    }
    else {
        
        sectionInfo = [[self.contactsListContentArray objectAtIndex:section] objectForKey:@"relation"];
        
    }
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,kSectionHeaderHeight)]autorelease];
    sectionHeaderview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    //second section don't draw the first line
    
    NSLog(@"section =%d",section);
    
    UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
    [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]]];
    topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
    [sectionHeaderview addSubview:topDividerLineButton];
    
    
    CGRect DOSLabelRect=CGRectMake(12,7.5,240,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    
    
    switch ([sectionInfo intValue]) {
            
        case -1:
        {
            DOScountLabel.text=[NSString stringWithFormat:@"SEARCH RESULTS"];
            
        }
            break;
            
        case 3:
        {
                DOScountLabel.text=[NSString stringWithFormat:@"CONTACTS ON SOCLIVITY"];
            
        }
            break;
            
        case 4:
        {
            DOScountLabel.text=[NSString stringWithFormat:@"INVITE CONTACTS TO SOCLIVITY"];
            
        }
            break;
            
            
            
    }
    
    
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];
    
    
    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,kSectionHeaderHeight-1,320,1)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_sectionLine.png"]];
    [sectionHeaderview addSubview:bottomDividerLineview];
    
    return sectionHeaderview;
    
}	


-(void)inviteStatusUpdate:(NSIndexPath*)indexPath{
    
    
    InviteObjectClass*product=nil;
    if(searching){
        product =[self.filteredListContent objectAtIndex:indexPath.row];
        
    }
    else {
        product = [[[[self.contactsListContentArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]
                    objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
    }
    product.status=!product.status;
    
    
    if(inviteFriends){

    if(product.status){
        num_of_slots++;
        [delegate OpenSlotsUpdate:YES];
    }
    else{
         num_of_slots--;
        [delegate OpenSlotsUpdate:NO];
    }

     openSlotsNoLabel.text=[NSString stringWithFormat:@"%d Open Slots",num_of_slots];
    }
    
    [contactListTableView reloadData];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
    NSMutableArray *content = [NSMutableArray new];
    for (NSDictionary *dict in self.contactsListContentArray)
    {
        NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
        NSLog(@"oldEntries count=%d",[oldEntries count]);
        
        for(NSDictionary *dict2 in oldEntries){
            
            InviteObjectClass*product = [dict2 objectForKey:@"ActivityInvite"];
            NSLog(@"product Name=%@",product.userName);                
            NSRange titleResultsRange = [product.userName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            
            if (titleResultsRange.length > 0){
                NSLog(@"product NaSelecetdme=%@",product.userName); 
                [content addObject:product];
                
            }
        }
    }
    [self.filteredListContent addObjectsFromArray:content];
    [contactListTableView reloadData];
    
    
    
    
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
        count=[self.contactsListContentArray count];
    }
    if (count> 0)
    
    {
        NSArray *visiblePaths = [contactListTableView indexPathsForVisibleRows];
        
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
                InviteObjectClass *appRecord = (InviteObjectClass *)[[[[self.contactsListContentArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
                
                
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
        InviteUserTableViewCell *cell = (InviteUserTableViewCell*)[contactListTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.profileImage = [iconDownloader.inviteRecord.profileImage retain];
    }
    
    [contactListTableView reloadData];
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
    NSLog(@"searchBarTextDidEndEditing=%@",searchBar.text);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if([self.searchBarForContacts.text isEqualToString:@""]){
        
        [searchBar setShowsCancelButton:NO animated:YES];
        self.searchBarForContacts.showClearButton=NO;
        searching=NO;
        [contactListTableView reloadData];
        
    }
    else{
        [searchBar setShowsCancelButton:NO animated:NO];
        self.searchBarForContacts.showClearButton=YES;
        searching=YES;
        [self filterContentForSearchText:searchBar.text];
        
        
    }
    
    
    [searchBar setShowsCancelButton:YES animated:NO];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
     self.searchBarForContacts.text=@"";
     searching=NO;
    [contactListTableView reloadData];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self.searchBarForContacts resignFirstResponder];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searching=YES;
    [self filterContentForSearchText:searchBar.text];
    [self.searchBarForContacts resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
-(void)customCancelButtonHit{
    
    searching=NO;
    [contactListTableView reloadData];
    self.searchBarForContacts.text=@"";
    self.searchBarForContacts.showClearButton=NO;
    [searchBarForContacts setShowsCancelButton:NO animated:YES];
    [self.searchBarForContacts resignFirstResponder];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
