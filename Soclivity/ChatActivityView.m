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
        noChatTableRect=CGRectMake(0, 0, 320, 376+88);
        fadedRect=CGRectMake(105, 389, 111, 28);
        noChatRect=CGRectMake(75, 142, 169, 149);

    }
    
    else{
        noChatTableRect=CGRectMake(0, 0, 320, 376);
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
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor=CHAT_BACKGROUND_COLOR;
    self.chatTableView.separatorColor = [UIColor clearColor];
    self.chatTableView.contentInset = UIEdgeInsetsMake(7.0f, 0.0f, 0.0f, 0.0f);
    self.chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.chatTableView.clipsToBounds=YES;

    self.chatTableView.showsVerticalScrollIndicator=YES;
    [self addSubview:self.chatTableView];
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
    NSDate *now = [[NSDate alloc] init];
    newMessage.textDate = now;
    [now release];
    
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

- (NSUInteger)addMessage:(Message *)message
{
    // Show sentDates at most every 15 minutes.
    NSDate *currentSentDate = message.textDate;
    NSUInteger numberOfObjectsAdded = 1;
    NSUInteger prevIndex = [cellMap count] - 2;
    
    // Show sentDates at most every 15 minutes.
    
    if([cellMap count])
    {
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
    }
    else
    {
        [cellMap addObject:@"Kanav Gupta"];
        [cellMap addObject:message];

        // there are NO messages, definitely add a timestamp!
        [cellMap addObject:currentSentDate];
        numberOfObjectsAdded = 3;
    }
    
    
    return numberOfObjectsAdded;
    
}


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
    //    NSLog(@"number of rows: %d", [cellMap count]);
    return [cellMap count];
}

#define SENT_DATE_TAG 101
#define TEXT_TAG 102
#define BACKGROUND_TAG 103
#define PlayerNameTAG 104
static NSString *kMessageCell = @"MessageCell";

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *msgSentDate;
    UILabel *playerNameLabel;
    UIImageView *msgBackground;
    UILabel *msgText;
    
    //    NSLog(@"cell for row: %d", [indexPath row]);
    
    NSObject *object = [cellMap objectAtIndex:[indexPath row]];
    UITableViewCell *cell;
    
    // Handle sentDate (NSDate).
    if ([object isKindOfClass:[NSDate class]]) {
        static NSString *kSentDateCellId = @"SentDateCell";
        cell = [tableView dequeueReusableCellWithIdentifier:kSentDateCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:kSentDateCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Create message sentDate lable
            msgSentDate = [[UILabel alloc] initWithFrame:
                           CGRectMake(12.0f, 0.0f,
                                      tableView.frame.size.width, kSentDateFontSize+5.0f)];
            msgSentDate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            msgSentDate.clearsContextBeforeDrawing = NO;
            msgSentDate.tag = SENT_DATE_TAG;
            msgSentDate.font = [UIFont fontWithName:@"Helvetica-Condensed" size:kSentDateFontSize];
            msgSentDate.textColor=[SoclivityUtilities returnTextFontColor:5];

            msgSentDate.lineBreakMode = UILineBreakModeTailTruncation;
            if(indexPath.row%2==0)
                msgSentDate.textAlignment = UITextAlignmentLeft;
            else{
                msgSentDate.textAlignment = UITextAlignmentRight;
            }
            msgSentDate.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
            msgSentDate.textColor = [UIColor grayColor];
            [cell addSubview:msgSentDate];
            [msgSentDate release];
            //            // Uncomment for view layout debugging.
            //            cell.contentView.backgroundColor = [UIColor orangeColor];
            //            msgSentDate.backgroundColor = [UIColor orangeColor];
        } else {
            msgSentDate = (UILabel *)[cell viewWithTag:SENT_DATE_TAG];
        }
        
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
        }
        

        
        msgSentDate.text = [SoclivityUtilities nofiticationTime:[dateFormatter stringFromDate:(NSDate *)object]];
        
        return cell;
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        static NSString *KPlayerNameCellId = @"PlayerNameCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KPlayerNameCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:KPlayerNameCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Create message sentDate lable
            playerNameLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(12.0f, 0.0f,
                                      tableView.frame.size.width, kSentDateFontSize+5.0f)];
            playerNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            playerNameLabel.clearsContextBeforeDrawing = NO;
            playerNameLabel.tag = PlayerNameTAG;
            playerNameLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:kSentDateFontSize];
            playerNameLabel.textColor=[SoclivityUtilities returnTextFontColor:5];

            playerNameLabel.lineBreakMode = UILineBreakModeTailTruncation;
            if(indexPath.row%2==0)
                playerNameLabel.textAlignment = UITextAlignmentLeft;
            else{
                playerNameLabel.textAlignment = UITextAlignmentRight;
            }

            playerNameLabel.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
            playerNameLabel.textColor = [UIColor grayColor];
            [cell addSubview:playerNameLabel];
            [playerNameLabel release];
        } else {
            playerNameLabel = (UILabel *)[cell viewWithTag:PlayerNameTAG];
        }
        
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
        }
        
        
        
        playerNameLabel.text =(NSString *)object;
        
        return cell;
    }
    
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
        msgBackground.backgroundColor = CHAT_BACKGROUND_COLOR; // clearColor slows performance
        [cell.contentView addSubview:msgBackground];
        [msgBackground release];
        
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
    } else {
        msgBackground = (UIImageView *)[cell.contentView viewWithTag:BACKGROUND_TAG];
        msgText = (UILabel *)[cell.contentView viewWithTag:TEXT_TAG];
    }
    
    // Configure the cell to show the message in a bubble. Layout message cell & its subviews.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    UIImage *bubbleImage;
    if (!([indexPath row] % 2)) { // right bubble
        CGFloat editWidth = tableView.editing ? 32.0f : 0.0f;
        msgBackground.frame = CGRectMake(tableView.frame.size.width-size.width-34.0f-editWidth,
                                         kMessageFontSize-13.0f, size.width+34.0f,
                                         size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"S05.3_chatBubbleBlue.png"]
                       stretchableImageWithLeftCapWidth:15 topCapHeight:13];
        msgText.frame = CGRectMake(tableView.frame.size.width-size.width-22.0f-editWidth,
                                   kMessageFontSize-9.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        //        // Uncomment for view layout debugging.
        //        cell.contentView.backgroundColor = [UIColor blueColor];
    } else { // left bubble
        msgBackground.frame = CGRectMake(0.0f, kMessageFontSize-13.0f,
                                         size.width+34.0f, size.height+12.0f);
        bubbleImage = [[UIImage imageNamed:@"S05.3_chatBubbleGray.png"]
                       stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        msgText.frame = CGRectMake(22.0f, kMessageFontSize-9.0f, size.width+5.0f, size.height);
        msgBackground.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        msgText.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    msgBackground.image = bubbleImage;
    msgText.text = [(Message *)object text];
#if 0
    // Mark message as read.
    // Let's instead do this (asynchronously) from loadView and iterate over all messages
    if (![(Message *)object read]) { // not read, so save as read
        [(Message *)object setRead:[NSNumber numberWithBool:YES]];
        NSError *error;
        if (![managedObjectContext save:&error]) {
            // TODO: Handle the error appropriately.
            NSLog(@"Save message as read error %@, %@", error, [error userInfo]);
        }
    }
#endif
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
    

    
    // Set MessageCell height.
    CGSize size = [[(Message *)object text] sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize]
                                       constrainedToSize:CGSizeMake(kMessageTextWidth, CGFLOAT_MAX)
                                           lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 17.0f;
}


-(void)updateDataBaseFromChatScreen:(id)message type:(NSInteger)type{
    
    NSArray *indexPaths;
    
    switch(type) {
        case 1: {
            NSUInteger cellCount = [cellMap count];
            
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:cellCount inSection:0];
            
            if ([self addMessage:message] == 1) {
                //                NSLog(@"insert 1 row at index: %d", cellCount);
                indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath, nil];
            } else { // 2
                //                NSLog(@"insert 2 rows at index: %d", cellCount);
                indexPaths = [[NSArray alloc] initWithObjects:firstIndexPath,
                              [NSIndexPath indexPathForRow:cellCount+1 inSection:0],[NSIndexPath indexPathForRow:cellCount+2 inSection:0], nil];
            }
            
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
