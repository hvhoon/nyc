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

@interface WaitingOnYouView ()

- (void)startIconDownload:(InviteObjectClass*)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation WaitingOnYouView
@synthesize _notifications,delegate,imageDownloadsInProgress,arr_notificationids;

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
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"updated_at"]!=[NSNull null])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
        NSDate *activityDate = [dateFormatter dateFromString:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"updated_at"]];
        
        NSDate *date = activityDate;
        NSDateFormatter *prefixDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [prefixDateFormatter setDateFormat:@"EEEE, MMMM d, hh:mma"];
        NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
        
        cell.TimeText =prefixDateString;

    }//END if ([[[self._notifications objectAtIndex:indexPath.row] valueForK
    
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
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==6 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==8 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==9 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==11|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==12|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==13|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==14|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==15|| [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==16)
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
    [btnindicator setTag:[[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]];
    [btnindicator addTarget:self action:@selector(NavigationScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:btnindicator];
    
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
        iconDownloader.lstrwaitingonyouurl=[NSString stringWithFormat:@"http://%@%@",ProductionServer,[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"photo_url"]];
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
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/notification_read.json?id=%@&read_notification=1",ProductionServer,lstrid]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*NSLog(@"sender::%@",[self._notifications objectAtIndex:indexPath.row]);
    
    NSDictionary *dictactivity=[[NSDictionary alloc] init];
    //[[dictactivity setValue:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"] forKey:@"Activity_ID"];
     //[dictactivity setValue:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"activity_id"] forKey:@"Activity_ID"];
    
    HomeViewController *objhome=[[HomeViewController alloc] init];
    [objhome Pushactivity:dictactivity];
     */
    
    //[self SetNotificationStatus:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]];
    //NSString *description = [[self._notifications objectAtIndex:indexPath.row];
    //NSLog(@"description=%@",description);
}

-(void)NavigationScreen:(id)sender
{
    if ([sender tag]==1)
    {
        
    }//END if ([sender tag]==1)
}

-(void)RemoveNotification:(NSString *)lstrid
{
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://%@/deletenotification.json?logged_in_user_id=%@&notification_id=%@",ProductionServer,[[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"],lstrid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
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
