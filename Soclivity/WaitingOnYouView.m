//
//  WaitingOnYouView.m
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import "WaitingOnYouView.h"
#import "SoclivityUtilities.h"
#import "AttributedTableViewCell.h"
#import "NotificationClass.h"
#import "SlideViewController.h"
#import "AppDelegate.h"
#import "MainServiceManager.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "NotificationsViewController.h"

@interface WaitingOnYouView ()

- (void)startIconDownload:(NotificationClass*)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation WaitingOnYouView
@synthesize notificationsArray,delegate,imageDownloadsInProgress,waitingTableView;


- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSMutableArray*)andNotificationsListArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.notificationsArray =[andNotificationsListArray retain];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
        SOC=[SoclivityManager SharedInstance];
        

        
        if([andNotificationsListArray count]==0){
            [self setUpBackgroundView];
            
        }
        else{
            
            [self SetupNotificationTable];

        }
    }
    return self;
}
-(void)SetupNotificationTable{
    CGRect activityTableRect;
    
    if([SoclivityUtilities deviceType] & iPhone5)
        activityTableRect=CGRectMake(0, 0, 320, 332+88+44);
    
    else
        activityTableRect=CGRectMake(0, 0, 320, 332+44);
    
    waitingTableView=[[UITableView alloc] initWithFrame:activityTableRect style:UITableViewStylePlain];
    [waitingTableView setDelegate:self];
    [waitingTableView setDataSource:self];
    waitingTableView.scrollEnabled=YES;
    waitingTableView.backgroundView=nil;
    waitingTableView.backgroundColor=[UIColor clearColor];
    waitingTableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"S11_divider.png"]];
    waitingTableView.showsVerticalScrollIndicator=YES;
    [self addSubview:waitingTableView];
    waitingTableView.clipsToBounds=YES;

}

-(void)setUpBackgroundView{
    CGRect activityTableRect;
    
    if([SoclivityUtilities deviceType] & iPhone5)
        activityTableRect=CGRectMake(0, 0, 320, 332+88+44);
    
    else
        activityTableRect=CGRectMake(0, 0, 320, 332+44);
    
    self.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    UIView *backgroundView=[[UIView alloc]initWithFrame:activityTableRect];
    UIImageView *noNotificationsImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S11_noNotfications.png"]];
    noNotificationsImageView.frame=CGRectMake(93, 112, 134, 151);
    [backgroundView addSubview:noNotificationsImageView];
    
    UIImageView *logoFadedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S11_logoFaded.png"]];
    logoFadedImageView.frame=CGRectMake(105, 359, 111, 28);
    [backgroundView addSubview:logoFadedImageView];
    [self addSubview:backgroundView];


}

-(void)toReloadTableWithNotifications:(NSMutableArray*)listArray{
    
     self.notificationsArray =[listArray retain];
    if(waitingTableView==nil){
        [self SetupNotificationTable];

    }
    [waitingTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notificationsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height=0.0f;
    
    NotificationClass *notif=[self.notificationsArray objectAtIndex:indexPath.row];
    switch ([notif.notificationType integerValue]) {
        case 6:
        case 12:
        {
            notif.rowHeight=[AttributedTableViewCell heightForCellWithText:notif.notificationString];
            height=notif.rowHeight+50.0f;

        }
            break;
            
        default:
        {
            notif.rowHeight=[AttributedTableViewCell heightForCellWithText:notif.notificationString];
            height=notif.rowHeight+20.0f;
        }
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AttributedTableViewCell *cell = (AttributedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[AttributedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
   // }
    
    CGFloat rowheight=0.0f;
    
    NotificationClass *cellNotification=[self.notificationsArray objectAtIndex:indexPath.row];
    
    if(cellNotification.notificationString != nil && [cellNotification.notificationString class] != [NSNull class]){
        rowheight=60;
        
    }
    else
        rowheight=cellNotification.rowHeight;
    
    cell.notificationType=cellNotification.notificationType;
    
    for (UIView *view in cell.contentView.subviews)
    {
        if (![view isKindOfClass:[UILabel class]])
        {
             [view removeFromSuperview];
        }
    }
    
    cell.summaryText =cellNotification.notificationString;
    cell.summaryLabel.delegate = self;
    
    cell.summaryLabel.userInteractionEnabled = YES;
    cell.summaryLabel.backgroundColor=[UIColor clearColor];
    cell.TimeText =[SoclivityUtilities nofiticationTime:cellNotification.timeOfNotification];
    
    cell.lbltime.userInteractionEnabled = YES;
    cell.lbltime.backgroundColor=[UIColor clearColor];
    
    CGSize imgSize;
    
    UIImageView *borderImageView=[[UIImageView alloc] init];
    borderImageView.frame=CGRectMake(15, 15, 37,37);
    borderImageView.backgroundColor=[UIColor clearColor];
    borderImageView.image=[UIImage imageNamed:@"S11_frame.png"];
    [borderImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.backgroundColor=[UIColor clearColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.tag=indexPath.row;
    
    switch ([cellNotification.notificationType integerValue]) {
        case 1:
        {
            imageView.image=[UIImage imageNamed:@"S11_infoChangeIcon.png"];
            imgSize=[imageView.image size];
            imageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:imageView];
            
        }
            break;
            
        case 2:
        {
            imageView.image=[UIImage imageNamed:@"S11_calendarIcon.png"];
            imgSize=[imageView.image size];
            imageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            [cell.contentView addSubview:imageView];
            
        }
            break;
            
            
        case 3:
        {
            imageView.image=[UIImage imageNamed:@"S11_clockLogo.png"];
            imgSize=[imageView.image size];
            imageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:imageView];
            
        }
            break;
            
        case 4:
        {
            imageView.image=[UIImage imageNamed:@"S11_locationIcon.png"];
            imgSize=[imageView.image size];
            imageView.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:imageView];
            
        }
            break;
            
            
        case 6:
        case 7:
        case 8:
        case 9:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        {
            if (!cellNotification.profileImage)
            {
                if (waitingTableView.dragging == NO && waitingTableView.decelerating == NO)
                {
                    [self startIconDownload:cellNotification forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                imageView.image = [UIImage imageNamed:@"picbox.png"];
                
            }
            else
            {
                imageView.image = [cellNotification.profileImage retain];
            }
            
            imgSize=[imageView.image size];
            imageView.frame=CGRectMake(3,3,30,29);
            
            [borderImageView addSubview:imageView];
            [cell.contentView addSubview:borderImageView];
            
            switch ([cellNotification.notificationType integerValue]) {
                case 6:
                {
                    UIButton *btngoing=[UIButton buttonWithType:UIButtonTypeCustom];
                    btngoing.frame=CGRectMake(150,cellNotification.rowHeight+20, 71, 25);
                    [btngoing setBackgroundImage:[UIImage imageNamed:@"S11_goingButton.png"] forState:UIControlStateNormal];
                    btngoing.tag=indexPath.row;
                    [btngoing setTitle:[NSString stringWithFormat:@"%d,%d",cellNotification.activityId,cellNotification.notificationId] forState:UIControlStateNormal];
                    [btngoing setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [btngoing addTarget:self action:@selector(GoingNotification:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *btnnotgoing=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnnotgoing.frame=CGRectMake(230,cellNotification.rowHeight+20, 71, 25);
                    [btnnotgoing setBackgroundImage:[UIImage imageNamed:@"S11_notGoingButton.png"] forState:UIControlStateNormal];
                    btnnotgoing.tag=indexPath.row;
                    [btnnotgoing setTitle:[NSString stringWithFormat:@"%d,%d",cellNotification.activityId,cellNotification.notificationId] forState:UIControlStateNormal];
                    [btnnotgoing setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [btnnotgoing addTarget:self action:@selector(NotGoingNotification:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.contentView addSubview:btnnotgoing];
                    [cell.contentView addSubview:btngoing];
                    
                    rowheight=cellNotification.rowHeight+50;
                    
                }
                    break;
                    
                case 12:
                {
                    UIButton *btnaccept=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnaccept.frame=CGRectMake(150,cellNotification.rowHeight+20, 71, 25);
                    [btnaccept setBackgroundImage:[UIImage imageNamed:@"S11_joinAcceptButton.png"] forState:UIControlStateNormal];
                    btnaccept.tag=indexPath.row;
                    [btnaccept setTitle:[NSString stringWithFormat:@"%d,%d,%d",cellNotification.activityId,cellNotification.notificationId,cellNotification.referredId] forState:UIControlStateNormal];
                    [btnaccept setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [btnaccept addTarget:self action:@selector(AcceptNotification:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UIButton *btndecline=[UIButton buttonWithType:UIButtonTypeCustom];
                    btndecline.frame=CGRectMake(230,cellNotification.rowHeight+20, 71, 25);
                    [btndecline setBackgroundImage:[UIImage imageNamed:@"S11_joinDeclineButton.png"] forState:UIControlStateNormal];
                    btndecline.tag=indexPath.row;
                    [btndecline setTitle:[NSString stringWithFormat:@"%d,%d,%d",cellNotification.activityId,cellNotification.notificationId,cellNotification.referredId] forState:UIControlStateNormal];
                    [btndecline setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [btndecline addTarget:self action:@selector(DeclineNotification:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.contentView addSubview:btndecline];
                    [cell.contentView addSubview:btnaccept];
                    
                    rowheight=cellNotification.rowHeight+50;
                    
                }
                    break;
                    
                default:
                    break;
            }

            
        }
            break;




            
        default:
            break;
    }
    
    UIButton *buttonArrow=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonArrow.frame=CGRectMake(276, 20, 38, 38);
    [buttonArrow setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
    [buttonArrow addTarget:self action:@selector(rightArrowPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonArrow setBackgroundColor:[UIColor clearColor]];
    buttonArrow.tag=[[NSString stringWithFormat:@"222%i",indexPath.row] intValue];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithFrame:CGRectMake(282.0f, 27.0f, 20.0f, 20.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.tag=[[NSString stringWithFormat:@"111%i",indexPath.row] intValue];
    [activityIndicator setHidden:TRUE];
    [waitingTableView addSubview:activityIndicator];
    
    [cell.contentView addSubview:buttonArrow];
    [cell.contentView addSubview:activityIndicator];
    
    
    UIView *backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0,0,320,rowheight)];
    backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    
    if(cellNotification.isRead){
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
        
    }
    else{
        backgroundView.backgroundColor=[UIColor whiteColor];
        
    }
    [cell.contentView insertSubview:backgroundView atIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma mark -
#pragma mark Lazy Loading

- (void)startIconDownload:(NotificationClass*)appRecord forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.notificationRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload:kNotificationImageUrl];
        [iconDownloader release];
    }
}





- (void)loadImagesForOnscreenRows{
    
    
    if ([self.notificationsArray count]> 0)    {
        NSArray *visiblePaths = [waitingTableView indexPathsForVisibleRows];
        
            for (NSIndexPath *indexPath in visiblePaths)
            {
                NotificationClass *appRecord = (NotificationClass*)[self.notificationsArray objectAtIndex:indexPath.row];
                
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
        AttributedTableViewCell *cell = (AttributedTableViewCell*)[waitingTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        CGSize imgSize;
        
        UIImageView *borderImageView=[[UIImageView alloc] init];
        borderImageView.frame=CGRectMake(15, 15, 37,37);
        borderImageView.backgroundColor=[UIColor clearColor];
        borderImageView.image=[UIImage imageNamed:@"S11_frame.png"];
        [borderImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        UIImageView *imageView=[[UIImageView alloc] init];
        imageView.backgroundColor=[UIColor clearColor];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.tag=indexPath.row;
        imageView.image=iconDownloader.notificationRecord.profileImage;
        imgSize=[imageView.image size];
        imageView.frame=CGRectMake(3,3,30,29);
        
        [borderImageView addSubview:imageView];
        [cell.contentView addSubview:borderImageView];
   }
    
    [waitingTableView reloadData];
}






-(void)rightArrowPressed:(UIButton*)sender{
    UIButton *btn=(UIButton *)[self.waitingTableView viewWithTag:sender.tag];
    [btn setHidden:TRUE];
    removeIndex=sender.tag%222;
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self viewWithTag:[[NSString stringWithFormat:@"111%i",sender.tag%222] intValue]];
    [tmpimg startAnimating];
    [tmpimg setHidden:NO];
    
    
    NotificationClass *notificationSelect=[self.notificationsArray objectAtIndex:sender.tag%222];
    [delegate pushUserToDetailedNavigation:notificationSelect];
    
}

-(void)updateButtonAndAnimation{
    NSString *arrowButtonValue=[NSString stringWithFormat:@"222%d",removeIndex];
    [(UIButton*)[self.waitingTableView viewWithTag:[arrowButtonValue intValue]] setHidden:NO];
    
    NSString *spinnerValue=[NSString stringWithFormat:@"111%d",removeIndex];
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.waitingTableView viewWithTag:[spinnerValue intValue]];
    [tmpimg stopAnimating];
    [tmpimg setHidden:YES];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)notificationRemoved{
    
    NotificationClass *notificationSelect=[self.notificationsArray objectAtIndex:removeIndex];
    if(!notificationSelect.isRead){
        SOC.loggedInUser.badgeCount=SOC.loggedInUser.badgeCount-1;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];

    }
    
    [self.notificationsArray removeObjectIdenticalTo:notificationSelect];
    
    if([self.notificationsArray count]>0)
        [self.waitingTableView reloadData];
    else{
        [self.waitingTableView removeFromSuperview];
        [self setUpBackgroundView];
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificationClass *obj=[self.notificationsArray objectAtIndex:indexPath.row];
    removeIndex=indexPath.row;
    [delegate userWantsToDeleteTheNofication:obj.notificationId];
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

-(void)GoingNotification:(UIButton*)sender{
    NSArray *test=[[sender currentTitle] componentsSeparatedByString:@","];
    removeIndex=sender.tag;
    [delegate userGoingNotification:[[test objectAtIndex:0]integerValue]];
    
    
}

-(void)NotGoingNotification:(UIButton*)sender{
    
    NSArray *test=[[sender currentTitle] componentsSeparatedByString:@","];
    removeIndex=sender.tag;
    [delegate userNotGoingNotification:[[test objectAtIndex:0]integerValue]];

}

-(void)AcceptNotification:(UIButton*)sender{
    
    NSArray *test=[[sender currentTitle] componentsSeparatedByString:@","];
    removeIndex=sender.tag;
    [delegate acceptNotification:[[test objectAtIndex:0]integerValue] player:[[test objectAtIndex:2]intValue]];

}

-(void)DeclineNotification:(UIButton*)sender{
    NSArray *test=[[sender currentTitle] componentsSeparatedByString:@","];
    removeIndex=sender.tag;
    [delegate declineNotification:[[test objectAtIndex:0]integerValue] player:[[test objectAtIndex:2]intValue]];
    
}

-(void)requestComplete{
    NotificationClass *notifCl=[self.notificationsArray objectAtIndex:removeIndex];
    [delegate userWantsToDeleteTheNofication:notifCl.notificationId];
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
