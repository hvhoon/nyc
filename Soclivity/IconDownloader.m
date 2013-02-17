
#import "IconDownloader.h"
#import "ParticipantClass.h"
#import "InviteObjectClass.h"
#import "SoclivityUtilities.h"
#import "NotificationClass.h"
#define kIconHeight 56
#define kIconWidth 56

@implementation IconDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize tagkey;
@synthesize inviteRecord;
@synthesize notificationRecord;
#pragma mark

- (void)dealloc
{
    [appRecord release];
    [indexPathInTableView release];
    [notificationRecord release];
    [activeDownload release];
    [inviteRecord release];
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload:(NSInteger)uniqueKey
{
    self.activeDownload = [NSMutableData data];
    tagkey=uniqueKey;
    
    switch (tagkey){
        case kParticipantInActivity:
        {
            if(appRecord.photoUrl != nil)
            {
                
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                         [NSURLRequest requestWithURL:
                                          [NSURL URLWithString:appRecord.photoUrl]] delegate:self];
                self.imageConnection = conn;
                [conn release];
            }
            
        }
            break;
            
        case kInviteUsers:
        {
            if(inviteRecord.profilePhotoUrl != nil)
            {
                
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                         [NSURLRequest requestWithURL:
                                          [NSURL URLWithString:inviteRecord.profilePhotoUrl]] delegate:self];
                self.imageConnection = conn;
                [conn release];
            }
            
        }
            break;
            
        case kNotificationImageUrl:
        {
            if(notificationRecord.photoUrl!= nil)
            {
                NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                                         [NSURLRequest requestWithURL:
                                          [NSURL URLWithString:notificationRecord.photoUrl]] delegate:self];
                self.imageConnection = conn;
                [conn release];
            }
            
        }
            break;
    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    
    if(image.size.height != image.size.width)
        image = [SoclivityUtilities autoCrop:image];
    
    // If the image needs to be compressed
    if(image.size.height > kIconHeight || image.size.width > kIconHeight)
        image = [SoclivityUtilities compressImage:image size:CGSizeMake(kIconHeight,kIconHeight)];

       switch (tagkey) {
            case kParticipantInActivity:
            {
                self.appRecord.profilePhotoImage = image;
                
            }
                break;
                
            case kInviteUsers:
            {
                self.inviteRecord.profileImage =image;
                
            }
               break;
               
           case kNotificationImageUrl:
           {
            self.notificationRecord.profileImage =image;
           }
                break;
        }
    
	
	
    self.activeDownload = nil;

    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
     //[image release];
}

@end

