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


- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;
    
    // UIBubbleTableView default properties
    
    self.snapInterval = 1;//120
    self.typingBubble = NSBubbleTypingTypeNobody;
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
            
            if ([data.date timeIntervalSinceDate:last] > self.snapInterval)
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

#pragma mark - UITableViewDelegate implementation

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int result = [self.bubbleSection count];
    //if (self.typingBubble != NSBubbleTypingTypeNobody) result++;
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // This is for now typing bubble
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
    
    
    ActivityChatData *rowElement=[[self.bubbleSection objectAtIndex:indexPath.section]objectAtIndex:0];
    if(rowElement.type==BubbleTypeMine){

    // Header
    if (indexPath.row ==1)
    {
        return [UIBubbleHeaderFooterTableViewCell height];
    }
    
    ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom, data.showAvatars ? 39 : 0);
    }else{
        
        
        if (indexPath.row ==0)
        {
            return [UIBubbleHeaderFooterTableViewCell heightForName];
        }
        

        if (indexPath.row ==2)
        {
            return [UIBubbleHeaderFooterTableViewCell height];
        }
        
        ActivityChatData *data = [[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        return MAX(data.insets.top + data.view.frame.size.height + data.insets.bottom, data.showAvatars ? 39 : 0);

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
        cell.showAvatar = data.showAvatars;
        return cell;
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
