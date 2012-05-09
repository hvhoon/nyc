//
//  BirthdayPickerView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BirthdayPickerDelegate <NSObject>

@optional
-(void)hideBirthdayPicker;
-(void)dateSelected:(NSString*)bDate;
-(void)PostPhotoOnFacebookWall;
@end

@interface BirthdayPickerView : UIView<UIPickerViewDelegate>{
    
    NSDate *dateObject;
    id <BirthdayPickerDelegate> delegate;
    UIDatePicker *birthDayPicker;
    NSString *birthdayDate;
    BOOL dateChange;
}
@property (nonatomic,assign) id <BirthdayPickerDelegate> delegate;
@property (nonatomic,retain)NSString *birthdayDate;
- (void) ShowBirthDayView:(CGFloat)height;
- (void) HideView;
@end
