
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"
@implementation SectionHeaderView


@synthesize activitytitleLabel, disclosureButton, delegate, section;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame detailSectionInfo:(InfoActivityClass*)detailSectionInfo section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
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
        
        CGRect activityLabelFrame = CGRectMake(45,20,210,20);
        activitytitleLabel = [[UILabel alloc] initWithFrame:activityLabelFrame];
        activitytitleLabel.text = detailSectionInfo.activityName;
        activitytitleLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:20];
        activitytitleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        activitytitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:activitytitleLabel];
        
        
        CGRect organizerLabelRect=CGRectMake(45,45,210,15);
        UILabel *oglabel=[[UILabel alloc] initWithFrame:organizerLabelRect];
        oglabel.textAlignment=UITextAlignmentLeft;
        oglabel.text=[NSString stringWithFormat:@"by %@",detailSectionInfo.organizerName];
        oglabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
        oglabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        oglabel.backgroundColor=[UIColor clearColor];
        
        [self addSubview:oglabel];
        [oglabel release];
        CGSize size = [[NSString stringWithFormat:@"by %@",detailSectionInfo.organizerName] sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
		NSLog(@"width=%f",size.width);

        UIImageView *DOSImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_dos.png"]];
        DOSImgView.frame=CGRectMake(55+size.width-5, 40, 26, 22);
        [self addSubview:DOSImgView];
        
        
        CGRect degreeLabelRect=CGRectMake(45+size.width+32-3,41,5,10);
        UILabel *degreelabel=[[UILabel alloc] initWithFrame:degreeLabelRect];
        degreelabel.textAlignment=UITextAlignmentLeft;
        degreelabel.text=[NSString stringWithFormat:@"%@",detailSectionInfo.DOS];
        degreelabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
        degreelabel.textColor=[SoclivityUtilities returnTextFontColor:5];
        degreelabel.backgroundColor=[UIColor clearColor];
        
        [self addSubview:degreelabel];
        [degreelabel release];

        
        UIImageView *DotImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_dot.png"]];
        DotImgView.frame=CGRectMake(45+size.width+32+10, 50, 6, 6);
        [self addSubview:DotImgView];

        
        CGRect distanceLabelRect=CGRectMake(45+size.width+32+25,45,180,15);
        UILabel *mileslabel=[[UILabel alloc] initWithFrame:distanceLabelRect];
        mileslabel.textAlignment=UITextAlignmentLeft;
        mileslabel.text=[NSString stringWithFormat:@"%@ miles",detailSectionInfo.distance];
        mileslabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
        mileslabel.textColor=[SoclivityUtilities returnTextFontColor:1];
        mileslabel.backgroundColor=[UIColor clearColor];
        
        [self addSubview:mileslabel];
        [mileslabel release];

        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 66, 320, 1)];
        v.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_lightdivider.png"]];
        [self addSubview:v];	
        [v release];
        
        CGRect countLabelRect=CGRectMake(15,74,180,15);
        UILabel *label=[[UILabel alloc] initWithFrame:countLabelRect];
        label.textAlignment=UITextAlignmentLeft;
        label.text=[NSString stringWithFormat:@"%@ People Going",detailSectionInfo.goingCount];
        label.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
        label.textColor=[SoclivityUtilities returnTextFontColor:1];
        label.backgroundColor=[UIColor clearColor];
        
        [self addSubview:label];
        [label release];
        
        
        v = [[UIView alloc] initWithFrame:CGRectMake(0,97, 320, 1)];
        v.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_darkdivider.png"]];
        [self addSubview:v];	
        [v release];


        
#if 0        
        // Create and configure the disclosure button.
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(0.0, 5.0, 35.0, 35.0);
        [disclosureButton setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
        
#endif        // Set the colors for the gradient layer.
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:1.0 green:0.99 blue:1.0 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:1.0 green:1.0 blue:0.99 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
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
    [disclosureButton release];
    [super dealloc];
}


@end
