

#import <Foundation/Foundation.h>



@class SAServiceAsyncInvocation;

@interface SAService : NSObject {
	NSString* _apiKey;
	NSString* _serviceUrl;
	NSMutableDictionary* _invocations;
}

@property (nonatomic,retain) IBOutlet NSString* apiKey;
@property (nonatomic,retain) IBOutlet NSString* serviceUrl;

-(void)invoke:(SAServiceAsyncInvocation*)invocation withDelegate:(id)delegate;
-(void)cancel:(SAServiceAsyncInvocation*)invocation; // this is temporary

@end