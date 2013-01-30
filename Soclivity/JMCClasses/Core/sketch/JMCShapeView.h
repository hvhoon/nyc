//
//  JMCShapeView.h
//  AngryNerds2
//
//  Created by Theodora Tse on 12/01/12.
//  Copyright (c) 2012 Nick Pellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMCShape.h"

@interface JMCShapeView : UIView <UIGestureRecognizerDelegate> {
    CGContextRef ctx;
    NSMutableArray *history;
}

@property (nonatomic, retain) NSMutableArray *shapes;
@property (nonatomic, retain) NSMutableArray *history;

- (void)clear;
- (void)undo;
- (void)redo;

@end
