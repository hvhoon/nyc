//
//  SlidingDrawerViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlideViewController.h"
#import "HomeViewController.h"
@interface SlidingDrawerViewController : SlideViewController<SlideViewControllerDelegate,HomeScreenDelegate>{
    NSArray *_datasource;
    NSMutableArray *_searchDatasource;
    BOOL isFBlogged;
    
}
@property (nonatomic,assign)BOOL isFBlogged;
@property (nonatomic, readonly) NSArray *datasource;
- (void)FBlogout;
@end
