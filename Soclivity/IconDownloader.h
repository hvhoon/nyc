
@class ParticipantClass;
@class InviteObjectClass;
@class WaitingOnYouClass;
@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    ParticipantClass *appRecord;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    NSInteger tagkey;
    InviteObjectClass *inviteRecord;
    
    UIImage *img_waitingonyou;
    NSString *lstrwaitingonyouurl;
}
@property (nonatomic,retain)InviteObjectClass *inviteRecord;
@property (nonatomic, retain) ParticipantClass *appRecord;
@property (nonatomic, retain) UIImage *img_waitingonyou;
@property (nonatomic, retain) NSString *lstrwaitingonyouurl;

@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;
@property (nonatomic,assign)NSInteger tagkey;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

@property (nonatomic, retain) NSString *waitingonyouurl;

- (void)startDownload:(NSInteger)uniqueKey;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end