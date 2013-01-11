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

@interface WaitingOnYouView ()

- (void)startIconDownload:(InviteObjectClass*)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end


@implementation WaitingOnYouView
@synthesize _notifications,delegate,imageDownloadsInProgress;


- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSMutableArray*)andNotificationsListArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self._notifications =[andNotificationsListArray retain];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
        CGRect activityTableRect;
        if([SoclivityUtilities deviceType] & iPhone5)
            activityTableRect=CGRectMake(0, 0, 320, 332+88+44);
        
        else
            activityTableRect=CGRectMake(0, 0, 320, 332+44);
        
        
        waitingTableView=[[UITableView alloc]initWithFrame:activityTableRect];
        [waitingTableView setDelegate:self];
        [waitingTableView setDataSource:self];
        waitingTableView.scrollEnabled=YES;
        waitingTableView.backgroundColor=[SoclivityUtilities returnTextFontColor:10];
        waitingTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine; //UITableViewCellSeparatorStyleNone;
        waitingTableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"S11_divider.png"]]; //[UIColor clearColor];
        waitingTableView.showsVerticalScrollIndicator=YES;
        [self addSubview:waitingTableView];
        waitingTableView.clipsToBounds=YES;
        
    }
    return self;
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
    }//END if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]==NULL)
    
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
    
    cell.lstrnotificationtype=[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"];
    
    for (UIView *view in cell.contentView.subviews)
    {
        if (![view isKindOfClass:[UILabel class]])
        {
             [view removeFromSuperview];
        }
    }
    cell.backgroundColor=[UIColor whiteColor];
    
    if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"]!=[NSNull null])
    {
        cell.summaryText =[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification"];
        cell.summaryLabel.delegate = self;
    }//END if ([[self._notifications objectAtIndex:indexPath.row] valueForKey:@"noti
    
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

    }//END if ([[self._notifications objectAtIndex:indexPath.row] valueForK
    
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
        }//END if ([[[self._notifications objectAtIndex:indexPath
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==2)
        {
            img_vw.image=[UIImage imageNamed:@"S11_calendarIcon.png"];
            imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
        }//END if ([[[self._notifications objectAt
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==3)
        {
            img_vw.image=[UIImage imageNamed:@"S11_clockLogo.png"];
            imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
        }//END if ([[[self._notifications objectAt
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==4)
        {
            img_vw.image=[UIImage imageNamed:@"S11_locationIcon.png"];
             imgSize=[img_vw.image size];
            img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
        }//END if ([[[self._notifications objectAt
        
        if ([[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==11 || [[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"notification_type"] intValue]==6)
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
            img_vw.frame=CGRectMake(10, 10, imgSize.width,imgSize.height);
            
           // self.img_vw.image=[UIImage imageNamed:@"S11_picBox.png"];
        }//END if ([[[self._notifications objectAt
    
    }//END if ([[[self._notifications objectAtIndex:indexPat
    
   /*if (notif.type==1 || notif.type==5 || notif.type==6 || notif.type==9 || notif.type==10 || notif.type==11)
    {
        [cell addSubview:Borderimg_vw];
    }//END  if (notif.type==1)
    
    if (notif.type==7)
    {
        [cell addSubview:Borderimg_vw];
        
        UIButton *btngoing=[UIButton buttonWithType:UIButtonTypeCustom];
        btngoing.frame=CGRectMake(150, 85, 71, 25);
        [btngoing setBackgroundImage:[UIImage imageNamed:@"S11_goingButton.png"] forState:UIControlStateNormal];
        btngoing.tag=indexPath.row;
        
        UIButton *btnnotgoing=[UIButton buttonWithType:UIButtonTypeCustom];
        btnnotgoing.frame=CGRectMake(230, 85, 71, 25);
        [btnnotgoing setBackgroundImage:[UIImage imageNamed:@"S11_notGoingButton.png"] forState:UIControlStateNormal];
        btnnotgoing.tag=indexPath.row;
        
        [cell addSubview:btnnotgoing];
        [cell addSubview:btngoing];
        
    }//END  if (notif.type==7)
    
    if (notif.type==11)
    {
        [cell addSubview:Borderimg_vw];
        
        UIButton *btnaccept=[UIButton buttonWithType:UIButtonTypeCustom];
        btnaccept.frame=CGRectMake(150, 85, 71, 25);
        [btnaccept setBackgroundImage:[UIImage imageNamed:@"S11_joinAcceptButton.png"] forState:UIControlStateNormal];
        btnaccept.tag=indexPath.row;
        
        UIButton *btndecline=[UIButton buttonWithType:UIButtonTypeCustom];
        btndecline.frame=CGRectMake(230, 85, 71, 25);
        [btndecline setBackgroundImage:[UIImage imageNamed:@"S11_joinDeclineButton.png"] forState:UIControlStateNormal];
        btndecline.tag=indexPath.row;
        
        [cell addSubview:btndecline];
        [cell addSubview:btnaccept];
        
    }//END  if (notif.type==7)
*/
    
    UIButton *btnindicator=[UIButton buttonWithType:UIButtonTypeCustom];
    btnindicator.frame=CGRectMake(276, 20, 38, 38);
    [btnindicator setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
    [btnindicator setBackgroundColor:[UIColor clearColor]];
    
    [cell.contentView addSubview:btnindicator];
    [cell.contentView addSubview:img_vw];
    
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

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *description = [self._notifications objectAtIndex:indexPath.row];
    NSLog(@"description=%@",description);
}*/

-(void)RemoveNotification:(NSString *)lstrid
{
    [self startAnimation];
    
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://%@/deletenotification.json?logged_in_user_id=%@&notification_id=%@",ProductionServer,[[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"],lstrid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

-(void)SetNotificationStatus:(NSString *)lstrid
{
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://%@/notification_read.json?id=%i&read_notification=1",ProductionServer,[lstrid intValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
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
    [self RemoveNotification:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]];
    
    [self SetNotificationStatus:[[self._notifications objectAtIndex:indexPath.row] valueForKey:@"id"]];
    
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
    }
    
    [self._notifications removeObjectAtIndex:indexPath.row];
    
    NSDictionary *dictcount=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"],@"Waiting_On_You_Count", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:dictcount];
    
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] IncreaseBadgeIcon];
    
     [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];
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
