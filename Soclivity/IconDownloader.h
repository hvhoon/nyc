
@class ParticipantClass;
@class InviteObjectClass;
@class NotificationClass;
@class ActivityChatData;
@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject
{
    ParticipantClass *appRecord;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    NotificationClass *notificationRecord;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    NSInteger tagkey;
    InviteObjectClass *inviteRecord;
    ActivityChatData *postChatRecord;
    
}
@property (nonatomic,retain)InviteObjectClass *inviteRecord;
@property (nonatomic, retain) ParticipantClass *appRecord;
@property (nonatomic,retain)NotificationClass *notificationRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;
@property (nonatomic,assign)NSInteger tagkey;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic,retain)ActivityChatData *postChatRecord;

- (void)startDownload:(NSInteger)uniqueKey;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end