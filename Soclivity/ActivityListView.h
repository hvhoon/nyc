//
//  ActivityListView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView* tableListView; 
}

@end
