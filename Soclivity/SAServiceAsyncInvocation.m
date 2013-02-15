
#import "SAServiceAsyncInvocation.h"
#import "RRAViewController.h"

const NSString* const kResponseKey = @"response";
const NSString* const kDescriptionKey = @"description";
const NSString* const kMessageKey = @"message";
const NSString* const kIdKey =  @"id";
const NSString* const kStatusKey = @"status";

#define kDefaultClientVersionHeaderName @"SA-Client-Version"
#define kServiceDomain @"service"
#define kOperationFailed @"Operation Failed"

ISO8601DateFormatter* gJSONTimeFormatter = nil;
NSDateFormatter* gJSONDateFormatter = nil;
@implementation JSON
+(ISO8601DateFormatter*)timeFormatter {
	if (!gJSONTimeFormatter) {
		gJSONTimeFormatter = [[ISO8601DateFormatter alloc] init];
		[gJSONTimeFormatter setIncludeTime:YES];
		[gJSONTimeFormatter setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	return gJSONTimeFormatter;
}
+(NSDateFormatter*)dateFormatter {
	if (!gJSONDateFormatter) {
		gJSONDateFormatter = [[NSDateFormatter alloc] init];
		[gJSONDateFormatter setDateFormat:@"yyyy-MM-dd"];
	}
	return gJSONDateFormatter;
}
+(NSDate*)dateFromTimeString:(NSString*)string {
	return [[JSON timeFormatter] dateFromString:string];
}
+(NSDate*)dateFromDateString:(NSString*)string {
	return [[JSON dateFormatter] dateFromString:string];
}
+(NSString*)dateString:(NSDate*)date {
	return [[JSON dateFormatter] stringFromDate:date];
}
+(NSString*)timeString:(NSDate*)time {
	return [[JSON timeFormatter] stringFromDate:time];
}
+(NSString*)uuid {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString* uuidstr = [(NSString*)CFUUIDCreateString(NULL, uuid) autorelease];
	CFRelease(uuid);
	return uuidstr;
}
@end

@interface SAServiceAsyncInvocation (private) 
-(void)addHeaders:(NSMutableURLRequest*)request;
@end

@implementation SAServiceAsyncInvocation
@synthesize store = _store;
@synthesize finalizer = _finalizer;
@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize key = _key;
@synthesize clientVersion = _clientVersion;
@synthesize clientVersionHeaderName = _clientVersionHeaderName;
@synthesize apiKey = _apiKey;
@synthesize deviceIdentifier = _deviceIdentifier;
@synthesize timestamp = _timestamp;
@synthesize response = _response;
@synthesize receivedData = _receivedData;

+(BOOL)isOk:(NSNumber *)statusCode {
	return 200 <= [statusCode intValue] && [statusCode intValue] <= 299;
}

+(NSDictionary*) responseFromJSONDictionary:(NSDictionary*)resultsd error:(NSError**)error {
	if (error) {
		*error = Nil;
	}
	
	NSDictionary *statusd = [resultsd objectForKey:kStatusKey];
	
	if (statusd) {
		NSNumber *statusCode = [statusd objectForKey:kIdKey];
		if (![SAServiceAsyncInvocation isOk:statusCode]) {
			NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] init] autorelease];
			NSString* message = [statusd objectForKey:kMessageKey];
			if (!message) {
				message = @""; // we should never get to this but setting it to empty string
				// so that the following code doesn't crash.
			}
			[userInfo setObject:message forKey:kMessageKey];
			
						
			// known error
			if (error) {
				*error = [NSError errorWithDomain:kServiceDomain 
							  code:[statusCode intValue]
							  userInfo:[NSDictionary dictionaryWithObject:[statusd objectForKey:kMessageKey] forKey:kMessageKey]];
			}
			return Nil;
		}
		
		NSDictionary *responsed = [resultsd objectForKey:kResponseKey];
		return responsed;
	}
	
	if (error) {
		*error = [NSError errorWithDomain:kServiceDomain
					  code:500 
					  userInfo:[NSDictionary dictionaryWithObject:kOperationFailed forKey:kMessageKey]];
	}
	return Nil;
}

-(id)init {
	
	self = [super init];
	[self setKey:[JSON uuid]];
	[self setTimestamp:[NSDate date]];
	_receivedData = [[NSMutableData alloc] initWithLength:0];
	return self;
}

-(id)retain {
	
	return [super retain];
}

-(void)dealloc {
	
    [_context release]; _context = nil;
	[_key release];
	[_apiKey release];
	[_timestamp release];
	[_response release];
	[_receivedData release];
	[super dealloc];
}

-(NSString*)udid {
	return [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
}

-(BOOL)isReady {
	return YES;
}

-(void)invoke { }

-(void)get:(NSString*)path {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url = [NSMutableString stringWithFormat:@"http://%@", path];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	[self addHeaders:request];
	[NSURLConnection connectionWithRequest:request delegate:self];
	[pool release];
}


-(void)execute:(NSString*)method path:(NSString*)path body:(NSString*)body {
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
	NSString* url = [NSMutableString stringWithFormat:@"http://%@", path];
	NSLog(@"Url=%@",url);
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:method];
	if (body) {
		NSData *data = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
		[request setHTTPBody:data];
		[request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"text/x-json" forHTTPHeaderField:@"Content-Type"];
	}
	[self addHeaders:request];
    
    NSLog(@"request=%@",request);
	
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	[pool release];
}


-(void)post:(NSString*)path body:(NSString*)body {
	[self execute:@"POST" path:path body:body];
}

-(void)put:(NSString*)path body:(NSString*)body {
	[self execute:@"PUT"  path:path body:body];
}

-(void)delete:(NSString*)path{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url = [NSMutableString stringWithFormat:@"http://%@", path];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"DELETE"];
	[self addHeaders:request];
	[NSURLConnection connectionWithRequest:request delegate:self];
	[pool release];
}

-(void)addHeaders:(NSMutableURLRequest*)request {
    if (_clientVersion) {
		NSString* headerName = _clientVersionHeaderName;
		if (!headerName) {
			headerName = kDefaultClientVersionHeaderName;
		}

       
        [request setValue:_clientVersion forHTTPHeaderField:headerName];
    }
	//[request setValue:[ISUser currentDeviceId] forHTTPHeaderField:@"IS-Device-ID"];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
	
	[self setResponse:(NSHTTPURLResponse*)response];
   // NSString *response1=[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];

	if (![[self response] isOK]) {
		[self handleHttpError:[[self response] statusCode]];
		[self.finalizer finalize:self]; // Move this outside the if-block?
	}
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
   // NSString *response=[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];

	if ([_response isOK]) {
		[_receivedData appendData:data];
	}//END if ([_response isOK])
}

-(BOOL)handleHttpError:(NSInteger)code { 
	// Override to handle gracefully
    return YES;
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSString *response=[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
    NSLog(@"response=%@",response);

	[self handleHttpError:[[self response] statusCode]];
	//[self.finalizer finalize:self];
}

#if 1
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	
    BOOL finalize = YES;
    NSString *response=[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
    NSLog(@"response=%@",response);
    
	if ([[self response] isOK]) {
		finalize = [self handleHttpOK:self.receivedData];
	} else {
		finalize = [self handleHttpError:[[self response] statusCode]];
	}
    if (finalize) {
        // [self.finalizer finalize:self];
    }
}
#else

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	
    BOOL finalize = YES;
    NSString *response=[[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
    
    if ([response JSONValue]!=NULL && [response length]!=0 && [[response JSONValue] count]!=0)
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"]==NULL)
        {
            if([[response JSONValue] valueForKey:@"logged_in_user_id"]!=[NSNull null])
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[response JSONValue] valueForKey:@"logged_in_user_id"] forKey:@"logged_in_user_id"];
            }//END if([[response JSONValue] valueForKey:@"logged_in_user_id"]!=[NSNull null])
            
            if([[response JSONValue] valueForKey:@"notification_count"]!=[NSNull null])
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[response JSONValue] valueForKey:@"notification_count"] forKey:@"Waiting_On_You_Count"];
            }//END if([[response JSONValue] valueForKey:@"notification_count"]!=[NSNull null])
            
            if([[response JSONValue] valueForKey:@"unread_notification"]!=[NSNull null])
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[response JSONValue] valueForKey:@"unread_notification"] forKey:@"Notification_id"];
            }//END if([[response JSONValue] valueForKey:@"unread_notification"]!=[NSNull null])
        }
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] IncreaseBadgeIcon];
    }
    if ([[self response] isOK]) {
        finalize = [self handleHttpOK:_receivedData];
        
        if ([[response JSONValue] valueForKey:@"channel"]!=NULL && [[response JSONValue] count]!=0 && [[response JSONValue] valueForKey:@"channel"]!=[NSNull null])
        {
            if ([[[response JSONValue] valueForKeyPath:@"channel"] isKindOfClass:[NSArray class]])
            {
                for (int k=0; k<[[[response JSONValue] valueForKeyPath:@"channel"] count]; k++)
                {
                    if ([[[response JSONValue] valueForKeyPath:@"channel"] objectAtIndex:k]==@"<null>")
                    {
                        //do nothing
                    }
                } 
            }
            
            else{
                [[NSUserDefaults standardUserDefaults] setValue:[[[[response JSONValue] valueForKey:@"channel"] JSONValue] valueForKey:@"channel"] forKey:@"Channel"];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] PostBackgroundStatus];
                
                RRAViewController *objrra=[[RRAViewController alloc] initWithNibName:nil bundle:nil];
                [objrra fetchPrivatePubConfiguration:[[[[response JSONValue] valueForKey:@"channel"] JSONValue] valueForKey:@"channel"]];
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] setObjrra:objrra];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"TRUE" forKey:@"FromBackgroundState"];
                
            }
        }
        
    } else {
        finalize = [self handleHttpError:[[self response] statusCode]];
    }
    if (finalize) {
        // [self.finalizer finalize:self];
    }

    
}
#endif
-(BOOL)handleHttpOK:(NSMutableData*)data {
	// Override to handle gracefully
    return YES;
}

-(void)setObject:(id)object forKey:(NSString*)key {
    if (!_context) {
        _context = [[NSMutableDictionary alloc] init];
    }
    [_context setObject:object forKey:key];
}

-(id)objectForKey:(NSString*)key {
    return [_context objectForKey:key];
}

@end
