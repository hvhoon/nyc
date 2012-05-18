//
//  AlertPrompt.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertPrompt.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlertPrompt

@synthesize textField;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 90, 254.0, 25.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
        theTextField.layer.cornerRadius = 5;
        theTextField.placeholder = @"Email";
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
    }
    return self;
}

- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}
- (void)dealloc
{
    [textField release];
    [super dealloc];
}
@end
