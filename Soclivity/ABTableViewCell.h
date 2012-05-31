//
//  ABTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABTableViewCell : UITableViewCell
{
	UIView *contentView;
    
}

- (void)drawContentView:(CGRect)r; // subclasses should implement

@end
