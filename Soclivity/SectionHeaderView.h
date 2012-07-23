

#import <Foundation/Foundation.h>
@class InfoActivityClass;

@protocol SectionHeaderViewDelegate;


@interface SectionHeaderView : UIView {
    BOOL toggleAction;
}

@property (nonatomic, retain) UILabel *activitytitleLabel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id <SectionHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame detailSectionInfo:(InfoActivityClass*)detailSectionInfo section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate sortingPattern:(NSInteger)sortingPattern;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
-(void)detailActivity:(id)sender;
-(IBAction)toggleOpen:(id)sender;
-(void)spinnerCloseAndIfoDisclosureButtonUnhide;
@end



/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;
-(void)selectActivityView:(NSInteger)activitySection;
@end

