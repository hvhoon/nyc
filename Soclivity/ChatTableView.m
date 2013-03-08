//
//  ChatTableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "ChatTableView.h"
#import "UIBubbleHeaderFooterTableViewCell.h"
#import "ActivityChatData.h"

@implementation ChatTableView
@synthesize bubbleDataSource = _bubbleDataSource;
@synthesize snapInterval = _snapInterval;
@synthesize bubbleSection = _bubbleSection;
@synthesize typingBubble = _typingBubble;
@synthesize isLoading;

- (void)initializator
{
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired=1;
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];

    
    self.snapInterval = 1;
    self.typingBubble = NSBubbleTypingTypeNobody;
}
-(void)handleTapGesture:(id)sender{
    [self.bubbleDataSource resignKeyBoard];
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}

- (void)dealloc
{
    [_bubbleSection release];
	_bubbleSection = nil;
	_bubbleDataSource = nil;
    [super dealloc];
}


#pragma mark - Override

- (void)reloadData
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    // Cleaning up
	self.bubbleSection = nil;
    
    // Loading new data
    int count = 0;
    self.bubbleSection = [[[NSMutableArray alloc] init] autorelease];
    
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
        NSMutableArray *bubbleData = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[ActivityChatData class]]);
            [bubbleData addObject:object];
        }
        
        [bubbleData sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             ActivityChatData *bubbleData1 = (ActivityChatData *)obj1;
             ActivityChatData *bubbleData2 = (ActivityChatData *)obj2;
             
             return [bubbleData1.date compare:bubbleData2.date];
         }];
        
        NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
        NSMutableArray *currentSection = nil;
        
        for (int i = 0; i < count; i++)
        {
            ActivityChatData *data = (ActivityChatData *)[bubbleData objectAtIndex:i];
            
           // if ([data.date timeIntervalSinceDate:last] > self.snapInterval)
            {
                currentSection = [[[NSMutableArray alloc] init] autorelease];
                [self.bubbleSection addObject:currentSection];
            }
            
            [currentSection addObject:data];
            last = data.date;
        }
    }
    
    [super reloadData];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    //if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // typing bubble
	//if (section >= [self.bubbleSection count]) return 1;
    ActivityChatData *rowElement=[[self.bubbleSection objectAtIndex:section]objectAtIndex:0];
    if(rowElement.type==BubbleTypeMine){
        NSLog(@"Count in row=%d",[[self.bubbleSection objectAtIndex:section] count] + 1);
        return [[self.bubbleSection objectAtIndex:section] count] + 1;
    }
    else{
                NSLog(@"Count in row=%d",[[self.bubbleSection objectAtIndex:section] count] + 2);
        return [[self.bubbleSection objectAtIndex:section] count] + 2;
    }
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
//	if (indexPath.section >= [self.bubbleSection count])
//    {
//        return MAX([UIBubbleTypingTableViewCell height], self.showAvatars ? 52 : 0);
//    }
    
    int delta=0;

    ActivityChatData *rowElement=[[self.bubbleSection objectAtIndex:indexPath.section]objectAtIndex:0];
    if(rowElement.type==BubbleTypeMine){

    // Header
    if (indexPath.row ==1)
    {
        return [UIBubbleHeaderFooterTableViewCell height];
    }
    ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if([data.view isKindOfClass:[UIImageView class]]){
            delta=5.0;
        }
        return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom+delta, data.showAvatars ? 39 : 0);
    }else{
        
        
        if (indexPath.row ==0||indexPath.row==2)
        {
            return [UIBubbleHeaderFooterTableViewCell height];
        }
        

        ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        if([data.view isKindOfClass:[UIImageView class]]){
            delta=5.0;
        }

        return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom+delta, data.showAvatars ? 39 : 0);

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Now typing
//	if (indexPath.section >= [self.bubbleSection count])
//    {
//        static NSString *cellId = @"tblBubbleTypingCell";
//        UIBubbleHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
//        
//        if (cell == nil) cell = [[UIBubbleHeaderTableViewCell alloc] init];
//        
//        cell.date = data.date;
//        
//        return cell;
//    }
    
    ActivityChatData *rowElement=[[self.bubbleSection objectAtIndex:indexPath.section]objectAtIndex:0];
    if(rowElement.type==BubbleTypeMine){
        
        
        if (indexPath.row == 1)
        {
            static NSString *cellId = @"tblBubbleHeaderCell";
            UIBubbleHeaderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
            
            if (cell == nil) cell = [[UIBubbleHeaderFooterTableViewCell alloc] init];
            cell.bubbleType=data.type;
            cell.date = data.date;
            
            return cell;
        }

        
        static NSString *cellId = @"tblBubbleCell";
        UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if (cell == nil) cell = [[UIBubbleTableViewCell alloc] init];
        
        cell.data = data;
        cell.section=indexPath.row-1;
        cell.delegate=self;

        cell.showAvatar = data.showAvatars;
        return cell;


    }
    else{
        
        
        if (indexPath.row == 0||indexPath.row == 2)
        {
            static NSString *cellId = @"tblBubbleHeaderCell";
            UIBubbleHeaderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:0];
            
            if (cell == nil) cell = [[UIBubbleHeaderFooterTableViewCell alloc] init];
            
            if(indexPath.row==0)
                cell.name = data.name;
            else{
                cell.bubbleType=data.type;
                cell.date=data.date;
            }
            
            return cell;
        }
        
        
        static NSString *cellId = @"tblBubbleCell";
        UIBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        
        if (cell == nil) cell = [[UIBubbleTableViewCell alloc] init];
        
        cell.data = data;
        cell.section=indexPath.row-1;
        cell.delegate=self;

        cell.showAvatar = data.showAvatars;
        return cell;
        
    }
    
}
-(void)tellToStopInteraction:(BOOL)tell{
    [self.bubbleDataSource userInteraction:tell];
}
-(void)deleteThisSection:(NSInteger)sectionIndex{
    
    [self.bubbleDataSource removeBubbleDataObjectAtIndex:sectionIndex];
    [self reloadData];
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(isLoading)
        return;
    //if(([scrollView contentOffset].y <= scrollView.frame.origin.y-20) && self.tableHeaderView!=Nil){
    if((scrollView.contentOffset.y <=15) && self.tableHeaderView!=Nil){
        isLoading=TRUE;
        [self.bubbleDataSource userScrolledToLoadEarlierMessages];
	}
    
    
}

#if 0


- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:) ||
        action == @selector(delete:)){
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return NO;
}

- (BOOL)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:) ||
        action == @selector(delete:))
        return YES;
    
    return NO;
}

#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(cameraAction:) ||
        action == @selector(textAction:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)cameraAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}


- (void)textAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Text Item Pressed", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil] show];
}
- (void)copy:(id)sender {
	
	// Get the General pasteboard and the current tile.
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
}

- (void)delete:(id)sender {
	
	// Get the General pasteboard and the current tile.
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
}

#endif


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
