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
@synthesize espressos = _espressos,delegate;
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
        waitingTableView.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
        waitingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        waitingTableView.separatorColor=[UIColor clearColor];
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
    return [AttributedTableViewCell heightForCellWithText:notif.notificationString];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AttributedTableViewCell *cell = (AttributedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AttributedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor=[UIColor whiteColor];
    NotificationClass *notif=[self.espressos objectAtIndex:indexPath.row];
    cell.summaryText = notif.notificationString;
    cell.summaryLabel.delegate = self;
    cell.summaryLabel.userInteractionEnabled = YES;
    
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
