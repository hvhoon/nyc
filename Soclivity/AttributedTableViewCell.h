// AttributedTableViewCell.h
//

#import <UIKit/UIKit.h>

@class TTTAttributedLabel;

@interface AttributedTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *summaryText;
@property (nonatomic, retain) TTTAttributedLabel *summaryLabel;
@property (nonatomic, copy) NSString *timeText;
@property (nonatomic, retain) UILabel *lbltime;

+ (CGFloat)heightForCellWithText:(NSString *)text;

@end
