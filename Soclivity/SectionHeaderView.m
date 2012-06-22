
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"

#define kSortByDistance 1
#define kSortByDegree 2
#define kSortByTime 3
@implementation SectionHeaderView


@synthesize activitytitleLabel, delegate, section;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame detailSectionInfo:(InfoActivityClass*)detailSectionInfo section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate sortingPattern:(NSInteger)sortingPattern{
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        
        UIView *touchAllowedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 94)];
        [self addSubview:touchAllowedView];
        [touchAllowedView release];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [touchAllowedView addGestureRecognizer:tapGesture];
        [tapGesture release];

        delegate = aDelegate;        
        self.userInteractionEnabled = YES;
        
        
        // Create and configure the title label.
        section = sectionNumber;
        
        UIImageView *activityTypeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 66)];
        switch (detailSectionInfo.type) {
            case 1:
            {
                activityTypeImageView.image=[UIImage imageNamed:@"S04_play.png"];
            }
                break;
            case 2:
            {
                activityTypeImageView.image=[UIImage imageNamed:@"S04_eat.png"];
                
            }
                break;
            case 3:
            {
                activityTypeImageView.image=[UIImage imageNamed:@"S04_see.png"];
                
            }
                break;
            case 4:
            {
                activityTypeImageView.image=[UIImage imageNamed:@"S04_create.png"];
                
            }
                break;
            case 5:
            {
                activityTypeImageView.image=[UIImage imageNamed:@"S04_learn.png"];
                
            }
                break;
                
            default:
                break;
        }
        [self addSubview:activityTypeImageView];
        
        // Activity name
        CGRect activityLabelFrame = CGRectMake(45,20,210,20);
        activitytitleLabel = [[UILabel alloc] initWithFrame:activityLabelFrame];
        activitytitleLabel.text = detailSectionInfo.activityName;
        activitytitleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:20];
        activitytitleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        activitytitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:activitytitleLabel];
        
        // Organizer name
        CGRect organizerLabelRect=CGRectMake(45,45,210,15);
        UILabel *oglabel=[[UILabel alloc] initWithFrame:organizerLabelRect];
        oglabel.textAlignment=UITextAlignmentLeft;
        oglabel.text=detailSectionInfo.organizerName;
        oglabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        oglabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        oglabel.backgroundColor=[UIColor clearColor];
        [self addSubview:oglabel];
        [oglabel release];
        
        // Checking the size of the organizer name
        CGSize size = [detailSectionInfo.organizerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
		NSLog(@"width=%f",size.width);
        
        // Use the appropriate degree of seperation icon
        if(detailSectionInfo.DOS==1) {
            UIImageView *DOSImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_dos1.png"]];
            DOSImgView.frame=CGRectMake(55+size.width-3, 46, 21, 12);
            [self addSubview:DOSImgView];
        }
        else if(detailSectionInfo.DOS==2) {
            UIImageView *DOSImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_dos2.png"]];
            DOSImgView.frame=CGRectMake(55+size.width-3, 46, 21, 12);
            [self addSubview:DOSImgView];
        }
        
        // Line at the beginning of the middle section
        UIView* middleSectionTopDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 66, 320, 1)];
        middleSectionTopDivider.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_middleLine.png"]];
        [self addSubview:middleSectionTopDivider];
        [middleSectionTopDivider release];
        
        // Middle section
        UIView* middleSection=[[UIView alloc]initWithFrame:CGRectMake(0, 67, 320, 26)];
        middleSection.backgroundColor = [SoclivityUtilities returnTextFontColor:7];
        [self addSubview:middleSection];
        [middleSection release];
         
        // People going 
        CGRect countLabelRect=CGRectMake(15,72,180,15);
        UILabel *label=[[UILabel alloc] initWithFrame:countLabelRect];
        label.textAlignment=UITextAlignmentLeft;
        label.text=[NSString stringWithFormat:@"%@ People going",detailSectionInfo.goingCount];
        label.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
        label.textColor=[SoclivityUtilities returnTextFontColor:1];
        label.backgroundColor=[UIColor clearColor];
        [self addSubview:label];
        [label release];
        
        // Sorting information
        switch (sortingPattern) {
            case kSortByDistance:
            {
                
                CGRect distanceLabelRect=CGRectMake(160,72,143,15);
                UILabel *mileslabel=[[UILabel alloc] initWithFrame:distanceLabelRect];
                mileslabel.textAlignment=UITextAlignmentRight;
                mileslabel.text=[NSString stringWithFormat:@"%@ miles away",detailSectionInfo.distance];
                mileslabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                mileslabel.textColor=[SoclivityUtilities returnTextFontColor:1];
                mileslabel.backgroundColor=[UIColor clearColor];
                
                [self addSubview:mileslabel];
                [mileslabel release];
            }
                break;
                
            case kSortByDegree:
            {
                
            }
                break;
                
            case kSortByTime:
            {
                CGRect timeLabelRect=CGRectMake(160,72,143,15);
                UILabel *timelabel=[[UILabel alloc] initWithFrame:timeLabelRect];
                timelabel.textAlignment=UITextAlignmentRight;
                timelabel.text=[NSString stringWithFormat:@"%@",[SoclivityUtilities NetworkTime:detailSectionInfo]];
                timelabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                timelabel.textColor=[SoclivityUtilities returnTextFontColor:1];
                timelabel.backgroundColor=[UIColor clearColor];
                
                [self addSubview:timelabel];
                [timelabel release];
                
            }
                break;
                
        }
        
         //Divider at the bottom of the header section
        UIView* middleSectionBottomDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 92, 320, 1)];
        middleSectionBottomDivider.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_sectionDivider.png"]];
        [self addSubview:middleSectionBottomDivider];
        [middleSectionBottomDivider release];
        
        // Create and configure the disclosure button.
        UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(290.0, 30.0, 13.0, 18.0);
        [disclosureButton setImage:[UIImage imageNamed:@"S04_moreinfoarrow.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"S04_moreinfoarrow.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(detailActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
        
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        
    }
    
    return self;
}


-(IBAction)toggleOpen:(UITapGestureRecognizer*)sender {
    
    [self toggleOpenWithUserAction:YES];
    
     CGPoint translate = [sender locationInView:self.superview];
     NSLog(@"Start Point_X=%f,Start Point_Y=%f",translate.x,translate.y);
}

-(void)detailActivity:(id)sender{
    NSLog(@"detailActivity");
    if ([delegate respondsToSelector:@selector(selectActivityView:)]) {
        [delegate selectActivityView:section];
    }

}
-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    toggleAction = !toggleAction;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (toggleAction) {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [delegate sectionHeaderView:self sectionOpened:section];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [delegate sectionHeaderView:self sectionClosed:section];
            }
        }
    }
}


- (void)dealloc {
    
    [activitytitleLabel release];
    [super dealloc];
}


@end
