//
//  BirthdayPickerView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirthdayPickerView.h"
#define kDatePicker 123
#define kToolBar 124
@implementation BirthdayPickerView
@synthesize delegate;


#if 0
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#endif
-(void)dealloc{
    [super dealloc];
    [birthDayPicker release];
}
- (id)init {
    
    self = [super init];
    if (self) {
        
        birthDayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,44, 320, 216)];
        birthDayPicker.datePickerMode = UIDatePickerModeDate;
        birthDayPicker.tag=kDatePicker;
        [birthDayPicker setHidden:YES];
        [self addSubview:birthDayPicker];
        [birthDayPicker setEnabled:YES];
        

        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
        keyboardToolbar.barStyle = UIBarStyleDefault;
        keyboardToolbar.tintColor = [UIColor clearColor];
        keyboardToolbar.tag=kToolBar;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPicker:)];
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *items = [[NSArray alloc] initWithObjects:cancelButtonItem,spacer,barButtonItem, nil];	
        [keyboardToolbar setItems:items animated:YES];
        
        [items release];
        [barButtonItem release];
        [spacer release];
        [cancelButtonItem release];
        [keyboardToolbar setHidden:YES];
        [self addSubview:keyboardToolbar];
        [self insertSubview:birthDayPicker aboveSubview:keyboardToolbar];
        //[birthDayPicker release];
        [keyboardToolbar release];
		[self setHidden:YES];
    }
    return self;
}
- (void) ShowBirthDayView:(CGFloat)height
{
	[self setFrame:CGRectMake(0, height, 320, 260)];
	[self setHidden:NO];
	
	birthDayPicker = (UIDatePicker *)[self viewWithTag:kDatePicker];
	[birthDayPicker setHidden:NO];
	UIToolbar *keyboardToolbar = (UIToolbar *)[self viewWithTag:kToolBar];
	[keyboardToolbar setHidden:NO];
	
}

- (void) HideView
{
	birthDayPicker = (UIDatePicker *)[self viewWithTag:kDatePicker];
	[birthDayPicker setHidden:YES];
	
	UIToolbar *keyboardToolbar = (UIToolbar *)[self viewWithTag:kToolBar];
	[keyboardToolbar setHidden:YES];
    
	[self setHidden:YES];
	// set frame of the footer.
	[self setFrame:CGRectMake(0, 0, 0, 0)];
}

-(void)hideKeyboard:(id)sender{
    
    [delegate dateSelected:[birthDayPicker date]];
}
-(void)cancelPicker:(id)sender{
    [delegate hideBirthdayPicker];
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
