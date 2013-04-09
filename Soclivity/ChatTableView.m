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
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInProgress2;
- (void)initializator
{
    imageDownloadsInProgress=[[NSMutableDictionary alloc]init];
    imageDownloadsInProgress2=[[NSMutableDictionary alloc]init];
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
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        
        
        if (indexPath.row ==0)
        {
            return [UIBubbleHeaderFooterTableViewCell height];
        }
        if(indexPath.row==2)
        {
            return [UIBubbleHeaderFooterTableViewCell height]-4;
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
        
        if([data.view isKindOfClass:[UIImageView class]]){
            
            UIImageView *test=(UIImageView*)data.view;
            if(!data.postImage){
                if (self.dragging == NO && self.decelerating == NO)
                {
                    [self startIconDownload:data forIndexPath:indexPath];
                }
                
            }
            else{
                test.image = [data.postImage retain];
                
            }
            
        }
        
        cell.data = data;
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
        
        
            
        
        if([data.view isKindOfClass:[UIImageView class]]){
            
            UIImageView *test=(UIImageView*)data.view;
            if(!data.postImage){
            if (self.dragging == NO && self.decelerating == NO)
            {
                [self startIconDownload:data forIndexPath:indexPath];
            }
                
            }
            else{
                test.image = [data.postImage retain];
                
            }

        }
        
        if(!data.avatar){
            
            if (self.dragging == NO && self.decelerating == NO)
            {
                [self startAvatarDownload:data forIndexPath:indexPath];
            }
            
        }
        else{
            cell.data.avatar=data.avatar;
            
        }

    
        cell.data = data;
        cell.delegate=self;

        cell.showAvatar = data.showAvatars;
        return cell;
        
    }
    
}

- (void)startIconDownload:(ActivityChatData*)appRecord forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.postChatRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload:kActivityPostChatData];
        [iconDownloader release];
    }
}


- (void)startAvatarDownload:(ActivityChatData*)appRecord forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress2 objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.getAvatarRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload:kActivityAvatarData];
        [iconDownloader release];
    }
}


-(void)resetLazyLoaderArray{
    [imageDownloadsInProgress2 removeAllObjects];
    [imageDownloadsInProgress removeAllObjects];
}


- (void)loadImagesForOnscreenRows{
    if ([self.bubbleSection count] > 0)
    {
        NSArray *visiblePaths = [self indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ActivityChatData *appRecord = (ActivityChatData *)[[self.bubbleSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if([appRecord.view isKindOfClass:[UIImageView class]]){
            
            if (!appRecord.postImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
            }
        }
    }
    
    
}


- (void)appImageDidLoad2:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress2 objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UIBubbleTableViewCell *cell = (UIBubbleTableViewCell*)[self cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.data.avatar =iconDownloader.getAvatarRecord.avatar;
        [self.bubbleDataSource chatObjectUpdate:iconDownloader.getAvatarRecord];
    }
    
    [self reloadData];
}



- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UIBubbleTableViewCell *cell = (UIBubbleTableViewCell*)[self cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.data =iconDownloader.postChatRecord;
        [self.bubbleDataSource chatObjectUpdate:iconDownloader.postChatRecord];
    }
    
    [self reloadData];
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
    if(scrollView.contentOffset.y <= -52 && [self.bubbleDataSource earlierCount]>0){
        isLoading=TRUE;
        [self.bubbleDataSource userScrolledToLoadEarlierMessages];
        
    }
    
}
-(void)showMenu:(ActivityChatData*)type tapTypeSelect:(NSInteger)tapTypeSelect{
    [self.bubbleDataSource showMenu:type tapTypeSelect:tapTypeSelect];
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
    {
        //[self loadImagesForOnscreenRows];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //[self loadImagesForOnscreenRows];
    
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
