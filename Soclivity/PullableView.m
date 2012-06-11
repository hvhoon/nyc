//
//  PullableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
    
#import "PullableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PullableView

@synthesize handleView;
@synthesize closedCenter;
@synthesize openedCenter;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        animate = YES;
        animationDuration = 0.2;
        
        toggleOnTap = YES;
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
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
            //[delegate alphaMore];
        }
        else{
            NSLog(@"down going");
            //[delegate alphaLess];

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
    //[delegate doTheTurn:opened];//commented let's come to this again
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
         
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
            [self showShadow];

        }
    }
}
#if 1
-(void)showShadow{
    if(opened){
        filterPaneView.layer.shadowOpacity = opened ? 0.8f : 0.0f;
        filterPaneView.layer.cornerRadius = 1.0f;
        filterPaneView.layer.shadowOffset = CGSizeZero;
        filterPaneView.layer.shadowRadius = 14.0f;
        filterPaneView.layer.shadowPath = [UIBezierPath bezierPathWithRect:filterPaneView.bounds].CGPath;
        
    }
    else{
        filterPaneView.layer.shadowOpacity = opened ? 0.8f : 0.0f;
        filterPaneView.layer.cornerRadius = 0.0f;
        filterPaneView.layer.shadowOffset = CGSizeZero;
        filterPaneView.layer.shadowRadius = 0.0f;
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
    NSLog(@"touchesBegan called");
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint =[touch locationInView:self];
	NSLog(@"Tap Detected");
    
    NSLog(@"Start Point_X=%f,Start Point_Y=%f",startPoint.x,startPoint.y);
   // if(CGRectContainsPoint(loveXlingVideo,startPoint)){
        
    //}

}
@end
