
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#define kSortByDistance 1
#define kSortByDegree 2
#define kSortByTime 3
#define kSortOrganizesByYou 4
#define kSortCompletedByTime 5
@implementation SectionHeaderView


@synthesize activitytitleLabel, delegate, section,playerId;


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
        playerId=detailSectionInfo.organizerId;
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
        CGRect activityLabelFrame = CGRectMake(45,20-2,210,22);
        activitytitleLabel = [[UILabel alloc] initWithFrame:activityLabelFrame];
        activitytitleLabel.text = detailSectionInfo.activityName;
        activitytitleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:20];
        activitytitleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        activitytitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:activitytitleLabel];
        
        // Organizer name
#if 1
        UIButton *ogButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        ogButton.frame = CGRectMake(45,45-1,210,16);
        [ogButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
        ogButton.tag=[[NSString stringWithFormat:@"222%d",section]intValue];
        
        NSString *OrganizerName=nil;
        if(sortingPattern==kSortOrganizesByYou)
            OrganizerName=@"Organized by You";
        
        else
            OrganizerName=detailSectionInfo.organizerName;
        
        [ogButton setTitle:OrganizerName forState:UIControlStateNormal];
        ogButton.titleLabel.textAlignment=UITextAlignmentLeft;
        [ogButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];
        ogButton.tag=((section & 0xFFFF) << 16) |
        (sortingPattern & 0xFFFF);

        ogButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        ogButton.backgroundColor=[UIColor clearColor];
        [ogButton addTarget:self action:@selector(tapViewAll:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGSize  size = [OrganizerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
        NSLog(@"width=%f",size.width);
        ogButton.frame=CGRectMake(45, 45-1, size.width, 16);

        [self addSubview:ogButton];
        
        ogButton.enabled=NO;
        
        
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        NSLog(@"playerId=%d",playerId);
        if(sortingPattern==kSortCompletedByTime){
            if([SOC.loggedInUser.idSoc intValue]!=playerId){
            ogButton.enabled=YES;
            }
        }
        else if(sortingPattern!=kSortOrganizesByYou)
            ogButton.enabled=YES;

#else
        CGRect organizerLabelRect=CGRectMake(45,45-1,210,16);
        UILabel *oglabel=[[UILabel alloc] initWithFrame:organizerLabelRect];
        oglabel.textAlignment=UITextAlignmentLeft;
        oglabel.tag=[[NSString stringWithFormat:@"222%d",section]intValue];
        oglabel.text=detailSectionInfo.organizerName;
        oglabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        oglabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        oglabel.backgroundColor=[UIColor clearColor];
        CGSize  size = [detailSectionInfo.organizerName sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
        NSLog(@"width=%f",size.width);
        oglabel.frame=CGRectMake(45, 45-1, size.width, 16);

        [self addSubview:oglabel];
        [oglabel release];
#endif
        // Checking the size of the organizer name
        
        // Use the appropriate degree of seperation icon
        if(detailSectionInfo.DOS==1) {
            UIImageView *DOSImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_dos1.png"]];
            DOSImgView.frame=CGRectMake(55+size.width-3, 45, 21, 12);
            [self addSubview:DOSImgView];
        }
        else if(detailSectionInfo.DOS==2) {
            UIImageView *DOSImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_dos2.png"]];
            DOSImgView.frame=CGRectMake(55+size.width-3, 45, 21, 12);
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
        
        // Add plural logic here
        if ([detailSectionInfo.goingCount isEqualToString:@"1"])
            label.text=[NSString stringWithFormat:@"%@ person going",detailSectionInfo.goingCount];
        else
            label.text=[NSString stringWithFormat:@"%@ people going",detailSectionInfo.goingCount];
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
                CGRect goingLabelRect=CGRectMake(160,72,143,15);
                UILabel *goingLabel=[[UILabel alloc] initWithFrame:goingLabelRect];
                goingLabel.textAlignment=UITextAlignmentRight;
                
                // Add plural logic here
                if(detailSectionInfo.DOS1==1)
                    goingLabel.text=[NSString stringWithFormat:@"%d friend going",detailSectionInfo.DOS1];
                else
                    goingLabel.text=[NSString stringWithFormat:@"%d friends going",detailSectionInfo.DOS1];
                goingLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                goingLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
                goingLabel.backgroundColor=[UIColor clearColor];
                
                [self addSubview:goingLabel];
                [goingLabel release];
            }
                break;
                
            case kSortByTime:
            case kSortCompletedByTime:
            case kSortOrganizesByYou:
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
        
        if(sortingPattern!=kSortCompletedByTime){
        UIButton *disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(276, 18, 38, 38);
        disclosureButton.tag=[[NSString stringWithFormat:@"555%d",section]intValue];
        [disclosureButton setImage:[UIImage imageNamed:
                                    @"S04_moreinfoarrow.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"S04_moreinfoarrow.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(detailActivity:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] 
                             initWithFrame:CGRectMake(285.0f, 27.0f, 20.0f, 20.0f)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.tag=[[NSString stringWithFormat:@"666%d",section]intValue];
        [activityIndicator setHidden:YES];
        [self addSubview:activityIndicator];
        // release it
        [activityIndicator release];
        }
        

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
#if 0
    
     CGPoint translate = [sender locationInView:self.superview];
     NSLog(@"Start Point_X=%f,Start Point_Y=%f",translate.x,translate.y);
    NSString *nameLabelValue=[NSString stringWithFormat:@"222%d",section];
    CGRect frame=[(UILabel*)[self viewWithTag:[nameLabelValue intValue]]frame];
    
    if(CGRectContainsPoint(frame,translate)){
        [delegate PushToListOfActivitiesOrUserProfile:section];
    }
    else{
        [self toggleOpenWithUserAction:YES];
        
    }
#endif
}

-(void)tapViewAll:(UIButton*)sender{
#if 0
    NSUInteger arrowSection = ((sender.tag >> 16) & 0xFFFF);
    NSUInteger row     = (sender.tag & 0xFFFF);
    NSLog(@"row=%d,arrowSection=%d",row,arrowSection);
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    NSLog(@"playerId=%d",playerId);
    if(row==kSortCompletedByTime){
        if([SOC.loggedInUser.idSoc intValue]!=playerId){
            [delegate PushToListOfActivitiesOrUserProfile:section];
        }
    }
    else if(row!=kSortOrganizesByYou)
        [delegate PushToListOfActivitiesOrUserProfile:section];
    
#endif
    [delegate PushToListOfActivitiesOrUserProfile:section];
}

-(void)detailActivity:(id)sender{
    NSLog(@"detailActivity");
    if ([delegate respondsToSelector:@selector(selectActivityView:)]) {
        NSString *arrowButtonValue=[NSString stringWithFormat:@"555%d",section];
        [(UIButton*)[self viewWithTag:[arrowButtonValue intValue]] setHidden:YES];

        NSString *spinnerValue=[NSString stringWithFormat:@"666%d",section];

        UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self viewWithTag:[spinnerValue intValue]];
        [tmpimg startAnimating];
        [delegate selectActivityView:section];

    }

}

-(void)spinnerCloseAndIfoDisclosureButtonUnhide{
    
    NSString *arrowButtonValue=[NSString stringWithFormat:@"555%d",section];
    [(UIButton*)[self viewWithTag:[arrowButtonValue intValue]] setHidden:NO];
    
    NSString *spinnerValue=[NSString stringWithFormat:@"666%d",section];
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self viewWithTag:[spinnerValue intValue]];
    [tmpimg stopAnimating];
    [tmpimg setHidden:YES];

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
