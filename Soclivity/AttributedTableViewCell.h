// AttributedTableViewCell.h
//

#import <UIKit/UIKit.h>

@class TTTAttributedLabel;

@interface AttributedTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *summaryText;
@property (nonatomic, retain) TTTAttributedLabel *summaryLabel;

+ (CGFloat)heightForCellWithText:(NSString *)text;

@end
