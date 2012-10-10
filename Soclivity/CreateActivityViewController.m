//
//  CreateActivityViewController.m
//  Soclivity
//
//  Created by Kanav on 10/8/12.
//
//

#import "CreateActivityViewController.h"
#import "SoclivityUtilities.h"
#import "UIViewController+MJPopupViewController.h"
@interface CreateActivityViewController ()

@end

@implementation CreateActivityViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setValue:Nil forKey:@"ActivityDate"];

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundtap:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];

    createActivtyStaticLabel.text=@"Create Activity";
    
    createActivtyStaticLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    createActivtyStaticLabel.textColor=[UIColor whiteColor];
    createActivtyStaticLabel.backgroundColor=[UIColor clearColor];
    createActivtyStaticLabel.shadowColor = [UIColor blackColor];
    createActivtyStaticLabel.shadowOffset = CGSizeMake(0,-1);
    
    
    
    step1_of2Label.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    step1_of2Label.textColor=[UIColor whiteColor];
    step1_of2Label.backgroundColor=[UIColor clearColor];
    step1_of2Label.shadowColor = [UIColor blackColor];
    step1_of2Label.shadowOffset = CGSizeMake(0,-1);
    step1_of2Label.text=@"Step 1 of 2";
    
    
    
    UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    playButton.frame = CGRectMake(0,44,64,50);
    playButton.tag=kPlayActivity;
    [playButton setImage:[UIImage imageNamed:@"S06_play.png"] forState:UIControlStateNormal];
    
    
    
    [playButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    UIImageView *playTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    playTickImageView.frame=CGRectMake(20,54, 16, 15);
    playTickImageView.tag=kPlayTickImage;
    [self.view addSubview:playTickImageView];
    
    
    CGRect playTypeLabelRect=CGRectMake(0,73,55,16);
    UILabel *playTypeLabel=[[UILabel alloc] initWithFrame:playTypeLabelRect];
    playTypeLabel.textAlignment=UITextAlignmentLeft;
    playTypeLabel.text=[NSString stringWithFormat:@"Play"];
    playTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    playTypeLabel.textColor=[UIColor whiteColor];
    playTypeLabel.textAlignment = UITextAlignmentCenter;
    playTypeLabel.tag=kPlayLabelText;
    playTypeLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:playTypeLabel];
    
    
    [playTickImageView release];
    [playTypeLabel release];
    UIButton *eatButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    eatButton.frame = CGRectMake(64,44,64,50);
    eatButton.tag=kEatActivity;
    [eatButton setImage:[UIImage imageNamed:@"S06_eat.png"] forState:UIControlStateNormal];
    
    [eatButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eatButton];
    
    UIImageView *eatTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    eatTickImageView.frame=CGRectMake(84, 54, 16, 15);
    eatTickImageView.tag=kEatTickImage;
    [self.view addSubview:eatTickImageView];
    
    
    CGRect eatTypeLabelRect=CGRectMake(64,74,55,15);
    UILabel *eatTypeLabel=[[UILabel alloc] initWithFrame:eatTypeLabelRect];
    eatTypeLabel.textAlignment=UITextAlignmentLeft;
    eatTypeLabel.text=[NSString stringWithFormat:@"Eat"];
    eatTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    eatTypeLabel.textColor=[UIColor whiteColor];
    eatTypeLabel.textAlignment = UITextAlignmentCenter;
    eatTypeLabel.tag=kEatLabelText;
    eatTypeLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:eatTypeLabel];
    
    [eatTickImageView release];
    [eatTypeLabel release];
    
    
    
    UIButton *seeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    seeButton.frame = CGRectMake(128,44,64,50);
    seeButton.tag=kSeeActivity;
    [seeButton setImage:[UIImage imageNamed:@"S06_see.png"] forState:UIControlStateNormal];
    
    [seeButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seeButton];
    
    UIImageView *seeTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    seeTickImageView.frame=CGRectMake(148, 54, 16, 15);
    seeTickImageView.tag=kSeeTickImage;
    [self.view addSubview:seeTickImageView];
    
    
    CGRect seeTypeLabelRect=CGRectMake(128,74,55,15);
    UILabel *seeTypeLabel=[[UILabel alloc] initWithFrame:seeTypeLabelRect];
    seeTypeLabel.textAlignment=UITextAlignmentLeft;
    seeTypeLabel.text=[NSString stringWithFormat:@"See"];
    seeTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    seeTypeLabel.textColor=[UIColor whiteColor];
    seeTypeLabel.textAlignment = UITextAlignmentCenter;
    seeTypeLabel.tag=kSeeLabelText;
    seeTypeLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:seeTypeLabel];
    
    [seeTickImageView release];
    [seeTypeLabel release];
    
    UIButton *createButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    createButton.frame = CGRectMake(192,44,64,50);
    createButton.tag=kCreateActivity;
    [createButton setImage:[UIImage imageNamed:@"S06_create.png"] forState:UIControlStateNormal];
    
    [createButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
    
    UIImageView *createTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    createTickImageView.frame=CGRectMake(212, 54, 16, 15);
    createTickImageView.tag=kCreateTickImage;
    [self.view addSubview:createTickImageView];
    
    
    CGRect createTypeLabelRect=CGRectMake(192,74,55,15);
    UILabel *createTypeLabel=[[UILabel alloc] initWithFrame:createTypeLabelRect];
    createTypeLabel.textAlignment=UITextAlignmentLeft;
    createTypeLabel.text=[NSString stringWithFormat:@"Create"];
    createTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    createTypeLabel.textColor=[UIColor whiteColor];
    createTypeLabel.textAlignment = UITextAlignmentCenter;
    createTypeLabel.tag=kCreateLabelText;
    createTypeLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:createTypeLabel];
    
    [createTickImageView release];
    [createTypeLabel release];
    
    UIButton *learnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    learnButton.frame = CGRectMake(256,44,64,50);
    learnButton.tag=kLearnActivity;
    [learnButton setImage:[UIImage imageNamed:@"S06_learn.png"] forState:UIControlStateNormal];
    
    [learnButton addTarget:self action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:learnButton];
    
    UIImageView *learnTickImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04.1_activityTypeCheck.png"]];
    learnTickImageView.frame=CGRectMake(276, 54, 16, 15);
    learnTickImageView.tag=kLearnTickImage;
    [self.view addSubview:learnTickImageView];
    
    
    CGRect learnTypeLabelRect=CGRectMake(256,74,55,15);
    UILabel *learnTypeLabel=[[UILabel alloc] initWithFrame:learnTypeLabelRect];
    learnTypeLabel.textAlignment=UITextAlignmentLeft;
    learnTypeLabel.text=[NSString stringWithFormat:@"Learn"];
    learnTypeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    learnTypeLabel.textColor=[UIColor whiteColor];
    learnTypeLabel.textAlignment = UITextAlignmentCenter;
    learnTypeLabel.tag=kLearnLabelText;
    learnTypeLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:learnTypeLabel];
    
    [learnTickImageView release];
    [learnTypeLabel release];
    
    
    [self updateActivityType:kPlayActivity];
    
    
    activityNameLabel.font = [UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    activityNameLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    activityNameLabel.text=@"Activity Name";

    activityNameTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    activityNameTextField.textColor=[SoclivityUtilities returnTextFontColor:1];
    
    
    descriptionTextView.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    descriptionTextView.textColor=[SoclivityUtilities returnTextFontColor:5];
    descriptionTextView.backgroundColor=[UIColor clearColor];

    descriptionTextView.autocorrectionType=UITextAutocorrectionTypeNo;
    descriptionTextView.textAlignment=UITextAlignmentLeft;
    descriptionTextView.editable = YES;
    descriptionTextView.delegate = self;
    descriptionTextView.contentSize = descriptionTextView.frame.size;
    
    
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, descriptionTextView.frame.size.width - 20.0, 34.0)];
    [placeholderLabel setText:@"Description!"];
    // placeholderLabel is instance variable retained by view controller
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    placeholderLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:13];
    placeholderLabel.textColor=[SoclivityUtilities returnTextFontColor:1];
    
    // textView is UITextView object you want add placeholder text to
    [descriptionTextView addSubview:placeholderLabel];
    
    
    totalCountTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    totalCountTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    totalCountTextLabel.backgroundColor=[UIColor clearColor];

    countTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    countTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    countTextLabel.backgroundColor=[UIColor clearColor];
    
    
    
    
    pickADayButton.titleLabel.textAlignment=UITextAlignmentLeft;
    pickADayButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    pickADayButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    [pickADayButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [pickADayButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];

    
    pickATimeButton.titleLabel.textAlignment=UITextAlignmentLeft;
    pickATimeButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    pickATimeButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    [pickATimeButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [pickATimeButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];

    
    publicPrivateButton.titleLabel.textAlignment=UITextAlignmentLeft;
    publicPrivateButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    publicPrivateButton.titleLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    [publicPrivateButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateNormal];
    [publicPrivateButton setTitleColor:[SoclivityUtilities returnTextFontColor:5] forState:UIControlStateHighlighted];

    capacityTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:14];
    capacityTextField.textColor=[SoclivityUtilities returnTextFontColor:1];
    capacityTextField.placeholder=@"Capacity";


    
    blankTextLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:10];
    blankTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    blankTextLabel.backgroundColor=[UIColor clearColor];

   


    // Do any additional setup after loading the view from its nib.
}

-(IBAction)pickADateButtonPressed:(id)sender{
    
    
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] initWithNibName:@"MJDetailViewController" bundle:nil];
    detailViewController.delegate=self;
    detailViewController.type=PickADateViewAnimation;
    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomBottom];

}

-(IBAction)pickATimeButtonPressed:(id)sender{
    MJDetailViewController *detailViewController = [[MJDetailViewController alloc] initWithNibName:@"MJDetailViewController" bundle:nil];
    detailViewController.delegate=self;
    detailViewController.type=PickATimeViewAnimation;
    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomBottom];
    
}
-(IBAction)publicOrPrivateActivityButtonPressed:(id)sender{
    
}

-(IBAction)pickALocationButtonPressed:(id)sender{
    
}

-(void)backgroundtap:(UITapGestureRecognizer*)sender{
    
    [activityNameTextField resignFirstResponder];
    [capacityTextField resignFirstResponder];
    CGPoint translate = [sender locationInView:self.view.superview];
   NSLog(@"Start Point_X=%f,Start Point_Y=%f",translate.x,translate.y);
}

-(void)updateActivityType:(NSInteger)type{
    
    activityType=type;
    switch (activityType) {
            
    case kPlayActivity:
    {
        [(UILabel*)[self.view viewWithTag:kPlayLabelText] setAlpha:1.0f];
        [(UIImageView*)[self.view viewWithTag:kPlayTickImage]setAlpha:1.0f];
        
        [(UILabel*)[self.view viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:10];
        
    }
        break;
        
        
        
    case kEatActivity:
    {
        [(UILabel*)[self.view viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kEatLabelText] setAlpha:1.0f];
        [(UIImageView*)[self.view viewWithTag:kEatTickImage]setAlpha:1.0f];
        
        [(UILabel*)[self.view viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:11];
        
    }
        break;
        
    case kSeeActivity:
    {
        [(UILabel*)[self.view viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kSeeLabelText] setAlpha:1.0f];
        [(UIImageView*)[self.view viewWithTag:kSeeTickImage]setAlpha:1.0f];
        
        [(UILabel*)[self.view viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:12];
        
        
        
        
        
    }
        break;
    case kCreateActivity:
    {
        [(UILabel*)[self.view viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kCreateLabelText] setAlpha:1.0f];
        [(UIImageView*)[self.view viewWithTag:kCreateTickImage]setAlpha:1.0f];
        
        [(UILabel*)[self.view viewWithTag:kLearnLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kLearnTickImage]setAlpha:0.3f];
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:13];
        
        
        
        
        
    }
        break;
    case kLearnActivity:
    {
        [(UILabel*)[self.view viewWithTag:kPlayLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kPlayTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kEatLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kEatTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kSeeLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kSeeTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kCreateLabelText] setAlpha:0.3f];
        [(UIImageView*)[self.view viewWithTag:kCreateTickImage]setAlpha:0.3f];
        
        [(UILabel*)[self.view viewWithTag:kLearnLabelText] setAlpha:1.0f];
        [(UIImageView*)[self.view viewWithTag:kLearnTickImage]setAlpha:1.0f];
        
        backgroundView.backgroundColor=[SoclivityUtilities returnBackgroundColor:14];
        
        
    }
        break;
        
        
        
    default:
        break;
}
}
-(void)activityButtonPressed:(UIButton*)sender{
    [self updateActivityType:sender.tag];
}

-(IBAction)crossClicked:(id)sender{
    
    [delegate cancelCreateActivityEventScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define kOFFSET_FOR_KEYBOARD 20.0

#pragma mark -
#pragma mark UITextViewDelegate Methods

-(void)textViewDidChange:(UITextView *)textView{
    
    if(![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
    else{
        placeholderLabel.hidden = YES;
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self setViewMovedUp:YES];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	BOOL flag = NO;
	
	
	if ([text isEqualToString:@"\n"]){
		[descriptionTextView resignFirstResponder];
        return NO;
	}
	
	if([text length] == 0)
	{
		if([textView.text length] != 0)
		{
			flag = YES;
			NSString *Temp = countTextLabel.text;
			int j = [Temp intValue];
            NSLog(@"j=%d",j);
            
			j = j-1 ;
			countTextLabel.text= [[NSString alloc] initWithFormat:@"%i/",j];

			return YES;
		}
		else {
			return NO;
		}
		
		
	}
	else if([[textView text] length] > 159)
	{
		return NO;
	}
	if(flag == NO)
	{
        NSLog(@"[descriptionTextView.text length]=%i",[descriptionTextView.text length]);
		countTextLabel.text= [[NSString alloc] initWithFormat:@"%i/",[descriptionTextView.text length]+1];
		
		
	}
	
	
	return YES;
	
	
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
	NSLog(@"The string is %@",textView.text);
	
    
    if (![textView hasText]) {
        placeholderLabel.hidden = NO;
    }
	[self setViewMovedUp:NO];
	[descriptionTextView resignFirstResponder];
    
    
}


#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //set color for placeholder text
    textField.textColor = [SoclivityUtilities returnTextFontColor:1];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
    if(textField==capacityTextField){

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        CGRect rect = CGRectMake(0, -175, 320, 480);
        self.view.frame = rect;
        [UIView commitAnimations];

        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
    
    // Checking the name field
    if(textField == activityNameTextField) {
        // Check length of the name
        NSInteger length;
        length = [textField.text length];
        if (length==0)
            validName = NO;
        else
            validName = YES;
    }
    
    NSLog(@"textFieldShouldReturn");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.view.frame = rect;
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
     return NO;
}
#pragma mark -
#pragma mark PopUpPickerView Methods


- (void)dismissPickerFromView:(id)sender{
 [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void)pickADateSelectionDone:(NSString*)activityDate{
    
    CGSize  size = [activityDate sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:14]];
    pickADayButton.frame=CGRectMake(65, 268, size.width, 44);
    [pickADayButton setTitle:activityDate forState:UIControlStateNormal];
    [pickADayButton setTitle:activityDate forState:UIControlStateHighlighted];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];

    
}
-(void)pickATimeSelectionDone:(NSString*)activityTime{
    
    CGSize  size = [activityTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:14]];
    pickATimeButton.frame=CGRectMake(65, 268, size.width, 44);
    [pickATimeButton setTitle:activityTime forState:UIControlStateNormal];
    [pickATimeButton setTitle:activityTime forState:UIControlStateHighlighted];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}



@end
