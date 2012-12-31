// AttributedTableViewCell.m

#import <QuartzCore/QuartzCore.h>
#import "AttributedTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "SoclivityUtilities.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

//static CGFloat const kEspressoDescriptionTextFontSize = 17;
static CGFloat const kEspressoDescriptionTextFontSize = 14;
static CGFloat const kAttributedTableViewCellVerticalMargin = 20.0f;

static NSRegularExpression *__nameRegularExpression;
static inline NSRegularExpression * NameRegularExpression() {
    if (!__nameRegularExpression) {
       // __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
        
        __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"#([^#(#)]+#)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __nameRegularExpression;
}

static NSRegularExpression *__parenthesisRegularExpression;
static inline NSRegularExpression * ParenthesisRegularExpression() {
    if (!__parenthesisRegularExpression) {
        __parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __parenthesisRegularExpression;
}

@implementation AttributedTableViewCell
@synthesize summaryText = _summaryText;
@synthesize summaryLabel = _summaryLabel;
@synthesize lbltime,timeText,hashCount,notifytype;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil; 
    }
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.summaryLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
     self.summaryLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    self.summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.summaryLabel.numberOfLines = 0;
    
    //no need
    /*self.summaryLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor redColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.1f] CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f] CGColor] forKey:(NSString *)kTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:(id)[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.summaryLabel.activeLinkAttributes = mutableActiveLinkAttributes;
*/
    
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
    
    return self;
}


- (void)setSummaryText:(NSString *)text {
    [self willChangeValueForKey:@"summaryText"];
    _summaryText = [text copy];
    [self didChangeValueForKey:@"summaryText"];
    
    /*[self.summaryLabel setText:self.summaryText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();
        NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:kEspressoDescriptionTextFontSize]; 
        CTFontRef boldFont = CTFontCreateWithName(( CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (boldFont) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:( id)boldFont range:nameRange];
            CFRelease(boldFont);
        }
        
        [mutableAttributedString replaceCharactersInRange:nameRange withString:[[[mutableAttributedString string] substringWithRange:nameRange] uppercaseString]];
        
        regexp = ParenthesisRegularExpression();
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {            
            UIFont *italicSystemFont = [UIFont italicSystemFontOfSize:kEspressoDescriptionTextFontSize];
            CTFontRef italicFont = CTFontCreateWithName(( CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
            if (italicFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:( id)italicFont range:result.range];
                CFRelease(italicFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor grayColor] CGColor] range:result.range];
            }
        }];
                
        return mutableAttributedString;
    }];
    
    NSRegularExpression *regexp = NameRegularExpression();
    NSRange linkRange = [regexp rangeOfFirstMatchInString:self.summaryText options:0 range:NSMakeRange(0, [self.summaryText length])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", [self.summaryText substringWithRange:linkRange]]];
    [self.summaryLabel addLinkToURL:url withRange:linkRange];
     
     */
    
   [self.summaryLabel setText:self.summaryText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();
        
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            UIFont *boldSystemFont =[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14.0]; //[UIFont boldSystemFontOfSize:kEspressoDescriptionTextFontSize];
            CTFontRef boldFont = CTFontCreateWithName(( CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (boldFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:( id)boldFont range:result.range];
                CFRelease(boldFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:result.range];
            }
            
            
        }];
        
        for (int i=0; i<self.hashCount; i++)
        {
            NSRange range = [[mutableAttributedString string] rangeOfString:@"#"];
            
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(range.location, 1) withString:@""];
            
        }//END for (int i=0; i<[Splitarray count]; i++)
        
        return mutableAttributedString;
    }];
}

- (void)setTimeText:(NSString *)text {
    self.lbltime.text=text;
}

+ (CGFloat)heightForCellWithText:(NSString *)text {
    CGFloat height = 10.0f;
    height += ceilf([text sizeWithFont:[UIFont systemFontOfSize:kEspressoDescriptionTextFontSize] constrainedToSize:CGSizeMake(270.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    height += kAttributedTableViewCellVerticalMargin;
    return height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    
    CGSize img_Size;
    
    for (UIImageView *img_vw in self.subviews)
    {
        if ([img_vw isKindOfClass:[UIImageView class]])
        {
            img_Size = [img_vw.image size];
        }//END if ([img_vw isKindOfClass:[UIImageView class]])
    }//END for (UIImageView *img_vw in self.subviews)
    
    CGRect rect1=CGRectMake(0, 10, 345, [AttributedTableViewCell heightForCellWithText:self.summaryText]-10);
    CGRect rect2=CGRectMake(0, self.summaryLabel.frame.size.height+5, 345, 35);
    
    self.summaryLabel.frame =  CGRectOffset(CGRectInset(rect1, 60, 5.0f), 0.0f, 0.0f);
    self.lbltime.frame=CGRectOffset(CGRectInset(rect2, 60, 5.0f), 0.0f, 0.0f);
    
   // self.summaryLabel.frame = CGRectOffset(CGRectInset(self.bounds, 20.0f, 5.0f), -10.0f, 0.0f);
}

@end

#pragma clang diagnostic pop
