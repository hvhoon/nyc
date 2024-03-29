//
//  CustomSearchbar.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSearchbar.h"
#import "SoclivityUtilities.h"

@implementation CustomSearchbar
@synthesize CSDelegate,showClearButton;


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        customBackButtom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
        [customBackButtom addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_button.png"] forState:UIControlStateNormal];
        [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_buttonSelected.png"] forState:UIControlStateHighlighted];
        
        //Set other button states (hightlight, select, etc) here
    }    
    return self;
} 

-(void)drawRect:(CGRect)rect {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    [[[self subviews] objectAtIndex:0] setAlpha:1.0];
    }else{
    [[[self subviews] objectAtIndex:0] setAlpha:0.0];
    }
    UIImage *image = [UIImage imageNamed: @"S4.1_search-background.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)layoutSubviews {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
    for(UIView *subview in [[self.subviews objectAtIndex:0]subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            
            
            subview.alpha=0.0f;
            
            UIButton *cancelButton = nil;
            
            cancelButton = (UIButton*)subview;
            cancelButton.titleLabel.textColor=[UIColor clearColor];
            cancelButton.tintColor=[UIColor whiteColor];

             //[(UIButton*)subview setTitle:@"Done" forState:UIControlStateNormal];
            customBackButtom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
            [customBackButtom addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            if(showClearButton){

                [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_clear.png"] forState:UIControlStateNormal];
                [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_clearPressed.png"] forState:UIControlStateHighlighted];

            }
            else{
            [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_cancel.png"] forState:UIControlStateNormal];
                [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_cancelPressed.png"] forState:UIControlStateHighlighted];
            }
            

            [subview  addSubview:customBackButtom];
        }
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            [(UITextField *)subview setTextColor:[SoclivityUtilities returnTextFontColor:1]];
            [(UITextField *)subview setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
            
            [(UITextField *)subview setBackground:[UIImage imageNamed:@"S4.1_search-bar.png"]];
            [(UITextField *)subview setBorderStyle:UITextBorderStyleNone];
        }
    }
    }else{
        for(UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                
                //[(UIButton*)subview setTitle:@"Done" forState:UIControlStateNormal];
                customBackButtom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
                [customBackButtom addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
                if(showClearButton){
                    
                    [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_clear.png"] forState:UIControlStateNormal];
                    [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_clearPressed.png"] forState:UIControlStateHighlighted];
                    
                }
                else{
                    [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_cancel.png"] forState:UIControlStateNormal];
                    [customBackButtom setBackgroundImage:[UIImage imageNamed:@"S04.1_cancelPressed.png"] forState:UIControlStateHighlighted];
                }
                
                
                [subview  addSubview:customBackButtom];
                [subview insertSubview:customBackButtom aboveSubview:subview];
                }
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [(UITextField *)subview setTextColor:[SoclivityUtilities returnTextFontColor:1]];
                [(UITextField *)subview setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:15]];
                
                [(UITextField *)subview setBackground:[UIImage imageNamed:@"S4.1_search-bar.png"]];
                [(UITextField *)subview setBorderStyle:UITextBorderStyleNone];
            }
        }
    }
    [super layoutSubviews];
}

-(void)cancelAction {
    [self.CSDelegate customCancelButtonHit];
}

-(void)dealloc {
    [super dealloc];
}

@end
