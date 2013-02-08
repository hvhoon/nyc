//
//  ChatViewController.h
//  Soclivity
//
//  Created by Payal Sharma on 08/02/13.
//
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, retain)IBOutlet UILabel *lblactivity;
@property(copy, readwrite)NSString *lstractivityname;
@property(nonatomic, retain)IBOutlet UITableView *tblchattinglist;

@property(nonatomic, retain)NSMutableArray *arr_chatlist;

-(IBAction)poptopreviousview:(id)sender;

@end
