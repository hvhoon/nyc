

#import <Foundation/Foundation.h>


typedef struct _FCRangeSliderValue {
    CGFloat start;
    CGFloat end;
} FCRangeSliderValue;



@interface FCRangeSlider : UIControl {
@private
    UIImageView *outRangeTrackView;
    UIImageView *inRangeTrackView;
    UIImageView *minimumThumbView;
    UIImageView *maximumThumbView;
    UIImageView *thumbBeingDragged;
    CGFloat trackSliderWidth;
    NSNumberFormatter *roundFormatter;
    BOOL isTracking;
}

@property (nonatomic) CGFloat minimumValue;
@property (nonatomic) CGFloat maximumValue;
@property (nonatomic) NSRange range;
@property (nonatomic) FCRangeSliderValue rangeValue;
@property (nonatomic) CGFloat minimumRangeLength;
@property (nonatomic) BOOL acceptOnlyNonFractionValues;
@property (nonatomic) BOOL acceptOnlyPositiveRanges;
- (void)setOutRangeTrackImage:(UIImage *)image;
- (void)setInRangeTrackImage:(UIImage *)image;
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
- (void)setRangeValue:(FCRangeSliderValue)newRangeValue animated:(BOOL)animated;
- (void)setRange:(NSRange)newRange animated:(BOOL)animated;

@end
NS_INLINE FCRangeSliderValue FCRangeSliderValueMake(CGFloat start, CGFloat end) {
    FCRangeSliderValue r;
    r.start = start;
    r.end = end;
    return r;
}
