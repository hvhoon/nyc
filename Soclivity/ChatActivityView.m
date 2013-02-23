//
//  ChatActivityView.m
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import "ChatActivityView.h"
#import "SoclivityUtilities.h"

@implementation ChatActivityView
@synthesize delegate=_delegate,chatTableView=_chatTableView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateChatScreen:(NSMutableArray*)updatedChatArray{
    if([updatedChatArray count]==0){
        [self setUpBackgroundView];
    }
    else{
        [self SetupChatTableView];
    }
}

-(void)setUpBackgroundView{
    CGRect noChatTableRect;
    
    CGRect fadedRect;
    CGRect noChatRect;
    UIImageView *logoFadedImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S11_logoFaded.png"]];
    UIImageView *noChatImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05.3_chatBlankImage.png"]];

    
    if([SoclivityUtilities deviceType] & iPhone5){
        noChatTableRect=CGRectMake(0, 0, 320, 376+88);
        noChatRect=CGRectMake(75, 132, 169, 149);

        fadedRect=CGRectMake(105, 389, 111, 28);
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
        chatTableRect=CGRectMake(0, 0, 320, 332+88+44);
    
    else
        chatTableRect=CGRectMake(0, 0, 320, 332+44);
    
    self.chatTableView=[[UITableView alloc] initWithFrame:chatTableRect style:UITableViewStylePlain];
    [self.chatTableView setDelegate:self];
    [self.chatTableView setDataSource:self];
    self.chatTableView.scrollEnabled=YES;
    self.chatTableView.backgroundView=nil;
    self.chatTableView.backgroundColor=[UIColor clearColor];
    self.self.chatTableView.separatorColor = [UIColor clearColor];
    self.chatTableView.showsVerticalScrollIndicator=YES;
    [self addSubview:self.chatTableView];
    self.chatTableView.clipsToBounds=YES;
    
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
