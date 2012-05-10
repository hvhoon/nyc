//
//  CustomPlaceholder.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomPlaceholder.h"

@implementation CustomPlaceholder




-(void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor darkGrayColor] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont fontWithName:@"Abduction" size:15.0]];
}
@end
