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
@implementation ActivityInvitesView
@synthesize searchBarForInvites,InviteEntriesArray,filteredListContent,delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        searching=FALSE;
        filteredListContent=[NSMutableArray new];
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
        
        
        
        inviteUserTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320,332)];
        [inviteUserTableView setDelegate:self];
        [inviteUserTableView setDataSource:self];
        [inviteUserTableView setRowHeight:kCustomRowHeight];
        inviteUserTableView.scrollEnabled=YES;
        inviteUserTableView.tableHeaderView=[self SetupHeaderView];
        inviteUserTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        inviteUserTableView.sectionHeaderHeight = kSectionHeaderHeight;
        inviteUserTableView.separatorColor=[UIColor clearColor];
        inviteUserTableView.showsVerticalScrollIndicator=YES;
        [self addSubview:inviteUserTableView];
        [self SetUpDummyInvites];


        
    }
    return self;
}

-(UIView*)SetupHeaderView{
    UIView *contactHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,55)];
    
    
    UIImageView *contactGraphicImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 32, 36)];
    contactGraphicImgView.image=[UIImage imageNamed:@"S05.4_addressBook.png"];
    [contactHeaderView addSubview:contactGraphicImgView];
    [contactGraphicImgView release];
    
    CGRect conatactsLabelRect=CGRectMake(50,17.5,140,12);
    UILabel *contactsLabel=[[UILabel alloc] initWithFrame:conatactsLabelRect];
    contactsLabel.textAlignment=UITextAlignmentLeft;
    
    contactsLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
    contactsLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    contactsLabel.backgroundColor=[UIColor clearColor];
    contactsLabel.text=@"Contacts";
    [contactHeaderView addSubview:contactsLabel];
    [contactsLabel release];
    
    
    CGRect invitePeopleTextLabelRect=CGRectMake(50,32.5,200,12);
    UILabel *inviteLabel=[[UILabel alloc] initWithFrame:invitePeopleTextLabelRect];
    inviteLabel.textAlignment=UITextAlignmentLeft;
    
    inviteLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    inviteLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    inviteLabel.backgroundColor=[UIColor clearColor];
    inviteLabel.text=@"Invite people from your address book";
    [contactHeaderView addSubview:inviteLabel];
    [inviteLabel release];
    
    UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    disclosureButton.frame = CGRectMake(296, 21.5, 9, 14);
    [disclosureButton setBackgroundImage:[UIImage imageNamed:@"smallNextArrow.png"] forState:UIControlStateNormal];
    [disclosureButton addTarget:self action:@selector(inviteUsersFromAddressBook:) forControlEvents:UIControlEventTouchUpInside];
    [contactHeaderView addSubview:disclosureButton];
    
    return contactHeaderView;

}
- (void) dealloc
{
    [super dealloc];
}


-(void)inviteUsersFromAddressBook:(id)sender{
    
    [delegate pushContactsInvitesScreen:sender];
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
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:play.profilePhotoUrl]];
        UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];
        if(image.size.height != image.size.width)
            play.profileImage = [SoclivityUtilities autoCrop:image];
        
        // If the image needs to be compressed
        if(image.size.height > 56 || image.size.width > 56)
            play.profileImage = [SoclivityUtilities compressImage:image size:CGSizeMake(56,56)];
    
        NSNumber * status = [playDictionary objectForKey:@"status"];
        play.status=[status boolValue];
        
        NSLog(@"Value=%d",[n intValue]);
        
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
    cell.cellIndexPath=indexPath;
    cell.userInviteProduct=product;
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


-(void)inviteStatusUpdate:(NSIndexPath*)indexPath{
    
    
    InviteObjectClass*product=nil;
    if(searching){
        product =[self.filteredListContent objectAtIndex:indexPath.row];
        
    }
    else {
        product = [[[[self.InviteEntriesArray objectAtIndex:indexPath.section] objectForKey:@"Elements"]
                    objectAtIndex:indexPath.row]objectForKey:@"ActivityInvite"];
        }
      product.status=!product.status;
                
   [inviteUserTableView reloadData];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	
	   [self.filteredListContent removeAllObjects]; // First clear the filtered array.
    
        NSMutableArray *content = [NSMutableArray new];
        for (NSDictionary *dict in self.InviteEntriesArray)
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
        [inviteUserTableView reloadData];
        
    
    
    
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
    
    
    if([self.searchBarForInvites.text isEqualToString:@""]){
        
        [searchBar setShowsCancelButton:NO animated:YES];
        self.searchBarForInvites.showClearButton=NO;
        searching=NO;
        inviteUserTableView.tableHeaderView=[self SetupHeaderView];
        [inviteUserTableView reloadData];
 
    }
    else{
        [searchBar setShowsCancelButton:NO animated:NO];
        self.searchBarForInvites.showClearButton=YES;
        searching=YES;
        inviteUserTableView.tableHeaderView=nil;
        [self filterContentForSearchText:searchBar.text];

        
    }
    

    [searchBar setShowsCancelButton:YES animated:NO];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    self.searchBarForInvites.text=@"";
    searching=NO;
    inviteUserTableView.tableHeaderView=[self SetupHeaderView];
    [inviteUserTableView reloadData];

    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self.searchBarForInvites resignFirstResponder];
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    searching=YES;
    inviteUserTableView.tableHeaderView=nil;
    [self filterContentForSearchText:searchBar.text];
    [self.searchBarForInvites resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
-(void)customCancelButtonHit{
    
    
    searching=NO;
    inviteUserTableView.tableHeaderView=[self SetupHeaderView];
    [inviteUserTableView reloadData];
    self.searchBarForInvites.text=@"";
    self.searchBarForInvites.showClearButton=NO;
    [searchBarForInvites setShowsCancelButton:NO animated:YES];
    [self.searchBarForInvites resignFirstResponder];
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end