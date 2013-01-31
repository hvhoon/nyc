//
//  AboutListViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AboutViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface AboutViewController : UIViewController{
    id <AboutViewDelegate>delegate;
}

@property (nonatomic,retain)id <AboutViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIButton *viewAllBugs;
@property (retain, nonatomic) IBOutlet UIButton *submitBug;
@property (retain, nonatomic) IBOutlet UILabel *buildText;
@property (nonatomic, retain)IBOutlet UIButton *btnnotify;
- (IBAction)profileSliderPressed:(id)sender;
- (IBAction)submitBugPressed:(id)sender;
- (IBAction)viewAllIssues:(id)sender;





@end
