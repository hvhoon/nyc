//
//  ChattingTableViewCell.m
//  Soclivity
//
//  Created by Payal Sharma on 08/02/13.
//
//

#import "ChattingTableViewCell.h"

@implementation ChattingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
   /* self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.summaryLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.summaryLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    //self.summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.highlightedTextColor = [UIColor whiteColor];
    self.summaryLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    self.lbltime=[[UILabel alloc] init];
    self.lbltime.textColor=[SoclivityUtilities returnTextFontColor:4];
    self.lbltime.font =[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    self.lbltime.lineBreakMode = UILineBreakModeWordWrap;
    self.lbltime.numberOfLines = 0;
    self.lbltime.highlightedTextColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.lbltime];
    [self.contentView addSubview:self.summaryLabel];
    */
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
