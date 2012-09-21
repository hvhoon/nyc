
@class ParticipantClass;
@class InviteObjectClass;
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
}
@property (nonatomic,retain)InviteObjectClass *inviteRecord;
@property (nonatomic, retain) ParticipantClass *appRecord;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;
@property (nonatomic,assign)NSInteger tagkey;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload:(NSInteger)uniqueKey;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end