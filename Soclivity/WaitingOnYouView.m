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
@implementation WaitingOnYouView
@synthesize espressos = _espressos,delegate,img_vw;
- (id)initWithFrame:(CGRect)frame andNotificationsListArray:(NSArray*)andNotificationsListArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.espressos =[andNotificationsListArray retain];
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
    return [self.espressos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationClass *notif=[self.espressos objectAtIndex:indexPath.row];
    //return [AttributedTableViewCell heightForCellWithText:notif.notificationString];
    
    int rowheight=0;
    
    if (notif.type==7 || notif.type==11)
    {
        rowheight=120;
    }//END  if (notif.type==7)
    
    else{
        rowheight=85;
    }//END Else Statement
    
    return rowheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AttributedTableViewCell *cell = (AttributedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        cell = [[AttributedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   // }
    cell.backgroundColor=[UIColor whiteColor];
    NotificationClass *notif=[self.espressos objectAtIndex:indexPath.row];
    cell.hashCount=[notif.count intValue];
    cell.summaryText =notif.notificationString;
    cell.summaryLabel.delegate = self;
    cell.summaryLabel.userInteractionEnabled = YES;
    cell.summaryLabel.backgroundColor=[UIColor clearColor];
    
    cell.TimeText = notif.date;
    cell.lbltime.userInteractionEnabled = YES;
    cell.lbltime.backgroundColor=[UIColor clearColor];
    
    cell.notifytype=notif.type;
    
    CGSize imgSize;
    
    UIImageView *Borderimg_vw=[[UIImageView alloc] init];
    Borderimg_vw.frame=CGRectMake(15, 15, 37,37);
    Borderimg_vw.backgroundColor=[UIColor clearColor];
    Borderimg_vw.image=[UIImage imageNamed:@"S11_frame.png"];
    [Borderimg_vw setContentMode:UIViewContentModeScaleAspectFit];
    
    
    self.img_vw=[[UIImageView alloc] init];
    self.img_vw.backgroundColor=[UIColor clearColor];
    [self.img_vw setContentMode:UIViewContentModeScaleAspectFit];
    
    if (notif.type==1 || notif.type==5 || notif.type==6 || notif.type==9 || notif.type==10 || notif.type==11)
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

    
    self.img_vw.image=[UIImage imageNamed:notif.profileImage];
    imgSize=[self.img_vw.image size];
    self.img_vw.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
    
    UIButton *btnindicator=[UIButton buttonWithType:UIButtonTypeCustom];
    btnindicator.frame=CGRectMake(285, 20, 38, 38);
    [btnindicator setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
    [btnindicator setBackgroundColor:[UIColor clearColor]];
    
    [cell addSubview:btnindicator];
    [cell addSubview:self.img_vw];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *description = [self.espressos objectAtIndex:indexPath.row];
    NSLog(@"description=%@",description);
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
