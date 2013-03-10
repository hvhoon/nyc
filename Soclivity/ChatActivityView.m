//
//  ChatActivityView.m
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import "ChatActivityView.h"
#import "SoclivityUtilities.h"
#import "ChatTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "ActivityChatData.h"
#import "MessageInputView.h"
#import "NSString+MessagesView.h"


#define INPUT_HEIGHT 40.0f
#define kLoadingPrevMessage 1

@implementation ChatActivityView
@synthesize bubbleTable;
@synthesize delegate=_delegate;
@synthesize inputView;
@synthesize holdHistoryArray;
@synthesize chatBackgroundView;
@synthesize bubbleData;
- (void)dealloc {
    
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateChatScreen:(NSMutableArray*)chatArray{
    
    self.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];

    
    
#if 0
    ActivityChatData *heyBubble = [ActivityChatData dataWithText:@"Hey, Soclivity  is releasing soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] name:@"Harish Hoon" type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"picbox.png"];
    heyBubble.showAvatars=YES;
    ActivityChatData *photoBubble = [ActivityChatData dataWithImage:[UIImage imageNamed:@"aqua_learn.png"] date:[NSDate dateWithTimeIntervalSinceNow:-290] name:@"Harish Hoon" type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"picbox.png"];
    photoBubble.showAvatars=YES;
    ActivityChatData *replyBubble = [ActivityChatData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] name:@"Kanav Gupta" type:BubbleTypeMine];
    replyBubble.avatar = nil;
    replyBubble.showAvatars=NO;
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
    //bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;

#endif
    
    

    holdHistoryArray=[NSMutableArray new];
    bubbleData=[NSMutableArray new];
    if([chatArray count]>kLoadingPrevMessage){
        
        [holdHistoryArray addObjectsFromArray:chatArray];
        int index=0,total=0;
        for(int i=[holdHistoryArray count]-1;i>=0;i--){
            
            if(index==kLoadingPrevMessage)
                break;
            
            ActivityChatData *chat=[holdHistoryArray objectAtIndex:i];
            [bubbleData addObject:chat];
            index++;
        }
        
        if([holdHistoryArray count]<kLoadingPrevMessage){
            total=[holdHistoryArray count];
        }
        else{
            total=kLoadingPrevMessage;
        }
        for(int i=0;i<total;i++)
            [holdHistoryArray removeLastObject];
        
        
    }
    else{
        [bubbleData addObjectsFromArray:chatArray];
    }

    CGSize size = self.frame.size;
	
    CGRect tableFrame = CGRectMake(0.0f,0.0f, size.width, size.height-40);//84
	self.bubbleTable = [[ChatTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.bubbleTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if([holdHistoryArray count]>0){
        [self loadTableHeader];
        //bubbleTable.contentInset = UIEdgeInsetsMake(-52.0f, 0, 0, 0);
    }
    
    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 1;

	[self addSubview:self.bubbleTable];
    
	
    
    CGRect inputFrame = CGRectMake(0.0f, size.height + INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputView = [[MessageInputView alloc] initWithFrame:inputFrame];
    self.inputView.textView.delegate = self;
    [self.inputView.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.inputView];

    
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [self.inputView setHidden:YES];
    
    if([bubbleData count]==0){
        
            
            [self.bubbleTable setHidden:YES];
            
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
    else{

        [self.bubbleTable reloadData];
        [self scrollToBottomAnimated:NO];

    }

}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(ChatTableView *)tableView
{
    return [bubbleData count];
}

- (ActivityChatData *)bubbleTableView:(ChatTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

-(void)removeBubbleDataObjectAtIndex:(NSInteger)objectIndex{
    [bubbleData removeObjectAtIndex:objectIndex];
}

-(NSInteger)earlierCount{
    return  [holdHistoryArray count];
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    
    
    //[self.delegate postAtTextMessageOnTheServer:text];
    
    
    if((bubbleData.count - 1) % 2)
        [MessageSoundEffect playMessageSentSound];
    else
        [MessageSoundEffect playMessageReceivedSound];
    int num=rand()%2;
    
    ActivityChatData *sayBubble = [ActivityChatData dataWithText:text date:[NSDate dateWithTimeIntervalSinceNow:0] name:@"Kanav Gupta" type:num];
    if(num==BubbleTypeSomeoneElse){
            sayBubble.showAvatars=YES;
            sayBubble.avatar = [UIImage imageNamed:@"picbox.png"];
    }else{
            sayBubble.showAvatars=NO;
            sayBubble.avatar = nil;
    }
    [bubbleData addObject:sayBubble];
    
    [self finishSend];
}

-(void)postImagePressed:(UIImage*)image{
    
    if((bubbleData.count - 1) % 2)
        [MessageSoundEffect playMessageSentSound];
    else
        [MessageSoundEffect playMessageReceivedSound];
    int num=rand()%2;
    
    ActivityChatData *sayBubble = [ActivityChatData dataWithImage:image date:[NSDate dateWithTimeIntervalSinceNow:0] name:@"Kanav Gupta" type:num];
    
    if(num==BubbleTypeSomeoneElse){
        sayBubble.showAvatars=YES;
        sayBubble.avatar = [UIImage imageNamed:@"picbox.png"];
    }else{
        sayBubble.showAvatars=NO;
        sayBubble.avatar = nil;
    }
    [bubbleData addObject:sayBubble];
    
    [self.bubbleTable reloadData];
    [self scrollToBottomAnimated:YES];

}

- (void)sendPressed:(UIButton *)sender
{
    [self.bubbleTable setHidden:NO];
    [self sendPressed:sender
             withText:[self.inputView.textView.text trimWhitespace]];
}


- (void)finishSend
{
    [self.inputView.textView setText:nil];
    [self textViewDidChange:self.inputView.textView];
    [self.bubbleTable reloadData];
    [self scrollToBottomAnimated:YES];
}


- (void)scrollToBottomAnimated:(BOOL)animated
{
    if([bubbleData count]!=0){
#if 1
    NSInteger rows = 0;
    
    ActivityChatData *data=[[bubbleTable.bubbleSection lastObject]objectAtIndex:0];
    if(data.type==BubbleTypeMine){
        rows=2;
    }
    else{
        rows=3;
    }
    
    if(rows > 0) {
        [self.bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:[bubbleTable.bubbleSection count]-1]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}
#endif
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    self.previousTextViewContentHeight = textView.contentSize.height;
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if (![textView hasText]) {
        self.inputView.placeholderLabel.hidden = NO;
    }

}

-(void)resignKeyBoard{
    [self.inputView.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if(![textView hasText]) {
        self.inputView.placeholderLabel.hidden = NO;
    }
    else{
        self.inputView.placeholderLabel.hidden = YES;
    }

    CGFloat maxHeight = [MessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    changeInHeight = (textViewContentHeight + changeInHeight >= maxHeight) ? 0.0f : changeInHeight;
    
    if(changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f animations:^{
            
            UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.bubbleTable.contentInset.bottom + changeInHeight, 0.0f);
            self.bubbleTable.contentInset = insets;
            self.bubbleTable.scrollIndicatorInsets = insets;
            
            [self scrollToBottomAnimated:NO];
            
            CGRect inputViewFrame = self.inputView.frame;
            self.inputView.frame = CGRectMake(0.0f,
                                              inputViewFrame.origin.y - changeInHeight,
                                              inputViewFrame.size.width,
                                              inputViewFrame.size.height + changeInHeight);
        } completion:^(BOOL finished) {
            
        }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    self.inputView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}


#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
        isKeyboardInView=TRUE;
        [self.delegate showDoneButton:YES];
        [self keyboardWillShowHide:notification];
}

-(void)userInteraction:(BOOL)test{
    

 //   [self.inputView.textView setUserInteractionEnabled:test];
    if(test){
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillShowKeyboard:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];*/
        //[self.inputView.textView becomeFirstResponder];


//        [self.inputView setHidden:NO];
//            self.inputView.alpha=1.0f;
   }
    else{
        
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        
                [self.inputView.textView becomeFirstResponder];

//        [self.inputView setHidden:YES];
//        self.inputView.alpha=0.0f;
   }
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    isKeyboardInView=FALSE;
    [self.delegate showDoneButton:NO];
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
	[UIView beginAnimations:@"keyboardWillShowHide" context:nil];
	[UIView setAnimationCurve:curve];
	[UIView setAnimationDuration:duration];
    
    keyboardY = [self convertRect:keyboardRect fromView:nil].origin.y;
    
    CGRect inputViewFrame = self.inputView.frame;
    self.inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                      keyboardY - inputViewFrame.size.height,
                                      inputViewFrame.size.width,
                                      inputViewFrame.size.height);
    
    if(!isKeyboardInView){
        [inputView setHidden:YES];
    }
    else{
        [inputView setHidden:NO];
    }
#if 1
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           self.frame.size.height - keyboardY,
                                           0.0f);
	self.bubbleTable.contentInset = insets;
	self.bubbleTable.scrollIndicatorInsets = insets;
#endif
    [UIView commitAnimations];
}


#pragma mark - Keyboard events


-(void)loadTableHeader{
    
    loadPrevMessagesView = [[UIView alloc] initWithFrame:CGRectMake(0, -52.0f, 320, 52.0f)];
    loadPrevMessagesView.backgroundColor = [SoclivityUtilities returnBackgroundColor:1];
	loadPrevMessagesView.tag=145;
    UILabel *loadMoreChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 200, 20)];
    loadMoreChatLabel.backgroundColor=[UIColor clearColor];
    loadMoreChatLabel.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    loadMoreChatLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    loadMoreChatLabel.textAlignment = UITextAlignmentLeft;
    
    UIActivityIndicatorView*friendSpinnerLoadMore = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    friendSpinnerLoadMore.frame = CGRectMake(10,15, 25, 25);
    [friendSpinnerLoadMore startAnimating];
    [loadPrevMessagesView addSubview:friendSpinnerLoadMore];
    
    [friendSpinnerLoadMore setHidden:NO];
    loadMoreChatLabel.text=[NSString stringWithFormat:@"Load earlier messages..."];
        
	
	[loadPrevMessagesView addSubview:loadMoreChatLabel];
    [loadMoreChatLabel release];
    [self.bubbleTable addSubview:loadPrevMessagesView];

}


-(void)userScrolledToLoadEarlierMessages{
    self.bubbleTable.contentInset = UIEdgeInsetsMake(52, 0, 0, 0);

    [self performSelector:@selector(stopAnimatingHeader) withObject:nil afterDelay:2.0];
}

//stop the header spinner
- (void) stopAnimatingHeader{
    //add the data
    
    [self addItemsToStartOfTableView];
    [self.bubbleTable reloadData];
    
    if(isKeyboardInView){
        
        UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                               0.0f,
                                               self.frame.size.height - keyboardY,
                                               0.0f);
        self.bubbleTable.contentInset = insets;

    }

}


-(void)addItemsToStartOfTableView{
    
    int total=0;
    if([holdHistoryArray count]>0){
    int index=0;
    for(int i=[holdHistoryArray count]-1;i>=0;i--){
        
        if(index==kLoadingPrevMessage)
            break;
        
        [bubbleData addObject:[holdHistoryArray objectAtIndex:i]];
        index++;
    }
        if([holdHistoryArray count]<kLoadingPrevMessage){
            total=[holdHistoryArray count];
        }
        else{
            total=kLoadingPrevMessage;
        }
    for(int i=0;i<total;i++)
        [holdHistoryArray removeLastObject];
    }
    
    if([holdHistoryArray count]==0){
            bubbleTable.contentInset = UIEdgeInsetsMake(0.0, 0, 0, 0);
           [loadPrevMessagesView setHidden:YES];


    }
    else{
        //self.bubbleTable.contentInset = UIEdgeInsetsMake(-52, 0, 0, 0);
        self.bubbleTable.contentInset = UIEdgeInsetsMake(0.0, 0, 0, 0);
        bubbleTable.isLoading=FALSE;
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
