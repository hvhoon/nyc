//
//  CustomSearchbar.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SoclivitySearchBarDelegate

@optional
-(void)customCancelButtonHit;

@end


@interface CustomSearchbar : UISearchBar{
    id<SoclivitySearchBarDelegate> CSDelegate;
    UIButton *customBackButtom;
    BOOL showClearButton;
}
@property (nonatomic, retain) id<SoclivitySearchBarDelegate> CSDelegate;
@property (nonatomic,assign)BOOL showClearButton;
-(void)cancelAction;
@end
