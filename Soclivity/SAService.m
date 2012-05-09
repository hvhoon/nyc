
#import "SAService.h"
#import "SAServiceAsyncInvocation.h"


@interface SAService (private)<SAServiceAsyncInvocationFinalizer>
@end

@implementation SAService

@synthesize apiKey=_apiKey,serviceUrl=_serviceUrl;

-(id)init {
	NSLog(@"%s",__FUNCTION__);
	self = [super init];
	if (self) {
		_invocations = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(id)retain {
	NSLog(@"%s (%d=>%d)",__FUNCTION__,[self retainCount],([self retainCount]+1));
	return [super retain];
}

-(void)cancel:(SAServiceAsyncInvocation*)invocation {
	[self finalize:invocation];
}

-(void)dealloc {
	NSLog(@"%s",__FUNCTION__);
	[self setApiKey:nil];
	[self setServiceUrl:nil];
	[_invocations release]; _invocations = nil;
	[super dealloc];
}

-(void)finalize:(SAServiceAsyncInvocation*)invocation {
	@synchronized (self) {
		[invocation setDelegate:nil];
		[_invocations removeObjectForKey:[invocation key]];
		[invocation setFinalizer:nil];
	}	
}

-(void)invoke:(SAServiceAsyncInvocation*)invocation withDelegate:(id)delegate {
	//[invocation setStore:_store]; //TODO: Also set the store
	[invocation setApiKey:_apiKey];
	[invocation setDelegate:delegate];
	[invocation setFinalizer:self];
	[invocation setUrl:self.serviceUrl];
	@synchronized (self) {
		[_invocations setObject:invocation forKey:[invocation key]];
	}
	
	[invocation invoke];
}

@end
