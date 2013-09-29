//
//  EventDetailView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDetailView.h"
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"
#import "DetailInfoActivityClass.h"
@implementation EventDetailView
@synthesize activityObject;
- (id)initWithFrame:(CGRect)frame info:(InfoActivityClass*)info
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"EventDetailView" owner:self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
        activityTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
        activityTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        whenTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
        whenTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        whereTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
        whereTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        whatTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
        whatTextLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        goingCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        peopleYouKnowCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        peopleYouKnowCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        peopleYouMayKnowCountLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
        peopleYouMayKnowCountLabel.textColor=[SoclivityUtilities returnTextFontColor:1];




  switch (info.type) {
            case 1:
            {
                activityBarView.image=[UIImage imageNamed:@"S5-orange-bar.png"];
                activityTextLabel.text=@"PLAY";

                
            }
                break;
            case 2:
            {
                activityBarView.image=[UIImage imageNamed:@"S5-orange-bar.png"];
                activityTextLabel.text=@"EAT";

                
            }
                break;
            case 3:
            {
                activityBarView.image=[UIImage imageNamed:@"S5-orange-bar.png"];
                activityTextLabel.text=@"SEE";

                
            }
                break;
            case 4:
            {
                activityBarView.image=[UIImage imageNamed:@"S5-orange-bar.png"];
                activityTextLabel.text=@"CREATE";

                
            }
                break;
            case 5:
            {
                activityBarView.image=[UIImage imageNamed:@"S5-orange-bar.png"];
                activityTextLabel.text=@"LEARN";
            }
                break;

                
                
        }

    
    
        whenTextLabel.text=info.dateAndTime;
    for(DetailInfoActivityClass *detail in info.quotations){
        whereTextLabel.text=[NSString stringWithFormat:@"%@ ,%@ miles",detail.location,info.distance];
        peopleYouKnowCountLabel.text=[NSString stringWithFormat:@"%d",detail.DOS_1];
        peopleYouMayKnowCountLabel.text=[NSString stringWithFormat:@"%d",detail.DOS_2];
        }

    whatTextLabel.text=info.activityName;
    
    CGRect organizerLabelRect=CGRectMake(70,230,170,15);
    UILabel *oglabel=[[UILabel alloc] initWithFrame:organizerLabelRect];
    oglabel.textAlignment=NSTextAlignmentLeft;
    oglabel.text=[NSString stringWithFormat:@"%@",info.organizerName];
    oglabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    oglabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    oglabel.backgroundColor=[UIColor clearColor];
    
    [self addSubview:oglabel];
    
    
    CGSize size = [[NSString stringWithFormat:@"%@",info.organizerName] sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
    NSLog(@"width=%f",size.width);
    oglabel.frame=CGRectMake(70, 230, size.width,15);
    [oglabel release];
    UIImageView *createdImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S5_created-this-event.png"]];
    createdImgView.frame=CGRectMake(70+size.width+5, 235, 83, 9);
    [self addSubview:createdImgView];

    goingCountLabel.text=info.goingCount;
    joinButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
    joinButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    [joinButton setTitle:@"Join" forState:UIControlStateNormal];
        
    }
    return self;
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
