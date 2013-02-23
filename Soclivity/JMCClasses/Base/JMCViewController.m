/**
   Copyright 2011 Atlassian Software

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/
#import <QuartzCore/QuartzCore.h>
#import "JMC.h"
#import "JMCViewController.h"
#import "JMCAttachmentItem.h"
#import "JMCAttachmentsViewController.h"
#import "JMCCreateIssueDelegate.h"
#import "JMCIssueStore.h"
#import "JMCMacros.h"
#import "JMCReplyDelegate.h"
#import "JMCTransport.h"
#import "JMCSketchViewControllerFactory.h"
#import "UIImage+JMCResize.h"
#import "UIView+JMCAdditions.h"
#import "JMCConsoleLogReader.h"

@interface JMCViewController ()

- (BOOL)shouldTrackLocation;

- (UIButton *)buttonFor:(NSString *)iconNamed action:(SEL)action;

- (NSMutableArray *)removeImageViewsFromAttachmentsButton;

- (void)addAttachmentItem:(JMCAttachmentItem *)attachment withIcon:(UIImage *)icon action:(SEL)action;
- (void)addButtonsToView;
- (void)addImageAttachmentItem:(UIImage *)origImg;
- (void)addImageViewsToAttachmentsButton:(NSArray *)imageViews;
- (void)dismissKeyboard;
- (void)hideAudioProgress;
- (void)internalRelease;
- (void)reloadAttachmentsButton;
- (void)removeAttachmentItemAtIndex:(NSUInteger)attachmentIndex;
- (void)deleteAttachments;

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLLocation *currentLocation;
@property(nonatomic, retain) UIPopoverController *popover;
@property(nonatomic, retain) UIButton *screenshotButton;
@property(nonatomic, retain) UIButton *attachmentsButton;

@end

@implementation JMCViewController

static float kJMCInitialButtonOffset = 5.0;
static float kJMCButtonSpacing = 50.0;
static NSInteger kJMCTag = 10133;

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    if ([self shouldTrackLocation]) {
        CLLocationManager* locMgr = [[CLLocationManager alloc] init];
        self.locationManager = locMgr;
        [locMgr release];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        

        //TODO: remove this. just for testing location in the simulator.
#if TARGET_IPHONE_SIMULATOR
        // -33.871088, 151.203665
        CLLocation *fixed = [[CLLocation alloc] initWithLatitude:-33.871088 longitude:151.203665];
        
        [self setCurrentLocation: fixed];
        [fixed release];
#endif
    }

    // layout views
    self.countdownView.layer.cornerRadius = 7.0;
    
    if (self.replyToIssue) {
        self.navigationItem.title = JMCLocalizedString(@"Reply", "Title of the feedback controller");
    }
    else {
        self.navigationItem.title = JMCLocalizedString(@"Feedback", "Title of the feedback controller");
    }


    self.navigationItem.rightBarButtonItem =
            [[[UIBarButtonItem alloc] initWithTitle:JMCLocalizedString(@"Send", @"Send feedback")
                                              style:UIBarButtonItemStyleDone
                                             target:self
                                             action:@selector(sendFeedback)] autorelease];

    [self addButtonsToView];
    if (!self.attachments) {
        self.attachments = [NSMutableArray arrayWithCapacity:1];
    }
    else {
        [self reloadAttachmentsButton];
    }

    // TODO: the transport class should be split in 2. 1 for actually sending, the other for creating the request
    _issueTransport = [[JMCIssueTransport alloc] init];
    _replyTransport = [[JMCReplyTransport alloc] init];
    
    JMCCreateIssueDelegate* createDelegate = [[JMCCreateIssueDelegate alloc] init];
    _issueTransport.delegate = createDelegate;
    [createDelegate release];
    
    JMCReplyDelegate* replyDelegate = [[JMCReplyDelegate alloc] init];
    _replyTransport.delegate = replyDelegate;
    [replyDelegate release];

}

- (void) viewWillAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
    
    // Show cancel button only if this is the first controller on the stack
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        self.navigationItem.leftBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:JMCLocalizedString(@"Cancel", @"Cancel feedback")
                                          style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(dismiss)] autorelease];
    }
    
    if ([self.descriptionField.text length] == 0 && !self.replyToIssue &&
        [[JMC sharedInstance].customDataSource respondsToSelector:@selector(initialFeedbackText)]) 
    {
        NSString *myText = [[JMC sharedInstance].customDataSource initialFeedbackText];
        if ([myText length])
        { 
            [self.descriptionField setText:myText]; 
        }
    }
    
    [self.descriptionField becomeFirstResponder];
    _ignoreKeyboardHide = NO;
}

- (void) viewDidDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
    [self dismissKeyboard];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation) ||
            UIInterfaceOrientationIsPortrait(interfaceOrientation));
    //    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Hide the popover if visible, dealloc otherwise
    if (self.popover.popoverVisible) {
        [self.popover dismissPopoverAnimated:NO];
    }
    else {
        self.popover = nil;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // If popover is set, then present it from button
    if (self.popover) {
        [self.popover presentPopoverFromRect:self.screenshotButton.frame
                                      inView:self.screenshotButton.superview 
                    permittedArrowDirections:UIPopoverArrowDirectionAny 
                                    animated:YES];
    }
}

#pragma mark - UIKeyboard Notification Methods

/*
 Reduce the size of the view so that it's not obscured by the keyboard.
 Animate the resize so that it's in sync with the appearance of the keyboard.
 */
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGRect newFrame = self.view.bounds;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            newFrame.size.height = 200;
        }
        else {
            newFrame.size.height = 106;
        }

        self.descriptionField.superview.frame = newFrame;
        self.countdownView.center = self.descriptionField.center;
    }
    else {
        CGRect newFrame = self.view.bounds;
        newFrame.size.width -= (_buttonOffset > kJMCInitialButtonOffset ? kJMCButtonSpacing : 0);
        newFrame.size.height /= 2;

        self.descriptionField.frame = newFrame;
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (!_ignoreKeyboardHide) {
            CGRect newFrame = self.view.bounds;
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                newFrame.size.height = 416;
            }
            else {
                newFrame.size.height = 268;
            }
            
            self.descriptionField.superview.frame = newFrame;
            self.countdownView.center = self.descriptionField.center;
        }
    }
    else {
        CGRect newFrame = self.view.bounds;
        newFrame.size.width -= (_buttonOffset > kJMCInitialButtonOffset ? kJMCButtonSpacing : 0);
        
        self.descriptionField.frame = newFrame;
    }
    
    [UIView commitAnimations];
}

- (void)keyboardDidHide:(NSNotification*)notification
{
    // If keyboard did hide and popover is visible, present it from new position
    if (self.popover.popoverVisible) {
        [self.popover presentPopoverFromRect:self.screenshotButton.frame
                                      inView:self.screenshotButton.superview 
                    permittedArrowDirections:UIPopoverArrowDirectionAny 
                                    animated:YES];
    }
}

#pragma mark - UITextViewDelegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView 
{
    return YES;
}

#pragma mark - UIControl Action Methods

- (IBAction)dismiss
{
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)addScreenshot
{
    if ([self.popover isPopoverVisible]) 
    {
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    } 
    else 
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
        {
            self.popover = [[[UIPopoverController alloc] initWithContentViewController:imagePicker] autorelease];
            [self.popover presentPopoverFromRect:self.screenshotButton.frame
                                          inView:self.screenshotButton.superview 
                        permittedArrowDirections:UIPopoverArrowDirectionAny 
                                        animated:YES];
        }
        else 
        {
            _ignoreKeyboardHide = YES;
            [self presentModalViewController:imagePicker animated:YES];
        }
        [imagePicker release];
    }
       
}

- (IBAction)addVoice
{
    JMCRecorder* recorder = [JMCRecorder instance];
    if (!recorder) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: JMCLocalizedString(@"Voice Recording", @"Alert title when no audio") 
                                   message: JMCLocalizedString(@"JMCVoiceRecordingNotSupported", @"Alert when no audio") 
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    recorder.recorder.delegate = self;
    if (recorder.recorder.recording) {
        [recorder stop];

    } else {
        [recorder start];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        self.progressView.progress = 0;

        self.countdownView.hidden = NO;

        // start animating the voice button...
        NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:8];
        for (int i = 1; i < 9; i++) {
            NSString *sprintName = [@"icon_record_" stringByAppendingFormat:@"%d", i];
            UIImage *img = [UIImage imageNamed:sprintName];
            [sprites addObject:img];
        }
        self.voiceButton.imageView.animationImages = sprites;
        self.voiceButton.imageView.animationDuration = 0.85f;
        [self.voiceButton.imageView startAnimating];

    }
}

- (void)viewAttachments:(UIButton *)sender {

    _ignoreKeyboardHide = YES;
    if ([self.attachments count] == 1)  // if there is only image attached, bypass the attachments view
    {
        JMCAttachmentItem* attachment = ((JMCAttachmentItem*)[self.attachments objectAtIndex:0]);
        if (attachment.type == JMCAttachmentTypeImage)
        {   
            JMCSketchViewController* sketchController = 
            [JMCSketchViewControllerFactory makeSketchViewControllerFor:attachment.data withId:0];
            sketchController.delegate = self;
            [self presentModalViewController:sketchController animated:YES];
            return;
        }
    }
    self.attachmentsViewController.attachments = self.attachments;
    [self.navigationController pushViewController:self.attachmentsViewController animated:YES];

}

- (IBAction)sendFeedback
{
    
    if ([self.descriptionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0
        && self.attachments.count <= 0) {
        // No data entered, just return.
        return;
    }
    NSMutableDictionary *customFields = [[JMC sharedInstance] getCustomFields];
    NSMutableArray* allAttachments = [NSMutableArray arrayWithArray:self.attachments];
    
    
    if ([[JMC sharedInstance].customDataSource respondsToSelector:@selector(customAttachment)]) {
        JMCAttachmentItem *payloadData = [[JMC sharedInstance].customDataSource customAttachment];
        if (payloadData) {
            if (payloadData.path)
            {
                [allAttachments addObject:payloadData];
            }
            else
            {
                JMCALog(@"Not adding attachment: %@ with no path.", payloadData);
            }
        }
    }
    
    if ([self shouldTrackLocation] && [self currentLocation]) {
        NSMutableArray *objects = [NSMutableArray arrayWithCapacity:3];
        NSMutableArray *keys =    [NSMutableArray arrayWithCapacity:3];
        @synchronized (self) {
            NSNumber *lat = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
            NSNumber *lng = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
            NSString *locationString = [NSString stringWithFormat:@"%f,%f", lat.doubleValue, lng.doubleValue];
            [keys addObject:@"lat"];      [objects addObject:lat];
            [keys addObject:@"lng"];      [objects addObject:lng];
            [keys addObject:@"location"]; [objects addObject:locationString];
        }
        
        // Merge the location into the existing customFields.
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        [customFields addEntriesFromDictionary:dict];
        [dict release];
    }
    
    // add all custom fields as one attachment item
    NSData *customFieldsJSON = [[JMCTransport buildJSONString:customFields] dataUsingEncoding:NSUTF8StringEncoding];
    
    JMCAttachmentItem *customFieldsItem = [[JMCAttachmentItem alloc] initWithName:@"customfields"
                                                                             data:customFieldsJSON
                                                                             type:JMCAttachmentTypeCustom
                                                                      contentType:@"application/json"
                                                                   filenameFormat:@"customfields.json"];
    
    if ([JMC sharedInstance].options.consoleLogEnabled)
    {
        NSString* consoleFilePath = [[JMC sharedInstance].dataDirPath  stringByAppendingPathComponent:@"console.log"];
        [JMCConsoleLogReader writeConsoleLogToPath:consoleFilePath forSender:[[JMC sharedInstance] getAppName]];
        JMCAttachmentItem *consoleLogItem = 
        [[JMCAttachmentItem alloc] initWithName:@"console log" 
                                           path:consoleFilePath 
                                     dataLength:0  // TODO: get the actual size of the log. 
                                           type:JMCAttachmentTypeCustom 
                                    contentType:@"text/plain" 
                                 filenameFormat:@"console.log"];
        
        [allAttachments addObject:consoleLogItem];
        [consoleLogItem release];
        
    }
    
    [allAttachments addObject:customFieldsItem];
    [customFieldsItem release];
    
    
    
    if (self.replyToIssue) {
        [self.replyTransport sendReply:self.replyToIssue
                           description:self.descriptionField.text
                           attachments:allAttachments];
    } else {
        // use the first 80 chars of the description as the issue summary
        NSString *description = self.descriptionField.text;
        u_int length = 80;
        u_int toIndex = [description length] > length ? length : [description length];
        NSString *truncationMarker = [description length] > length ? @"..." : @"";
        [self.issueTransport send:[[description substringToIndex:toIndex] stringByAppendingString:truncationMarker]
                      description:self.descriptionField.text
                      attachments:allAttachments];
    }
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    self.descriptionField.text = @"";
    [self deleteAttachments];
}

#pragma mark - AVAudioRecorderDelegate Methods

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avRecorder successfully:(BOOL)success
{
    [self hideAudioProgress];
    
    JMCRecorder* recorder = [JMCRecorder instance];
    // FIXME: This leads to potential crashes as it loads the audio file into memory 
    // regardless of its size and how many attachments were already added
    JMCAttachmentItem *attachment = [[JMCAttachmentItem alloc] initWithName:@"recording"
                                                                       data:[recorder audioData]
                                                                       type:JMCAttachmentTypeRecording
                                                                contentType:@"audio/aac"
                                                             filenameFormat:@"recording-%d.aac"];
    
    
    attachment.thumbnail = [UIImage imageNamed:@"audio_attachment"];
    [self addAttachmentItem:attachment withIcon:attachment.thumbnail action:@selector(voiceAttachmentTapped:)];
    [attachment release];
    [recorder cleanUp];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }

    UIImage *origImg = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (origImg.size.height > screenSize.height) {

        // resize image... its too huge! (only meant to be screenshots, not photos..)
        CGSize size = origImg.size;
        float ratio = screenSize.height / size.height;
        CGSize smallerSize = CGSizeMake(ratio * size.width, ratio * size.height);
        origImg = [origImg jmc_resizedImage:smallerSize interpolationQuality:kCGInterpolationMedium];
    }

    [self addImageAttachmentItem:origImg];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - JMCAttachmentsViewControllerDelegate

- (void)attachmentsViewController:(JMCAttachmentsViewController *)controller didDeleteAttachment:(JMCAttachmentItem *)attachment {
    [self reloadAttachmentsButton];
}

- (void)attachmentsViewController:(JMCAttachmentsViewController *)controller didChangeAttachment:(JMCAttachmentItem *)attachment {
    [self reloadAttachmentsButton];
}

#pragma mark - JMCSketchViewControllerDelegate

- (void)sketchController:(UIViewController *)controller didFinishSketchingImage:(UIImage *)image withId:(NSNumber *)imageId
{
    NSUInteger imgIndex = [imageId unsignedIntegerValue];
    JMCAttachmentItem *attachment = [self.attachments objectAtIndex:imgIndex];
    attachment.data = UIImagePNGRepresentation(image);
    attachment.thumbnail = [JMCSketchViewControllerFactory makeSketchThumbnailFor:image];
    [self reloadAttachmentsButton];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sketchControllerDidCancel:(UIViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sketchController:(UIViewController *)controller didDeleteImageWithId:(NSNumber *)imageId
{
    [self dismissModalViewControllerAnimated:YES];
    [self.attachments removeObjectAtIndex:[imageId unsignedIntegerValue]];
    [self reloadAttachmentsButton];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    @synchronized (self) {
        [self setCurrentLocation:newLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    JMCDLog(@"Location failed with error: %@", [error localizedDescription]);
}

#pragma mark - Private Helper Methods

- (void)layoutActionButton:(UIButton *)button {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        button.frame = CGRectMake(self.descriptionField.superview.frame.size.width - 44.0 - _buttonOffset, 
                                  self.descriptionField.superview.frame.size.height - 44.0, 
                                  44.0, 
                                  44.0);
    }
    else {
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        button.frame = CGRectMake(self.descriptionField.superview.frame.size.width - kJMCButtonSpacing, 
                                  0 + _buttonOffset, 
                                  44.0, 
                                  44.0);
    }
    
    _buttonOffset += kJMCButtonSpacing;
}


- (void)configureButtonOverlayView {
    self.buttonOverlayView.image = [UIImage imageNamed:@"background_overlay.png"];
}

- (void)layoutButtonOverlayView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.buttonOverlayView.frame = CGRectMake(self.descriptionField.superview.frame.size.width - _buttonOffset, 
                                                  self.descriptionField.superview.frame.size.height - 48.0, 
                                                  _buttonOffset, 
                                                  52.0);
        
        UIColor *grayBackgroundColor = [UIColor colorWithWhite:0.99 alpha:1.0];
        self.buttonOverlayView.superview.backgroundColor = grayBackgroundColor;
        self.descriptionField.backgroundColor = grayBackgroundColor;
        self.view.backgroundColor = grayBackgroundColor;
    }
}

- (void)addScreenshotButton {
    if ([[JMC sharedInstance] isPhotosEnabled]) {
        self.screenshotButton = [self buttonFor:@"icon_capture" action:@selector(addScreenshot)];
        [self layoutActionButton:self.screenshotButton];
        [self.descriptionField.superview addSubview:self.screenshotButton]; 
    }
}

- (void)addVoiceButton {
    if ([[JMC sharedInstance] isVoiceEnabled]) {
        self.voiceButton = [self buttonFor:@"icon_record" action:@selector(addVoice)];
        [self layoutActionButton:self.voiceButton];
        [self.descriptionField.superview addSubview:self.voiceButton]; 
    }
}

- (void)addShadowToImageView:(UIImageView *)imageView {
    imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 0.8;
    imageView.layer.shadowOffset = CGSizeMake(1, 1);
    imageView.layer.shadowRadius = 1.0;
}

- (void)addImageViewsToAttachmentsButton:(NSArray *)imageViews {
    static NSUInteger kIconMaxCount = 3;
    static float kIconMaxWidth = 30;
    
    NSUInteger maxViews = MIN([imageViews count], kIconMaxCount);
    float size = (kIconMaxWidth - (maxViews - 1) * kIconMaxCount);
    float offset = ceil((self.attachmentsButton.frame.size.width - kIconMaxWidth) / 2);
    for (NSUInteger imgIndex = 1; imgIndex <= maxViews; imgIndex++) {
        float position = offset + (imgIndex - 1) * kIconMaxCount;
        UIImageView *imageView = [imageViews objectAtIndex:[imageViews count] - imgIndex];
        imageView.frame = CGRectMake(position, position, size, size);
        [self addShadowToImageView:imageView];
        [self.attachmentsButton insertSubview:imageView atIndex:0];
    }
    
}

- (NSMutableArray *)removeImageViewsFromAttachmentsButton {
    NSMutableArray *subviews = [[self.attachmentsButton subviews] mutableCopy];
    for (UIView *subview in subviews) {
        if (subview.tag == kJMCTag) {
            [subview removeFromSuperview];
        }
        else {
            [subviews removeObject:subview];
        }
    }
    return [subviews autorelease];
}

- (void)addAttachmentsButton {
    if (!self.attachmentsButton) {
        self.attachmentsButton = [self buttonFor:nil action:@selector(viewAttachments:)];
        self.attachmentsButton.showsTouchWhenHighlighted = YES;
        [self layoutActionButton:self.attachmentsButton];
        [self.descriptionField.superview addSubview:self.attachmentsButton]; 
        [self layoutButtonOverlayView];
    }
}

- (void)addAttachmentsButtonWithIcon:(UIImage *)icon {
    [self addAttachmentsButton];
    
    NSMutableArray *subviews = [self removeImageViewsFromAttachmentsButton];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
    iconView.tag = kJMCTag;
    [subviews addObject:iconView];
    [iconView release];
    
    [self addImageViewsToAttachmentsButton:subviews];
}

- (void)reloadAttachmentsButton {
    [self addAttachmentsButton];
    
    NSMutableArray *subviews = [self removeImageViewsFromAttachmentsButton];
    [subviews removeAllObjects];
    
    for (JMCAttachmentItem *attachment in self.attachments) {
        if (attachment.thumbnail) {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:attachment.thumbnail];
            iconView.tag = kJMCTag;
            [subviews insertObject:iconView atIndex:0];
            [iconView release];
        }
    }
    
    if ([subviews count] > 0) {
        [self addImageViewsToAttachmentsButton:subviews];
    }
    else {
        [self.attachmentsButton removeFromSuperview];
        self.attachmentsButton = nil;
        _buttonOffset -= kJMCButtonSpacing;
        
        [self layoutButtonOverlayView];
    }
}

- (void)deleteAttachments {
    [self.attachments removeAllObjects];
    
    if (self.attachmentsButton) {
        [self.attachmentsButton removeFromSuperview];
        self.attachmentsButton = nil;
        _buttonOffset -= kJMCButtonSpacing;
        
        [self layoutButtonOverlayView];
    }
}

- (void)addButtonsToView {
    // Offset from right side (iPhone) or top (iPad)
    _buttonOffset = kJMCInitialButtonOffset;
    
    // Add buttons
    [self configureButtonOverlayView];
    [self addScreenshotButton];
    [self addVoiceButton];
    [self layoutButtonOverlayView];

    // If the offset is bigger than 5, than at least one button was added
    if (_buttonOffset > kJMCInitialButtonOffset) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.descriptionField.jmc_width -= kJMCButtonSpacing;
        }
        else {
            self.descriptionField.jmc_height -= kJMCButtonSpacing;
        }
    }
}

- (UIButton *)buttonFor:(NSString *)iconNamed action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:iconNamed] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    return button;
}

- (BOOL)shouldTrackLocation {
    return [[JMC sharedInstance] isLocationEnabled] && [CLLocationManager locationServicesEnabled];
}

- (void)dismissKeyboard
{
    [self.descriptionField resignFirstResponder];
}

- (void)updateProgress:(NSTimer *)theTimer
{
    JMCRecorder* recorder = [JMCRecorder instance];
    float currentDuration = [recorder currentDuration];
    float progress = (currentDuration / recorder.recordTime);
    self.progressView.progress = progress;
}

- (void)hideAudioProgress
{
    self.countdownView.hidden = YES;
    self.progressView.progress = 0;
    [self.voiceButton.imageView stopAnimating];
    self.voiceButton.imageView.animationImages = nil;
    [_timer invalidate];
}

- (void)addAttachmentItem:(JMCAttachmentItem *)attachment withIcon:(UIImage *)icon action:(SEL)action
{
    
    [self.attachments insertObject:attachment atIndex:0]; // attachments must be kept in sycnh with buttons

    [self addAttachmentsButtonWithIcon:icon];
}

- (void)addImageAttachmentItem:(UIImage *)origImg
{
    JMCAttachmentItem *attachment = [[JMCAttachmentItem alloc] initWithName:@"screenshot"
                                                                       data:UIImagePNGRepresentation(origImg)
                                                                       type:JMCAttachmentTypeImage
                                                                contentType:@"image/png"
                                                             filenameFormat:@"screenshot-%d.png"];
    
    
    attachment.thumbnail = [origImg jmc_thumbnailImage:34 transparentBorder:0 cornerRadius:3.0 interpolationQuality:kCGInterpolationDefault];
    [self addAttachmentItem:attachment withIcon:attachment.thumbnail action:@selector(imageAttachmentTapped:)];
    [attachment release];
}

- (void)removeAttachmentItemAtIndex:(NSUInteger)attachmentIndex
{
    [self.attachments removeObjectAtIndex:attachmentIndex];
    // TODO
}

#pragma mark - Memory Managment Methods

@synthesize descriptionField, countdownView, progressView, currentLocation, locationManager = _locationManager, popover;
@synthesize attachmentsViewController, buttonOverlayView;
@synthesize issueTransport = _issueTransport, replyTransport = _replyTransport, attachments = _attachments, replyToIssue = _replyToIssue;
@synthesize voiceButton = _voiceButton, screenshotButton = _screenshotButton, attachmentsButton = _attachmentsButton;

- (void)dealloc
{
    // Release any retained subviews of the main view.
    [self internalRelease];

    // Release these vars only if controller is deallocated
    self.attachments = nil;
    self.currentLocation = nil;
    
    [super dealloc];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    [self internalRelease];
    [super viewDidUnload];
}

- (void)internalRelease
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;

    self.attachmentsButton = nil;
    self.attachmentsViewController = nil;
    self.voiceButton = nil;
    self.screenshotButton = nil;
    self.progressView = nil;
    self.replyToIssue = nil;
    self.countdownView = nil;
    self.descriptionField = nil;
    self.replyTransport = nil;
    self.issueTransport = nil;
    self.popover = nil;
}

@end
