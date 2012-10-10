//
//  UIViewController+MJPopupViewController.h
//  MJModalViewController

#import <UIKit/UIKit.h>

typedef enum {
    MJPopupViewAnimationSlideBottomTop = 1,
    MJPopupViewAnimationSlideRightLeft,
    MJPopupViewAnimationSlideLeftRight,
    MJPopupViewAnimationSlideBottomBottom,
    MJPopupViewAnimationFade
} MJPopupViewAnimation;

@interface UIViewController (MJPopupViewController)

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(MJPopupViewAnimation)animationType;
- (void)dismissPopupViewControllerWithanimationType:(MJPopupViewAnimation)animationType;

@end