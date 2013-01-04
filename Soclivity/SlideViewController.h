//
//  SlideViewController.h
//  SlideViewController
//

#import <UIKit/UIKit.h>

#define kSlideViewControllerSectionTitleKey @"slideViewControllerSectionTitle"
#define kSlideViewControllerSectionViewControllersKey @"slideViewControllerSectionViewControllers"
#define kSlideViewControllerSectionTitleNoTitle @"slideViewControllerSectionTitleNoTitle"
#define kSlideViewControllerViewControllerTitleKey @"slideViewControllerViewControllerTitle"
#define kSlideViewControllerViewControllerNibNameKey @"slideViewControllerViewControllerNibName"
#define kSlideViewControllerViewControllerClassKey @"slideViewControllerViewControllerClass"
#define kSlideViewControllerViewControllerUserInfoKey @"slideViewControllerViewControllerUserInfo"
#define kSlideViewControllerViewControllerIconKey @"slideViewControllerViewControllerIcon"

#define kSlideViewControllerViewControllerTagKey @"slideViewControllerViewControllerTagKey"

#define kSlideViewControllerViewControllerTapAndDrawerKey @"slideViewControllerViewControllerTapAndDrawerKey"



typedef enum {
    
    kSlideNavigationControllerStateNormal,
    kSlideNavigationControllerStateDragging,
    kSlideNavigationControllerStatePeeking,
    kSlideNavigationControllerStateDrilledDown,
    kSlideNavigationControllerStateSearching
    
} SlideNavigationControllerState;

@class SlideViewController;
@class SlideViewNavigationBar;

@protocol SlideViewControllerDelegate <NSObject>
@optional
- (void)configureViewController:(UIViewController *)viewController userInfo:(id)userInfo;
- (NSIndexPath *)initialSelectedIndexPath;
- (void)configureSearchDatasourceWithString:(NSString *)string;
- (NSArray *)searchDatasource;
@required
- (UIViewController *)initialViewController;
- (NSArray *)datasource;
@end

@protocol SlideViewControllerSlideDelegate <NSObject>
@optional
- (BOOL)shouldSlideOut;
@end

@protocol SlideViewNavigationBarDelegate <NSObject>
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)slideViewNavigationBar:(SlideViewNavigationBar *)navigationBar touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface SlideViewController : UIViewController <SlideViewNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate> {
    
    IBOutlet UINavigationController *_slideNavigationController;
    IBOutlet UITableView *_tableView;
    id <SlideViewControllerDelegate> _delegate;
    CGPoint _startingDragPoint;
    CGFloat _startingDragTransformTx;
    UIView *_touchView;
    SlideNavigationControllerState _slideNavigationControllerState;
    UIView *_overlayView;
}

@property (nonatomic, assign) id <SlideViewControllerDelegate> delegate;
@property (copy, readwrite)NSString *lstrnotificationscount;

- (void)configureViewController:(UIViewController *)viewController;
- (void)menuBarButtonItemPressed:(id)sender;
- (void)slideOutSlideNavigationControllerView;
- (void)slideInSlideNavigationControllerView;
- (void)slideSlideNavigationControllerViewOffScreen;

-(void)UpdateNotification;

@end
