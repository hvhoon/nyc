
#import <Foundation/Foundation.h>
#import "ISO8601DateFormatter.h"
#import "NSHTTPURLResponse+StatusCodes.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "JSON.h"

@interface JSON : NSObject { }
+(ISO8601DateFormatter*)timeFormatter;
+(NSDateFormatter*)dateFormatter;
+(NSDate*)dateFromTimeString:(NSString*)string;
+(NSDate*)dateFromDateString:(NSString*)string;
+(NSString*)dateString:(NSDate*)date;
+(NSString*)timeString:(NSDate*)time;
@end

@class SAStore;
@class SAServiceAsyncInvocation;

@protocol SAServiceAsyncInvocationFinalizer
-(void)finalize:(SAServiceAsyncInvocation*)invocation;
@end

@interface SAServiceAsyncInvocation : NSObject {
	SAStore* _store;	
	id <SAServiceAsyncInvocationFinalizer> _finalizer;
	id _delegate;
	NSString* _url;
	NSString* _key;
    NSString* _clientVersion;
	NSString* _clientVersionHeaderName;
	NSString* _apiKey;
    NSString* _deviceIdentifier; // 6th Apr,2011 
	NSDate* _timestamp;
	NSHTTPURLResponse* _response;
	NSMutableData* _receivedData;
    
    NSMutableDictionary* _context;
}
@property (nonatomic, assign) SAStore* store;
@property (nonatomic, assign) id <SAServiceAsyncInvocationFinalizer> finalizer;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* clientVersion;
@property (nonatomic, retain) NSString* clientVersionHeaderName;
@property (nonatomic, retain) NSString* apiKey;
@property (nonatomic, retain) NSString* deviceIdentifier;
@property (nonatomic, retain) NSDate* timestamp;
@property (nonatomic, retain) NSHTTPURLResponse* response;
@property (nonatomic, retain) NSMutableData *receivedData;

+(BOOL) isOk:(NSNumber*)statusCode;
+(NSDictionary*) responseFromJSONDictionary:(NSDictionary*)resultsd error:(NSError**)error;
-(BOOL)isReady;
-(void)invoke;

-(void)post:(NSString*)path body:(NSString*)body;
-(void)put:(NSString*)path body:(NSString*)body;
-(void)get:(NSString*)path;

-(BOOL)handleHttpError:(NSInteger)code;
-(BOOL)handleHttpOK:(NSMutableData*)data;

// Client-Stored context objects bound to an invocation
-(void)setObject:(id)object forKey:(NSString*)key;
-(id)objectForKey:(NSString*)key;

@end
