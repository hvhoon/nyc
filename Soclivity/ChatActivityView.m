//
//  ChatActivityView.m
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import "ChatActivityView.h"
#import "SoclivityUtilities.h"
#import "Message.h"
#import "NSString+Additions.h"

#define CHAT_BACKGROUND_COLOR [SoclivityUtilities returnBackgroundColor:0]

#define VIEW_WIDTH    self.frame.size.width
#define VIEW_HEIGHT    self.frame.size.height

#define RESET_CHAT_BAR_HEIGHT    SET_CHAT_BAR_HEIGHT(kChatBarHeight1)
#define EXPAND_CHAT_BAR_HEIGHT    SET_CHAT_BAR_HEIGHT(kChatBarHeight4)
#define    SET_CHAT_BAR_HEIGHT(HEIGHT)\
CGRect chatContentFrame = chatTableView.frame;\
chatContentFrame.size.height = VIEW_HEIGHT - HEIGHT;\
[UIView beginAnimations:nil context:NULL];\
[UIView setAnimationDuration:0.1f];\
chatTableView.frame = chatContentFrame;\
chatBar.frame = CGRectMake(chatBar.frame.origin.x, chatContentFrame.size.height,\
VIEW_WIDTH, HEIGHT);\
[UIView commitAnimations]

#define BAR_BUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE\
style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define ClearConversationButtonIndex 0

#define SECONDS_BETWEEN_MESSAGES        (1)

static CGFloat const kSentDateFontSize = 13.0f;
static CGFloat const kMessageFontSize   = 16.0f;   // 15.0f, 14.0f
static CGFloat const kMessageTextWidth  = 180.0f;
static CGFloat const kContentHeightMax  = 84.0f;  // 80.0f, 76.0f
static CGFloat const kChatBarHeight1    = 45.0f;
static CGFloat const kChatBarHeight4    = 94.0f;


@implementation ChatActivityView
@synthesize delegate=_delegate,chatTableView=_chatTableView;
@synthesize receiveMessageSound;
@synthesize chatBar;
@synthesize chatInput;
@synthesize previousContentHeight;
@synthesize sendButton;

@synthesize cellMap;

- (void)dealloc {
    if (receiveMessageSound) AudioServicesDisposeSystemSoundID(receiveMessageSound);
    
    
    [chatBar release];
    [chatInput release];
    [sendButton release];
    [cellMap release];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIView*)loadTableHeader:(BOOL)response{
    
    UIView *loadMoreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 52.0f)];
    loadMoreFooterView.backgroundColor = [UIColor whiteColor];
	loadMoreFooterView.tag=145;
    UILabel *loadMoreChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 120, 16)];
    
    loadMoreChatLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    loadMoreChatLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    loadMoreChatLabel.textAlignment = UITextAlignmentLeft;
    
    UIActivityIndicatorView*friendSpinnerLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    friendSpinnerLoadMore.frame = CGRectMake(30,15, 25, 25);
    [friendSpinnerLoadMore startAnimating];
    [loadMoreFooterView addSubview:friendSpinnerLoadMore];
    
    [friendSpinnerLoadMore setHidden:NO];
    if(response){
        loadMoreChatLabel.text=[NSString stringWithFormat:@"Loading..."];
        
    }
    else
    loadMoreChatLabel.text=@"No more messages";
	
	[loadMoreFooterView addSubview:loadMoreChatLabel];
    [loadMoreChatLabel release];
    return loadMoreFooterView;

}

-(void)updateChatScreen:(NSMutableArray*)updatedChatArray{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.backgroundColor = CHAT_BACKGROUND_COLOR; // shown during rotation

    if([updatedChatArray count]==0){
        [self setUpBackgroundView];
    }
    else{
        [self SetupChatTableView];
    }
    
    chatBar = [[UIImageView alloc] initWithFrame:
               CGRectMake(0.0f, self.frame.size.height-kChatBarHeight1,
                          self.frame.size.width, kChatBarHeight1)];
    chatBar.clearsContextBeforeDrawing = NO;
    chatBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleWidth;
    chatBar.image = [[UIImage imageNamed:@"S05.3_enterTextBackground.png"]
                     stretchableImageWithLeftCapWidth:18 topCapHeight:20];
    chatBar.userInteractionEnabled = YES;
    
    
    // Create chatInput.
    chatInput = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 247.0f, 30.0f)];
    chatInput.contentSize = CGSizeMake(247.0f, 30.0f);
    chatInput.delegate = self;
    chatInput.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    chatInput.scrollEnabled = NO; // not initially
    chatInput.scrollIndicatorInsets = UIEdgeInsetsMake(5.0f, 0.0f, 4.0f, -2.0f);
    chatInput.clearsContextBeforeDrawing = NO;
    chatInput.font = [UIFont fontWithName:@"Helvetica-Condensed" size:kMessageFontSize];
    chatInput.dataDetectorTypes = UIDataDetectorTypeAll;
    chatInput.backgroundColor = [UIColor clearColor];
    previousContentHeight = chatInput.contentSize.height;
    [chatBar addSubview:chatInput];
    
    // Create sendButton.
    sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    sendButton.clearsContextBeforeDrawing = NO;
    sendButton.frame = CGRectMake(chatBar.frame.size.width - 65.0f, 7.5f, 56.0f, 30.0f);
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | // multi-line input
    UIViewAutoresizingFlexibleLeftMargin;                       // landscape
    UIImage *sendButtonNormal = [UIImage imageNamed:@"S05.3_sendActive.png"];
    UIImage *sendButtonDisabled = [UIImage imageNamed:@"S05.3_sendInactive.png"];
    [sendButton setBackgroundImage:sendButtonNormal forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendButtonDisabled forState:UIControlStateDisabled];
    [sendButton addTarget:self action:@selector(sendMessage)
         forControlEvents:UIControlEventTouchUpInside];
    [self resetSendButton]; // disable initially
    [chatBar addSubview:sendButton];
    
    [self addSubview:chatBar];
    //[self sendSubviewToBack:chatBar];
    
    chatBar.hidden=YES;
    
    cellMap = [[NSMutableArray alloc]
               initWithCapacity:[updatedChatArray count]*3];

    
    
    for (Message *message in updatedChatArray) {
        [self addMessage:message];
    }


}

- (void)resetSendButton {
    sendButton.enabled = NO;
}


-(void)setUpBackgroundView{
    CGRect noChatTableRect;
    
    CGRect fadedRect;
    CGRect noChatRect;
    UIImageView *logoFadedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S11_logoFaded.png"]];
    UIImageView *noChatImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05.3_chatBlankImage.png"]];

    
    if([SoclivityUtilities deviceType] & iPhone5){
        noChatTableRect=CGRectMake(0, 0, 320, 504);
        fadedRect=CGRectMake(105, 389, 111, 28);
        noChatRect=CGRectMake(75, 142, 169, 149);

    }
    
    else{
        noChatTableRect=CGRectMake(0, 0, 320,416);
        fadedRect=CGRectMake(105, 339, 111, 28);
        noChatRect=CGRectMake(75, 102, 169, 149);
    }
    
    self.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    chatBackgroundView=[[UIView alloc]initWithFrame:noChatTableRect];
    noChatImageView.frame=noChatRect;
    [chatBackgroundView addSubview:noChatImageView];
    
    logoFadedImageView.frame=fadedRect;
    [chatBackgroundView addSubview:logoFadedImageView];
    [self addSubview:chatBackgroundView];
    
    
}
-(void)SetupChatTableView{
    CGRect chatTableRect;
    
    if([SoclivityUtilities deviceType] & iPhone5)
        chatTableRect=CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-kChatBarHeight1);
    
    else
        chatTableRect=CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-kChatBarHeight1);
    
    self.chatTableView=[[UITableView alloc] initWithFrame:chatTableRect style:UITableViewStylePlain];
    self.chatTableView.clearsContextBeforeDrawing = NO;

    [self.chatTableView setDelegate:self];
    [self.chatTableView setDataSource:self];
    self.chatTableView.scrollEnabled=YES;
    self.chatTableView.backgroundView=nil;
    //[self.chatTableView setTableHeaderView:[self loadTableHeader]];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor=CHAT_BACKGROUND_COLOR;
    self.chatTableView.separatorColor = [UIColor clearColor];
    //self.chatTableView.contentInset = UIEdgeInsetsMake(7.0f, 0.0f, 0.0f, 0.0f);
    self.chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.chatTableView.clipsToBounds=YES;

    self.chatTableView.showsVerticalScrollIndicator=YES;
    [self addSubview:self.chatTableView];
    

    
    //[self.chatTableView setContentOffset:CGPointMake(0, 1*50)];

}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat contentHeight = textView.contentSize.height - kMessageFontSize + 2.0f;
    NSString *rightTrimmedText = @"";
    
    //    NSLog(@"contentOffset: (%f, %f)", textView.contentOffset.x, textView.contentOffset.y);
    //    NSLog(@"contentInset: %f, %f, %f, %f", textView.contentInset.top, textView.contentInset.right,
    //          textView.contentInset.bottom, textView.contentInset.left);
    //    NSLog(@"contentSize.height: %f", contentHeight);
    
    if ([textView hasText]) {
        rightTrimmedText = [textView.text
                            stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
        
        //        if (textView.text.length > 1024) { // truncate text to 1024 chars
        //            textView.text = [textView.text substringToIndex:1024];
        //        }
        
        // Resize textView to contentHeight
        if (contentHeight != previousContentHeight) {
            if (contentHeight <= kContentHeightMax) { // limit chatInputHeight <= 4 lines
                CGFloat chatBarHeight = contentHeight + 18.0f;
                SET_CHAT_BAR_HEIGHT(chatBarHeight);
                if (previousContentHeight > kContentHeightMax) {
                    textView.scrollEnabled = NO;
                }
                textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk//6
                [self scrollToBottomAnimated:YES];
            } else if (previousContentHeight <= kContentHeightMax) { // grow
                textView.scrollEnabled = YES;
                textView.contentOffset = CGPointMake(0.0f, contentHeight-68.0f); // shift to bottom
                if (previousContentHeight < kContentHeightMax) {
                    EXPAND_CHAT_BAR_HEIGHT;
                    [self scrollToBottomAnimated:YES];
                }
            }
        }
    } else { // textView is empty
        if (previousContentHeight > 22.0f) {
            RESET_CHAT_BAR_HEIGHT;
            if (previousContentHeight > kContentHeightMax) {
                textView.scrollEnabled = NO;
            }
        }
        textView.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
    }
    
    // Enable sendButton if chatInput has non-blank text, disable otherwise.
    if (rightTrimmedText.length > 0) {
        [self enableSendButton];
    } else {
        [self disableSendButton];
    }
    
    previousContentHeight = contentHeight;
}

// Fix a scrolling quirk.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    return YES;
}

#pragma mark ChatViewController

- (void)enableSendButton {
    if (sendButton.enabled == NO) {
        sendButton.enabled = YES;
    }
}

- (void)disableSendButton {
    if (sendButton.enabled == YES) {
        [self resetSendButton];
    }
}



# pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self resizeViewWithOptions:[notification userInfo]];
}

- (void)resizeViewWithOptions:(NSDictionary *)options {
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[options objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[options objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[options objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    CGRect viewFrame = self.frame;
    NSLog(@"viewFrame y: %@", NSStringFromCGRect(viewFrame));
    
    //    // For testing.
    //    NSLog(@"keyboardEnd: %@", NSStringFromCGRect(keyboardEndFrame));
    //    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
    //                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
    //                             target:chatInput action:@selector(resignFirstResponder)];
    //    self.navigationItem.leftBarButtonItem = doneButton;
    //    [doneButton release];
    
    CGRect keyboardFrameEndRelative = [self convertRect:keyboardEndFrame fromView:nil];
    NSLog(@"self: %@", self);
    NSLog(@"keyboardFrameEndRelative: %@", NSStringFromCGRect(keyboardFrameEndRelative));
    
    viewFrame.size.height =  keyboardFrameEndRelative.origin.y;
    self.frame = viewFrame;
    [UIView commitAnimations];
    
    [self scrollToBottomAnimated:YES];
    
    chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger bottomRow = [cellMap count] - 1;
    if (bottomRow >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bottomRow inSection:0];
        [_chatTableView scrollToRowAtIndexPath:indexPath
                           atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark Message

-(void)userPostedAnImage:(Message*)post{
    [self updateDataBaseFromChatScreen:post type:1];
    
    
    [self scrollToBottomAnimated:YES]; // must come after RESET_CHAT_BAR_HEIGHT above
   
}

- (void)sendMessage {
    
    //    // TODO: Show progress indicator like iPhone Message app does. (Icebox)
    //    [activityIndicator startAnimating];
    
    NSString *rightTrimmedMessage =
    [chatInput.text stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
    
    // Don't send blank messages.
    if (rightTrimmedMessage.length == 0) {
        [self clearChatInput];
        return;
    }
    Message *newMessage=[[Message alloc]init];
    // Create new message and save to Core Data.
    newMessage.text = rightTrimmedMessage;
    newMessage.isImage=NO;
    
    if(random() % 2){
    newMessage.isMine=YES;
    }
    else{
        newMessage.isMine=NO;
    }
    newMessage.textDate = [NSDate date];
    
//save in the database
    [self updateDataBaseFromChatScreen:newMessage type:1];
    
    [self clearChatInput];
    
    [self scrollToBottomAnimated:YES]; // must come after RESET_CHAT_BAR_HEIGHT above
    
    // Play sound or buzz, depending on user settings.
//    NSString *sendPath = [[NSBundle mainBundle] pathForResource:@"basicsound" ofType:@"wav"];
//    CFURLRef baseURL = (CFURLRef)[NSURL fileURLWithPath:sendPath];
//    AudioServicesCreateSystemSoundID(baseURL, &receiveMessageSound);
//    AudioServicesPlaySystemSound(receiveMessageSound);
    //    AudioServicesPlayAlertSound(receiveMessageSound); // use for receiveMessage (sound & vibrate)
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // explicit vibrate
}

- (void)clearChatInput {
    chatInput.text = @"";
    if (previousContentHeight > 22.0f) {
        RESET_CHAT_BAR_HEIGHT;
        chatInput.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
        chatInput.contentOffset = CGPointMake(0.0f, 6.0f); // fix quirk
        [self scrollToBottomAnimated:YES];
    }
}
#if 0
-(NSUInteger)addMessage:(Message *)message{
    
    if(!message.isMine){
        [cellMap addObject:@"Kanav Gupta"];
    }
    [cellMap addObject:message];
    [cellMap addObject:message.textDate];
    
    if(message.isMine)
        return 2;
    else
        return 3;

    
}
#else
- (NSUInteger)addMessage:(Message *)message
{
    // Show sentDates at most every 15 minutes.
    NSDate *currentSentDate = message.textDate;
    NSUInteger numberOfObjectsAdded = 1;
   // NSUInteger prevIndex = [cellMap count] - 2;
    
    // Show sentDates at most every 15 minutes.
    
    if([cellMap count])
    {
        
        
        numberOfObjectsAdded=2;
        if(!message.isMine){
            [cellMap addObject:@"Kanav Gupta"];
            numberOfObjectsAdded = 3;
        }
        
        [cellMap addObject:message];
        
        // there are NO messages, definitely add a timestamp!
        [cellMap addObject:currentSentDate];

#if 0
        BOOL prevIsMessage = [[cellMap objectAtIndex:prevIndex] isKindOfClass:[Message class]];
        if(prevIsMessage)
        {
            Message * temp = [cellMap objectAtIndex:prevIndex];
            NSDate * previousSentDate = temp.textDate;
            // if there has been more than a 15 min gap between this and the previous message!
            if([currentSentDate timeIntervalSinceDate:previousSentDate] > SECONDS_BETWEEN_MESSAGES)
            {
                [cellMap addObject:@"Kanav Gupta"];
                [cellMap addObject:message];
                [cellMap addObject:currentSentDate];
                numberOfObjectsAdded = 3;
            }
        }
#endif
    }
    else
    {
        numberOfObjectsAdded=2;
        if(!message.isMine){
            [cellMap addObject:@"Harish Hoon"];
            numberOfObjectsAdded = 3;
        }

        [cellMap addObject:message];

        // there are NO messages, definitely add a timestamp!
        [cellMap addObject:currentSentDate];
    }
    
    
    return numberOfObjectsAdded;
    
}
#endif

- (NSUInteger)removeMessageAtIndex:(NSUInteger)index {
    //    NSLog(@"Delete message from cellMap");
    
    // Remove message from cellMap.
    [cellMap removeObjectAtIndex:index];
    NSUInteger numberOfObjectsRemoved = 1;
    NSUInteger prevIndex = index - 1;
    NSUInteger cellMapCount = [cellMap count];
    
    BOOL isLastObject = index == cellMapCount;
    BOOL prevIsDate = [[cellMap objectAtIndex:prevIndex] isKindOfClass:[NSDate class]];
    
    if (isLastObject && prevIsDate ||
        prevIsDate && [[cellMap objectAtIndex:index] isKindOfClass:[NSDate class]]) {
        [cellMap removeObjectAtIndex:prevIndex];
        numberOfObjectsRemoved = 2;
    }
    return numberOfObjectsRemoved;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellMap count];
}

#define SENT_DATE_TAG 101
#define SENT_DATE_TAG2 107
#define TEXT_TAG 102
#define BACKGROUND_TAG 103
#define PlayerNameTAG 104
#define BORDER_TAG 105
#define POSTIMAGE_TAG 106
static NSString *kMessageCell = @"MessageCell";

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *msgSentDate=nil;
    UILabel *playerNameLabel=nil;
    UIImageView *msgBackground=nil;
    UILabel *msgText=nil;
    UIImageView *borderImageView=nil;
    UIImageView *chatPostImageView=nil;
    
    //    NSLog(@"cell for row: %d", [indexPath row]);
    
    NSObject *object = [cellMap objectAtIndex:[indexPath row]];
    UITableViewCell *cell=nil;
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setTimeZone:gmt];
    }

    
    for (UIView *view in cell.contentView.subviews)
    {
        if (![view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }


    
    // Handle sentDate (NSDate).
    if ([object isKindOfClass:[NSDate class]]) {
        static NSString *kSentDateCellId = @"SentDateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:kSentDateCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kSentDateCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Create message sentDate lable
            
            CGSize  size = [[SoclivityUtilities nofiticationTime:[dateFormatter stringFromDate:(NSDate *)object]] sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:kSentDateFontSize]];

            msgSentDate = [[UILabel alloc] initWithFrame:
                           CGRectMake(15.0f, 0.0f,
                                      size.width, kSentDateFontSize+5.0f)];
            msgSentDate.clearsContextBeforeDrawing = NO;
            msgSentDate.font = [UIFont fontWithName:@"Helvetica-Condensed" size:kSentDateFontSize];
            msgSentDate.textColor=[SoclivityUtilities returnTextFontColor:5];

            Message *obj=[cellMap objectAtIndex:[indexPath row]-1];

            if(obj.isMine){
                msgSentDate.tag=SENT_DATE_TAG2;
                msgSentDate.frame=CGRectMake(tableView.frame.size.width-size.width-20,0.0f,size.width,kSentDateFontSize+5.0f);
                
                // msgSentDate.frame=CGRectMake(tableView.frame.size.width-size.width-20,0.0f,size.width,kSentDateFontSize+5.0f);
                
                msgSentDate.textAlignment = UITextAlignmentRight;

            }
            else{
                
                msgSentDate.textAlignment = UITextAlignmentLeft;
                msgSentDate.tag = SENT_DATE_TAG;

                
                
            }
            msgSentDate.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
            msgSentDate.textColor = [UIColor grayColor];
            [cell addSubview:msgSentDate];
            [msgSentDate release];
        } else {
            
            Message *obj=[cellMap objectAtIndex:[indexPath row]-1];
            
            if(obj.isMine){
                msgSentDate = (UILabel *)[cell viewWithTag:SENT_DATE_TAG2];
                
            }
            else{
                msgSentDate = (UILabel *)[cell viewWithTag:SENT_DATE_TAG];

            }
        }
        
        

        
        msgSentDate.text = [SoclivityUtilities nofiticationTime:[dateFormatter stringFromDate:(NSDate *)object]];
        
        return cell;
    }
    
    else if ([object isKindOfClass:[NSString class]]) {
        static NSString *KPlayerNameCellId = @"PlayerNameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KPlayerNameCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:KPlayerNameCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            CGSize  size = [(NSString *)object sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed" size:kSentDateFontSize]];

            playerNameLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(15.0f, 0.0f,
                                      size.width, kSentDateFontSize+5.0f)];
            playerNameLabel.clearsContextBeforeDrawing = NO;
            playerNameLabel.tag = PlayerNameTAG;
            playerNameLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:kSentDateFontSize];
            playerNameLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
            playerNameLabel.textAlignment = UITextAlignmentLeft;
            playerNameLabel.backgroundColor = CHAT_BACKGROUND_COLOR;
            playerNameLabel.textColor = [UIColor grayColor];
            [cell addSubview:playerNameLabel];
            [playerNameLabel release];
        } else {
            playerNameLabel = (UILabel *)[cell viewWithTag:PlayerNameTAG];
        }
        
        playerNameLabel.text =(NSString *)object;
        
        return cell;
    }
    else{
    Message *obj=[cellMap objectAtIndex:[indexPath row]];

    // Handle Message object.
    cell = [tableView dequeueReusableCellWithIdentifier:kMessageCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kMessageCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        

        
        // Create message background image view
        msgBackground = [[UIImageView alloc] init];
        msgBackground.clearsContextBeforeDrawing = NO;
        msgBackground.tag = BACKGROUND_TAG;
        msgBackground.backgroundColor = CHAT_BACKGROUND_COLOR; 
        [cell.contentView addSubview:msgBackground];
        [msgBackground release];
        
        if(obj.isImage){
            chatPostImageView = [[UIImageView alloc] init];
            chatPostImageView.clearsContextBeforeDrawing = NO;
            chatPostImageView.tag = POSTIMAGE_TAG;
            chatPostImageView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:chatPostImageView];
            [chatPostImageView release];
            
        }else{
        
        // Create message text label
        msgText = [[UILabel alloc] init];
        msgText.clearsContextBeforeDrawing = NO;
        msgText.tag = TEXT_TAG;
        msgText.backgroundColor = [UIColor clearColor];
        msgText.numberOfLines = 0;
        msgText.lineBreakMode = UILineBreakModeWordWrap;
        msgText.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:kMessageFontSize];
        [cell.contentView addSubview:msgText];
        [msgText release];
        }
    } else {
        
        if(obj.isImage){
        chatPostImageView = (UIImageView *)[cell.contentView viewWithTag:POSTIMAGE_TAG];
        }
        else{
        msgText = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];

        }
        msgBackground = (UIImageView *)[cell.contentView viewWithTag:BACKGROUND_TAG];
        borderImageView=(UIImageView *)[cell.contentView viewWithTag:BORDER_TAG];
    }
    
    if(obj.isImage){
        
        UIImage *bubbleImage;
        if (obj.isMine) { // right bubble
            
            msgBackground.frame = CGRectMake(tableView.frame.size.width-150,
                                             3+5, 150+25,
                                             150+12);
            bubbleImage = [[UIImage imageNamed:@"S05.3_chatBubbleBlue.png"]
                           stretchableImageWithLeftCapWidth:15 topCapHeight:13];
            
            chatPostImageView.frame=CGRectMake(tableView.frame.size.width-150,
                                               8+12, 150.0f, 150.0f);
            
            
            obj.dateFrameOrigin=tableView.frame.size.width-150-5;
            
        } else { // left bubble
            
            
            borderImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S11_frame.png"]];
            borderImageView.frame=CGRectMake(15, 0, 37,37);
            borderImageView.backgroundColor=[UIColor clearColor];
            borderImageView.tag=BORDER_TAG;
            [borderImageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.contentView addSubview:borderImageView];

            msgBackground.frame = CGRectMake(15+40,5,
                                             150+19, 150+12);
            borderImageView.frame=CGRectMake(15,0, 37,37);
            bubbleImage = [[UIImage imageNamed:@"S05.3_chatBubbleGray.png"]
                           stretchableImageWithLeftCapWidth:23 topCapHeight:15];
            
            chatPostImageView.frame=CGRectMake(12+15+40,
                                               8, 150.0f, 150.0f);
            

            
            obj.dateFrameOrigin=15+40+22.0f+5.0f;
            
            [borderImageView release];

        }
        msgBackground.image = bubbleImage;
        chatPostImageView.image=obj.postImage;
    }
    else{
    
    // Configure the cell to show the message in a bubble. Layout message cell & its subviews.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    UIImage *bubbleImage;
    if (obj.isMine) { // right bubble
        
        msgBackground.frame = CGRectMake(tableView.frame.size.width-size.width-34.0f-10,
                                         kMessageFontSize-13.0f+5, size.width+34.0f,
                                         size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"S05.3_chatBubbleBlue.png"]
                       stretchableImageWithLeftCapWidth:15 topCapHeight:13];
        msgText.frame = CGRectMake(tableView.frame.size.width-size.width-22.0f,
                                   kMessageFontSize-9.0f, size.width+5.0f, size.height);
        
        obj.dateFrameOrigin=tableView.frame.size.width-size.width-22.0f+size.width;
        
    } else { // left bubble
        msgBackground.frame = CGRectMake(15+40,kMessageFontSize-13.0f+5,
                                         size.width+34.0f, size.height+12.0f);
        
        borderImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S11_frame.png"]];
        borderImageView.frame=CGRectMake(15, 0, 37,37);
        borderImageView.backgroundColor=[UIColor clearColor];
        borderImageView.tag=BORDER_TAG;
        [borderImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:borderImageView];

        bubbleImage = [[UIImage imageNamed:@"S05.3_chatBubbleGray.png"]
                       stretchableImageWithLeftCapWidth:15 topCapHeight:13];//23 //15
        
        obj.dateFrameOrigin=15+40+22.0f+5.0f;

        msgText.frame = CGRectMake(22.0f+15+40, kMessageFontSize-9.0f, size.width+5.0f, size.height);
        [borderImageView release];
    }
    msgBackground.image = bubbleImage;
    msgText.text = [(Message *)object text];
    }
        
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"height for row: %d", [indexPath row]);
    
    NSObject *object = [cellMap objectAtIndex:[indexPath row]];
    
    // Set SentDateCell height.
    if ([object isKindOfClass:[NSDate class]]) {
        return kSentDateFontSize + 7.0f;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return kSentDateFontSize + 7.0f;
    }
    

    if([object isKindOfClass:[Message class]]){
        Message *obj=(Message*)object;
        if(obj.isImage){
            
            return 150.0f+22.0f;
        }else{
    // Set MessageCell height.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 17.0f+5.0f;
        
    }
    }
    return 0.0f;
}

#pragma mark -
#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if([scrollView contentOffset].y == scrollView.frame.origin.y){
        
        [self.chatTableView setTableHeaderView:[self loadTableHeader:YES]];
        [self performSelector:@selector(stopAnimatingHeader) withObject:nil afterDelay:5.0];
	}
    
    
}

- (void) addItemsToStartOfTableView{
    NSMutableArray *arr1=[NSMutableArray arrayWithCapacity:10*3];
    for(int i=0;i<10;i++){
        Message *testMessage=[[Message alloc]init];
        testMessage.textDate=[NSDate date];
        testMessage.text=@"No worries";
        if(random() % 2){
            testMessage.isMine=YES;
        }
        else{
            testMessage.isMine=NO;
        }
        testMessage.isImage=NO;

        if(!testMessage.isMine){
            [arr1 addObject:@"Harish Hoon"];
            
        }
        [arr1 addObject:testMessage];
        
        // there are NO messages, definitely add a timestamp!
        [arr1 addObject:[NSDate date]];


    }
    
    NSMutableArray *testArray=[NSMutableArray arrayWithCapacity:[arr1 count]+[cellMap count]];
    [testArray addObjectsFromArray:arr1];
    [testArray addObjectsFromArray:cellMap];
    [cellMap removeAllObjects];
    cellMap=[testArray retain];
}



//stop the header spinner
- (void) stopAnimatingHeader{
    //add the data
    
    [self addItemsToStartOfTableView];
    //set an offset so visible cells aren't blasted
    
    //[self.chatTableView setContentOffset:CGPointMake(0, 10*(kSentDateFontSize + 15.0f))];
    [self.chatTableView reloadData];
    [self.chatTableView setTableHeaderView:nil];
}



-(void)updateDataBaseFromChatScreen:(id)message type:(NSInteger)type{
    
    NSArray *indexPaths=nil;
    
    switch(type) {
        case 1: {
            NSUInteger cellCount = [cellMap count];
            
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:cellCount inSection:0];
            
            switch ([self
                      addMessage:message]) {
                case 1:
                {
                    
                }
                    break;
                    
                case 2:
                { // 2
                    //                NSLog(@"insert 2 rows at index: %d", cellCount);
                    indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath,
                                  [NSIndexPath indexPathForRow:cellCount+1 inSection:0], nil];
                }
                    break;

                    
                case 3:
                {
                    indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath,
                                  [NSIndexPath indexPathForRow:cellCount+1 inSection:0],[NSIndexPath indexPathForRow:cellCount+2 inSection:0], nil];
                    
                }
                    break;

                    
                default:
                    break;
            }
#if 0
            if ([self addMessage:message] == 1) {
                //                NSLog(@"insert 1 row at index: %d", cellCount);
                indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath, nil];
            } else if([self addMessage:message] == 2) { // 2
                //                NSLog(@"insert 2 rows at index: %d", cellCount);
                indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath,
                              [NSIndexPath indexPathForRow:cellCount+1 inSection:0], nil];
            }
            else{
                indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath,
                              [NSIndexPath indexPathForRow:cellCount+1 inSection:0],[NSIndexPath indexPathForRow:cellCount+2 inSection:0], nil];
                
            }
#endif
            [_chatTableView insertRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationNone];
            [indexPaths release];
            [self scrollToBottomAnimated:YES];
            break;
        }
        case 2: {
            NSUInteger objectIndex = [cellMap indexOfObjectIdenticalTo:message];
            NSIndexPath *objectIndexPath = [NSIndexPath indexPathForRow:objectIndex inSection:0];
            
            if ([self removeMessageAtIndex:objectIndex] == 1) {
                //                NSLog(@"delete 1 row");
                indexPaths = [[NSArray alloc] initWithObjects:objectIndexPath, nil];
            } else { // 2
                //                NSLog(@"delete 2 rows");
                indexPaths = [[NSArray alloc] initWithObjects:objectIndexPath,
                              [NSIndexPath indexPathForRow:objectIndex-1 inSection:0], nil];
            }
            
            [_chatTableView deleteRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationNone];
            [indexPaths release];
            break;
        }
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
