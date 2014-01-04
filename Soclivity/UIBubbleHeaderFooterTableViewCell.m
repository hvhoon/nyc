//
//  UIBubbleHeaderFooterTableViewCell.m
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import "UIBubbleHeaderFooterTableViewCell.h"
#import "SoclivityUtilities.h"

@interface UIBubbleHeaderFooterTableViewCell ()

@property (nonatomic, retain) UILabel *label;

@end


@implementation UIBubbleHeaderFooterTableViewCell
@synthesize label = _label;
@synthesize date = _date;
@synthesize name=_name;
@synthesize bubbleType;

+ (CGFloat)height
{
    return 28.0;
}
- (void)setDate:(NSDate *)value
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSString *text=[SoclivityUtilities nofiticationTime:[dateFormatter stringFromDate:value]];
    if (self.label)
    {
        self.label.text = text;
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize  size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:12]];

    CGFloat anchorX=0.0f;
    if(bubbleType==1)
        anchorX=72;
    else{
         anchorX=self.frame.size.width-size.width-30;
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(anchorX, 0, size.width, [UIBubbleHeaderFooterTableViewCell height])];
    self.label.text = text;
    self.label.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    self.label.textColor=[SoclivityUtilities returnTextFontColor:4];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}

- (void)setName:(NSString *)value
{
    if (self.label)
    {
        self.label.text = value;
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width, [UIBubbleHeaderFooterTableViewCell height])];
    self.label.text = value;
    self.label.font = [UIFont fontWithName:@"Helvetica-Condensed" size:12];
    self.label.textColor=[SoclivityUtilities returnTextFontColor:5];
    self.label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.label];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
