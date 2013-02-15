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

- (void)startIconDownload:(InviteObjectClass*)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation WaitingOnYouView
@synthesize _notifications,delegate,imageDownloadsInProgress,arr_notificationids,waitingTableView, superDelegate = _superDelegate;

NSString *lstrnotifyid;

- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSMutableArray*)andNotificationsListArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self._notifications =[[andNotificationsListArray valueForKey:@"notifications"] retain];
        
        if ([andNotificationsListArray valueForKey:@"unreadnotification"]!=[NSNull null] || [andNotificationsListArray valueForKey:@"unreadnotification"]!=NULL)
        {
            self.arr_notificationids=[[andNotificationsListArray valueForKey:@"unreadnotification"] retain];
        }//END if ([andNotificationsListArray
        
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        devServer=[[MainServiceManager alloc]init];
        SOC=[SoclivityManager SharedInstance];
        
        CGRect activityTableRect;
        if([SoclivityUtilities deviceType] & iPhone5)
            activityTableRect=CGRectMake(0, 0, 320, 332+88+44);
        
        else
            activityTableRect=CGRectMake(0, 0, 320, 332+44);
        
        
        waitingTableView=[[UITableView alloc]initWithFrame:activityTableRect];
        [waitingTableView setDelegate:self];
        [waitingTableView setDataSource:self];
        waitingTableView.scrollEnabled=YES;
        waitingTableView.backgroundColor=[UIColor clearColor];
        waitingTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine; //UITableViewCellSeparatorStyleNone;
        waitingTableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"S11_divider.png"]]; //[UIColor clearColor];
        waitingTableView.showsVerticalScrollIndicator=YES;
        [self addSubview:waitingTableView];
        waitingTableView.clipsToBounds=YES;
    }//ENd if (self)
    return self;
}

-(void)GoingNotification:(id)sender
{
    lstrnotifyid=[sender currentTitle];
    
    [waitingTableView.superview setUserInteractionEnabled:FALSE];
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation];
        [devServer postActivityRequestInvocation:4  playerId:[SOC.loggedInUser.idSoc intValue] actId:[sender tag] delegate:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }//END Else Statement
}

-(void)NotGoingNotification:(id)sender
{
    lstrnotifyid=[sender currentTitle];
    [waitingTableView.superview setUserInteractionEnabled:FALSE];
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation];
        [devServer postActivityRequestInvocation:14  playerId:[SOC.loggedInUser.idSoc intValue] actId:[sender tag] delegate:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }//END Else Statement
}

-(void)AcceptNotification:(id)sender
{
    lstrnotifyid=[sender currentTitle];
    
    NSArray *SplitNotifyarray=[lstrnotifyid componentsSeparatedByString:@","];
    
    [waitingTableView.superview setUserInteractionEnabled:FALSE];
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation];
        [devServer postActivityRequestInvocation:7  playerId:[[SplitNotifyarray objectAtIndex:2] intValue] actId:[sender tag] delegate:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }//END Else Statement
}

-(void)DeclineNotification:(id)sender
{
    lstrnotifyid=[sender currentTitle];
    
     NSArray *SplitNotifyarray=[lstrnotifyid componentsSeparatedByString:@","];
    
    [waitingTableView.superview setUserInteractionEnabled:FALSE];
    
    if([SoclivityUtilities hasNetworkConnection]){
        [self startAnimation];
        [devServer postActivityRequestInvocation:13  playerId:[[SplitNotifyarray objectAtIndex:2] intValue] actId:[sender tag] delegate:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }//END Else Statement
}

-(void)PostActivityRequestInvocationDidFinish:(PostActivityRequestInvocation*)invocation
                                 withResponse:(BOOL)response relationTypeTag:(NSInteger)relationTypeTag
                                    withError:(NSError*)error{

    NSArray *SplitNotifyarray=[lstrnotifyid componentsSeparatedByString:@","];
    
   // [self SetNotificationStatus:[SplitNotifyarray objectAtIndex:1]];
    [self RemoveNotification:[SplitNotifyarray objectAtIndex:1]];
    [self._notifications removeObjectAtIndex:[[SplitNotifyarray objectAtIndex:0] intValue]];
    
    [waitingTableView.superview setUserInteractionEnabled:TRUE];
    
    [waitingTableView reloadData];
    
    [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];
}

#pragma mark -get current time
-(NSString *)NetworkTime:(NSString *)lstrtime{
#if 1
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    // how to get back time from current time in the same format
    NSDate *lastDate = [dateFormatter dateFromString:lstrtime];//add the string
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate=[dateFormatter dateFromString:todayDate];
    
    NSTimeInterval interval = [lastDate timeIntervalSinceDate:currentDate];
    unsigned long seconds = interval;
    unsigned long minutes = seconds / 60;
    seconds %= 60;
    unsigned long hours = minutes / 60;
    if(hours)
        minutes %= 60;
    unsigned long days=hours/24;
    if(days)
        hours %=24;
    
    NSMutableString * result = [[NSMutableString new] autorelease];
    dateFormatter.dateFormat=@"EEE, MMM d, h:mma";
    
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:lastDate];
    NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval2 = destinationGMTOffset1;
    NSTimeInterval interval3 = destinationGMTOffset2;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval2 sinceDate:lastDate] autorelease];
    NSDate* currentDateTime = [[[NSDate alloc] initWithTimeInterval:interval3 sinceDate:currentDate] autorelease];
    
    NSString *activityTime=[dateFormatter stringFromDate:destinationDate];
   // NSString  *currentTime=[dateFormatter stringFromDate:currentDateTime];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    int differenceInDays =
    [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:destinationDate]-
    [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:currentDateTime];
    BOOL checkTime=TRUE;
    switch (differenceInDays) {
        case -1:
        {
            dateFormatter.dateFormat=@"h:mma";
            [result appendFormat:@"%@",[NSString stringWithFormat:@"Yesterday, %@",[dateFormatter stringFromDate:destinationDate]]];
        }//END  case -1:
            break;
        case 0:
        {
            if(hours && checkTime){
                [result appendFormat: @"in %ld hrs", hours];
            }//END if(hours && checkTime)
            
            if(minutes && checkTime){
                
                if(hours==0){
                    [result appendFormat: @"in %ld min", minutes];
                }//END if(hours==0)
                else
                    [result appendFormat: @" %ld min", minutes];
                checkTime=FALSE;
            }//END if(minutes && checkTime)
            
            dateFormatter.dateFormat=@"h:mma";
            [result appendFormat:@"%@",[NSString stringWithFormat:@"Today, %@",[dateFormatter stringFromDate:destinationDate]]];
        }//END case 0:
            break;
        case 1:
        {
            [result appendFormat: @"Tommorow"];
            dateFormatter.dateFormat=@"h:mma";
            
            [result appendFormat:@"%@",[NSString stringWithFormat:@"Tomorrow, %@",[dateFormatter stringFromDate:destinationDate]]];
        }//END case 1:
            break;
        default: {
            [result appendFormat:@"%@",activityTime];
        }//END default
            break;
    }//END switch (differenceInDays)
    
    return result;
#endif
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self._notifications count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int height=0;
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==[NSNull null])
    {
        height=60;
    }//END if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==NULL)
    
    else if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==6)
    {
        height=[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+50;
    }//END if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==NULL)
    
    else if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==12)
    {
        height=[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+50;
    }//END if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==NULL)
    else
    {
         height=[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+20;
    }//END Else Statement
        
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AttributedTableViewCell *cell = (AttributedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[AttributedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
   // }
    
    int rowheight=60;
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==[NSNull null])
    {
        rowheight=60;
    }//END if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==NULL)
    
    else
    {
        rowheight=[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+20;
    }//END Else Statement`
    
    cell.lstrnotificationtype=[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"];
    
    NSLog(@"notification::%@",[self._notifications objectAtIndex:indexPath.row]);
    
    for (UIView *view in cell.contentView.subviews)
    {
        if (![view isKindOfClass:[UILabel class]])
        {
             [view removeFromSuperview];
        }//END if (![view isKindOfClass:[UILabel class]])
    }//END for (UIView *view in cell.contentView.subviews)
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]!=[NSNull null])
    {
        cell.summaryText =[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"];
        cell.summaryLabel.delegate = self;
    }//END if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"noti
    
    cell.summaryLabel.userInteractionEnabled = YES;
    cell.summaryLabel.backgroundColor=[UIColor clearColor];
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"created_at"]!=NULL)
    {
        cell.TimeText =[self NetworkTime:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"created_at"]];
    }//END if ([[self._notifications objectAtIndex:indexPath
    
    cell.lbltime.userInteractionEnabled = YES;
    cell.lbltime.backgroundColor=[UIColor clearColor];
    
    CGSize imgSize;
    
    UIImageView *Borderimg_vw=[[UIImageView alloc] init];
    Borderimg_vw.frame=CGRectMake(15, 15, 37,37);
    Borderimg_vw.backgroundColor=[UIColor clearColor];
    Borderimg_vw.image=[UIImage imageNamed:@"S11_frame.png"];
    [Borderimg_vw setContentMode:UIViewContentModeScaleAspectFit];
    
    UIImageView *img_vw=[[UIImageView alloc] init];
    img_vw.backgroundColor=[UIColor clearColor];
    [img_vw setContentMode:UIViewContentModeScaleAspectFit];
    img_vw.tag=indexPath.row;
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"]!=[NSNull null])
    {
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==1)
        {
            img_vw.image=[UIImage imageNamed:@"S11_infoChangeIcon.png"];
            imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:img_vw];
        }//END if ([[[[self._notifications  objectAtIndex:indexPath
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==2)
        {
            img_vw.image=[UIImage imageNamed:@"S11_calendarIcon.png"];
            imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:img_vw];
        }//END if ([[[[self._notifications objectAt
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==3)
        {
            img_vw.image=[UIImage imageNamed:@"S11_clockLogo.png"];
            imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:img_vw];
        }//END if ([[[[self._notifications objectAt
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==4)
        {
            img_vw.image=[UIImage imageNamed:@"S11_locationIcon.png"];
             imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
            
            [cell.contentView addSubview:img_vw];
        }//END if ([[[[self._notifications objectAt
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==6 ||
            [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==7 ||[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==8 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==9 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==11|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==12|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==13|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==14|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==15|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==16)
        {
            IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
            
            if (!iconDownloader.img_waitingonyou)
            {
                if (waitingTableView.dragging == NO && waitingTableView.decelerating == NO)
                {
                    [self startIconDownloadForIndexPath:indexPath];
                }//END if (waitingTableView.dragging == NO && waitingTableView.decelerating == NO)
                
                // if a download is deferred or in progress, return a placeholder image
                img_vw.image = [UIImage imageNamed:@"S11_picBox.png"];
            }
            else
            {
                img_vw.image = [iconDownloader.img_waitingonyou retain];
            }//END Else Statement
            
            imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(3,3,30,29);
            
            [Borderimg_vw addSubview:img_vw];
            [cell.contentView addSubview:Borderimg_vw];
            
            if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==6)
            {
                UIButton *btngoing=[UIButton buttonWithType:UIButtonTypeCustom];
                btngoing.frame=CGRectMake(150,[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+20, 71, 25);
                [btngoing setBackgroundImage:[UIImage imageNamed:@"S11_goingButton.png"] forState:UIControlStateNormal];
                btngoing.tag=[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"] intValue];
                [btngoing setTitle:[NSString stringWithFormat:@"%i,%@",indexPath.row,[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]] forState:UIControlStateNormal];
                [btngoing setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [btngoing setEnabled:TRUE];
                [btngoing addTarget:self action:@selector(GoingNotification:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *btnnotgoing=[UIButton buttonWithType:UIButtonTypeCustom];
                btnnotgoing.frame=CGRectMake(230,[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+20, 71, 25);
                [btnnotgoing setBackgroundImage:[UIImage imageNamed:@"S11_notGoingButton.png"] forState:UIControlStateNormal];
                btnnotgoing.tag=[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"] intValue];
                [btnnotgoing setTitle:[NSString stringWithFormat:@"%i,%@",indexPath.row,[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]] forState:UIControlStateNormal];
                [btnnotgoing setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [btnnotgoing setEnabled:TRUE];
                [btnnotgoing addTarget:self action:@selector(NotGoingNotification:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:btnnotgoing];
                [cell.contentView addSubview:btngoing];
                
                rowheight=[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+50;
                
            }//END  if (notif.type==6)
            
            if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==12)
            {
                UIButton *btnaccept=[UIButton buttonWithType:UIButtonTypeCustom];
                btnaccept.frame=CGRectMake(150,[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+20, 71, 25);
                [btnaccept setBackgroundImage:[UIImage imageNamed:@"S11_joinAcceptButton.png"] forState:UIControlStateNormal];
                btnaccept.tag=[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"] intValue];
                [btnaccept setTitle:[NSString stringWithFormat:@"%i,%@,%@",indexPath.row,[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"],[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"reffered_to"]] forState:UIControlStateNormal];
                [btnaccept setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [btnaccept setEnabled:TRUE];
                [btnaccept addTarget:self action:@selector(AcceptNotification:) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *btndecline=[UIButton buttonWithType:UIButtonTypeCustom];
                btndecline.frame=CGRectMake(230,[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+20, 71, 25);
                [btndecline setBackgroundImage:[UIImage imageNamed:@"S11_joinDeclineButton.png"] forState:UIControlStateNormal];
                btndecline.tag=[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"] intValue];
                [btndecline setTitle:[NSString stringWithFormat:@"%i,%@,%@",indexPath.row,[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"],[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"reffered_to"]] forState:UIControlStateNormal];
                [btndecline setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [btndecline setEnabled:TRUE];
                [btndecline addTarget:self action:@selector(DeclineNotification:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.contentView addSubview:btndecline];
                [cell.contentView addSubview:btnaccept];
                
                rowheight=[AttributedTableViewCell heightForCellWithText:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]]+50;
                
            }//END  if (notif.type==12)
        }//END if ([[[[self._notifications objectAtIndex:indexPath.row]
    
    }//END if ([[[[self._notifications objectAtIndex:indexPat
    
    UIButton *btnindicator=[UIButton buttonWithType:UIButtonTypeCustom];
    btnindicator.frame=CGRectMake(276, 20, 38, 38);
    [btnindicator setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
    [btnindicator setBackgroundColor:[UIColor clearColor]];
    btnindicator.tag=[[NSString stringWithFormat:@"222%i",indexPath.row] intValue];
    btnindicator.userInteractionEnabled=FALSE;
    btnindicator.hidden=FALSE;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithFrame:CGRectMake(282.0f, 27.0f, 20.0f, 20.0f)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.tag=[[NSString stringWithFormat:@"111%i",indexPath.row] intValue];
    [activityIndicator setHidden:TRUE];
    [waitingTableView addSubview:activityIndicator];
    
    [cell.contentView addSubview:btnindicator];
    [cell.contentView addSubview:activityIndicator];
    
    NSString *lstrid=[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"];
    
    UIView *vw_background=[[UIView alloc] initWithFrame:CGRectMake(0,0,320,rowheight)];
    vw_background.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    if (self.arr_notificationids!=NULL && [self.arr_notificationids count]!=0)
    {
        if ([self.arr_notificationids containsObject:lstrid])
        {
            vw_background.backgroundColor=[UIColor whiteColor];
        }//END for (lstrid in self.arr_notificationids)
        
        else
        {
            vw_background.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
        }//END Else Statement
    }//END if (self.arr_notificationids!=NULL)
    
    [cell.contentView insertSubview:vw_background atIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark -
#pragma mark Lazy Loading

- (void)startIconDownloadForIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.lstrwaitingonyouurl=[NSString stringWithFormat:@"http://dev.soclivity.com%@",[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"photo_url"]];
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload:kWaitingOnYou];
    }//END if (iconDownloader == nil)
}

- (void)loadImagesForOnscreenRows{
    
    
    int count=0;
        count=[_notifications count];
    if (count> 0)
    {
        NSArray *visiblePaths = [waitingTableView indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths)
        {
            IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
            if (!iconDownloader.img_waitingonyou) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownloadForIndexPath:indexPath];
            }
        }
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        // Display the newly loaded image
    }//END if (iconDownloader != nil)
    
    [waitingTableView reloadData];
}

#pragma mark - UITableViewDelegate

-(void)SetNotificationStatus:(NSString *)lstrid
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://dev.soclivity.com/notification_read.json?id=%@&read_notification=1",lstrid]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([SoclivityUtilities hasNetworkConnection]){
       
        UIButton *btn=(UIButton *)[self viewWithTag:[[NSString stringWithFormat:@"222%i",indexPath.row] intValue]];
        [btn setHidden:TRUE];
        
        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self viewWithTag:[[NSString stringWithFormat:@"111%i",indexPath.row] intValue]];
        [tmpimg startAnimating];
        [tmpimg setHidden:NO];
        
        NSString *lstractivityid;
        
        if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"]==[NSNull null])
        {
            lstractivityid=@"0";
        }//END if ([[self._notifications objectAtIndex:indexPath
        
        else if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"]!=[NSNull null]){
            lstractivityid=[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"];
        }//END Else Statement
        
        NSMutableDictionary *dictactivity=[[NSMutableDictionary alloc] init];
        [dictactivity setValue:lstractivityid forKey:@"activity_id"];
        [dictactivity setValue:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"lat"] forKey:@"lat"];
        [dictactivity setValue:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"lng"] forKey:@"lng"];
        
        if([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==7 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==9 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==13)
        {
          [dictactivity setValue:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"reffered_to"] forKey:@"user_id"];  
        }
        
        else if([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]!=7 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]!=9 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]!=13){
            [dictactivity setValue:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"user_id"] forKey:@"user_id"];
        }
        
        _superDelegate.lstrnotificationtypeid=[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"];
        [_superDelegate navigate:dictactivity];
        
        [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];

    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }//END Else Statement

    //[self SetNotificationStatus:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]];
    //NSString *description = [[self._notifications objectAtIndex:indexPath.row];
    //NSLog(@"description=%@",description);
}

-(void)RemoveNotification:(NSString *)lstrid
{
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://dev.soclivity.com/deletenotification.json?logged_in_user_id=%@&notification_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"],lstrid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responsedata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responsedata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
													message:@"Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	return;
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
    
    [waitingTableView reloadData];
    [loadingActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self startAnimation];
    
    [self RemoveNotification:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Notification_id"]!=NULL)
    {
        NSString *lstrnotify=[[NSUserDefaults standardUserDefaults] valueForKey:@"Notification_id"];
        NSArray *SpliArray=[lstrnotify componentsSeparatedByString:@","];
        
        for (int i=0; i<[SpliArray count]; i++)
        {
            if ([[SpliArray objectAtIndex:i] intValue]==[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"] intValue])
            {
                int count=[[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue];
                count=count-1;
                
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i",count] forKey:@"Waiting_On_You_Count"];
            }
        }//END for (int i=0; i<[SpliArray count]; i++)
    }//END if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Notif
    
    [self._notifications removeObjectAtIndex:indexPath.row];
    [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // To "clear" the footer view
    return [[UIView new] autorelease];
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

-(void)startAnimation{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:waitingTableView];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Loading...";
    [waitingTableView addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
}

-(void)hideMBProgress{
    [HUD hide:YES];
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
