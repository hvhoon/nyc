//
//  PullableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
    
#import "PullableView.h"
#import <QuartzCore/QuartzCore.h>
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"
@implementation PullableView

@synthesize handleView;
@synthesize closedCenter;
@synthesize openedCenter;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate;
@synthesize notificationView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        animate = YES;
        animationDuration = 0.4;
        
        toggleOnTap = YES;
        
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-40, 320, 40)];
        [self addSubview:handleView];
        [handleView release];

        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        dragRecognizer.minimumNumberOfTouches = 1;
        dragRecognizer.maximumNumberOfTouches = 1;
        
        [handleView addGestureRecognizer:dragRecognizer];
        [dragRecognizer release];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [handleView addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        opened = NO;
    }
    return self;
}

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];   
    if(SOC.AllowTapAndDrag){
        filterPaneView.transform = CGAffineTransformIdentity;

    }
    else{
        NSLog(@"Allow Dragging With Normal View");
        return;

    }
    crossImageView.hidden=NO;
    searchLensImageView.hidden=YES;
    
    filterPaneView.layer.shadowOpacity = 1 ? 0.8f : 0.0f;
    filterPaneView.layer.cornerRadius = 4.0f;
    filterPaneView.layer.shadowOffset = CGSizeZero;
    filterPaneView.layer.shadowRadius = 14.0f;
    filterPaneView.layer.shadowPath = [UIBezierPath bezierPathWithRect:filterPaneView.bounds].CGPath;
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        
        startPos = self.center;
        
        // Determines if the view can be pulled in the x or y axis
        verticalAxis = closedCenter.x == openedCenter.x;
        
        // Finds the minimum and maximum points in the axis
        if (verticalAxis) {
            minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter;
            maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter;
        } else {
            minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
            maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
        }
        
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
         
        
        
        CGPoint translate = [sender translationInView:self.superview];
        if(translateNew.y>translate.y)
        {
            NSLog(@"up going");
            [delegate alphaMore];
        }
        else{
            NSLog(@"down going");
            [delegate alphaLess];

        }
        translateNew=translate;
        CGPoint newPos;
        
        // Moves the view, keeping it constrained between openedCenter and closedCenter
        if (verticalAxis) {
            
            newPos = CGPointMake(startPos.x, startPos.y + translate.y);
            
            
            if (newPos.y < minPos.y) {
                newPos.y = minPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
                NSLog(@"verticalAxis");
            }
            
            if (newPos.y > maxPos.y) {
                newPos.y = maxPos.y;
                translate = CGPointMake(0, newPos.y - startPos.y);
                NSLog(@"CheckAxis");
            }
        } else {
            

            newPos = CGPointMake(startPos.x + translate.x, startPos.y);
            
            if (newPos.x < minPos.x) {
                newPos.x = minPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
            
            if (newPos.x > maxPos.x) {
                newPos.x = maxPos.x;
                translate = CGPointMake(newPos.x - startPos.x, 0);
            }
        }
        
        [sender setTranslation:translate inView:self.superview];
        
        self.center = newPos;
        
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // Gets the velocity of the gesture in the axis, so it can be
        // determined to which endpoint the state should be set.
        
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x;
        
        CGPoint target = axisVelocity < 0 ? minPos : maxPos;
        BOOL op = CGPointEqualToPoint(target, openedCenter);
        
        [self setOpened:op animated:animate];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    
    [self showShadow];
    if(!opened){
        
        filterPaneView.layer.shadowOpacity = 1 ? 0.8f : 0.0f;
        filterPaneView.layer.cornerRadius = 4.0f;
        filterPaneView.layer.shadowOffset = CGSizeZero;
        filterPaneView.layer.shadowRadius = 14.0f;
        filterPaneView.layer.shadowPath = [UIBezierPath bezierPathWithRect:filterPaneView.bounds].CGPath;
        
        if(!SOC.AllowTapAndDrag){
        filterPaneView.transform = CGAffineTransformIdentity;
            SOC.AllowTapAndDrag=TRUE;
            [(UILabel*)[self viewWithTag:38] setText:SOC.filterObject.pickADateString];
            SOC.filterObject.lastDateString=SOC.filterObject.pickADateString;
         }
    }
    
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self setOpened:!opened animated:animate];
    }
}

- (void)setToggleOnTap:(BOOL)tap {
    toggleOnTap = tap;
    tapRecognizer.enabled = tap;
}

- (BOOL)toggleOnTap {
    return toggleOnTap;
}

- (void)setOpened:(BOOL)op animated:(BOOL)anim {
    opened = op;
    
    if(opened){
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
            filterPaneView.frame=CGRectMake(0, 0, 640, 402+20);//20
            handleCheckButton.hidden=NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }
    else{
        handleCheckButton.hidden=YES;
        filterPaneView.frame=CGRectMake(0, 0, 640, 402);
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    [self showHideCross:opened];
    
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    
    
    //handleView.transform = CGAffineTransformMakeScale(0.01, 0.01);

    
    self.center = opened ? openedCenter : closedCenter;
    
    
    //kanav
    [delegate doTheTurn:opened];//commented let's come to this again
    [delegate AddHideAnOverlay:opened];
    
    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        dragRecognizer.enabled = NO;
        tapRecognizer.enabled = NO;
        [UIView commitAnimations];
        
    } else {
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
            

        }
    }
}
-(void)showHideCross:(BOOL)op{
    if(op){
        crossImageView.hidden=NO;
        searchLensImageView.hidden=YES;
    }
    else{
        crossImageView.hidden=YES;
        searchLensImageView.hidden=NO;
    }
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
            
            if(!opened)
                [self showShadow];
            

        }
    }
}
#if 1
-(void)showShadow{
    if(opened){
        filterPaneView.layer.shadowOpacity = opened ? 0.0f : 0.0f;
        filterPaneView.layer.cornerRadius = 4.0f;
        filterPaneView.layer.shadowOffset = CGSizeZero;
        filterPaneView.layer.shadowRadius = 14.0f;
        filterPaneView.layer.shadowPath = [UIBezierPath bezierPathWithRect:filterPaneView.bounds].CGPath;
        
       
        
    }
    else{
        filterPaneView.layer.shadowOpacity = 1 ? 0.0f : 0.0f;
        filterPaneView.layer.cornerRadius = 4.0f;
        filterPaneView.layer.shadowOffset = CGSizeZero;
        filterPaneView.layer.shadowRadius = 14.0f;
        filterPaneView.layer.shadowPath = [UIBezierPath bezierPathWithRect:filterPaneView.bounds].CGPath;
        

        
    }
}
#else
-(void)showShadow{
    if(opened){
        self.layer.shadowOpacity = opened ? 0.8f : 0.0f;
        
        self.layer.cornerRadius = 4.0f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
    }
    else{
        self.layer.shadowOpacity = opened ? 0.8f : 0.0f;
        self.layer.cornerRadius = 0.0f;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 0.0f;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
    }
}
#endif
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self];
     NSLog(@"Start Point_X=%f,Start Point_Y=%f",startPoint.x,startPoint.y);
    if(opened){
        
    CGRect tapLowerPaneRect;
         if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
              tapLowerPaneRect =CGRectMake(70, 402+20, 320, 58);

         }
         else{
              tapLowerPaneRect =CGRectMake(70, 402, 320, 58);
             
         }
    CGRect tapClearSearchRect =CGRectMake(270, 44, 57, 30);
        
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        NSLog(@"text search=%@",SOC.filterObject.searchText);
        

        if(CGRectContainsPoint(tapClearSearchRect,startPoint)){
            
            if(!((SOC.filterObject.searchText==(NSString*)[NSNull null])||([SOC.filterObject.searchText isEqualToString:@""]||SOC.filterObject.searchText==nil)||([SOC.filterObject.searchText isEqualToString:@"(null)"]))){
                [self customCancelButtonHit];
            }
        }
   
    else if(CGRectContainsPoint(tapLowerPaneRect,startPoint)){
        
        
        NSLog(@"Tap Detected Inside Lower Pane");
        SoclivityManager *SOC=[SoclivityManager SharedInstance];   
        if(SOC.AllowTapAndDrag){
            [self setOpened:NO animated:YES];

        }
        else{
            [(UILabel*)[self viewWithTag:38] setText:SOC.filterObject.pickADateString];
            
            NSLog(@"Not Allow To Close Pane");

        }
    }
    }
    else{
        CGRect tapNewActivityRect;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_VERSION_7_0)){
         tapNewActivityRect =CGRectMake(275, 408+20, 39, 31);
        
        }
    else
    {
         tapNewActivityRect =CGRectMake(275, 408, 39, 31);
        
    }
        if(CGRectContainsPoint(tapNewActivityRect,startPoint)){
         [delegate newActivityButtonPressed];
        }
    }
}
#pragma mark -
#pragma mark Transform Animation

-(void)pushTransformWithAnimation{
    NSLog(@"pushTransformWithAnimation");
    [self bringInFilterPane];
}

- (void)slideOutFilterPane {
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.AllowTapAndDrag=FALSE;
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        filterPaneView.transform = CGAffineTransformMakeTranslation(-320.0f, 0.0f);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void)bringInFilterPane{
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        SOC.AllowTapAndDrag=TRUE;
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        filterPaneView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

@end
