//
//  HomeViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UISearchBarDelegate>{
    UISearchBar	*homeSearchBar;
}
@property (nonatomic, retain) UISearchBar *homeSearchBar;
-(void)HideSearchBar;
-(void)ShowSearchBar;
@end
