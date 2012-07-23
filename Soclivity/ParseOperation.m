//
//  ParseOperation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseOperation.h"
#import "GetPlayersClass.h"
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"
@interface ParseOperation ()
@property (nonatomic, assign) id <ParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic,retain) NSString *mappedKey;
@property (nonatomic,retain) GetPlayersClass *playerObject;
@end

@implementation ParseOperation
@synthesize delegate, dataToParse, workingArray,mappedKey,jsonQueryKey,playerObject,responseStatus;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate tagJsonService:(NSInteger)tagJsonService
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.delegate = theDelegate;
        jsonQueryKey=tagJsonService;
    }
    return self;
}

-(void)main{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	responseStatus=FALSE;
	self.workingArray = [NSMutableArray array];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
	// desirable because it gives less control over the network, particularly in responding to
	// connection errors.
    //
    
    adapter = [SBJsonStreamParserAdapter new];
    adapter.delegate = self;
    
    parser = [SBJsonStreamParser new];
	
    // .. and set our adapter as its delegate.
	parser.delegate = self;
	parser.multi = YES;
    
    SBJsonStreamParserStatus status = [parser parse:dataToParse];
    
 	
	if (![self isCancelled])
    {
        if (status == SBJsonStreamParserError) {
            NSLog(@"Parser error: %@", parser.error);
            [self.delegate parseErrorOccurred:parser.error];
            
            
        } else if (status == SBJsonStreamParserWaitingForData) {
            //		NSLog(@"Parser waiting for more data");
            
            
            [self.delegate didFinishParsing:self.workingArray];
            
        }
        // notify our AppDelegate that the parsing is complete
    }
    
    self.workingArray = nil;
    self.dataToParse = nil;
    
    [parser release];
    [adapter release];
	[pool release];
}

- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
    //NSLog(@"Inside json adapter delegate foundArray");	
}

- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
    //NSLog(@"Inside json adapter delegate foundObject");	
}


- (void)parserFoundObjectStart:(SBJsonStreamParser*)parser
{
    //NSLog(@"Inside json delegate parserFoundObjectStart");
    //if(arrayInsert){
    if((jsonQueryKey==kGetPlayers)||(jsonQueryKey==kRegisterPlayer)||(jsonQueryKey==kLoginPlayer)||(jsonQueryKey==kForgotPassword)){
        
        self.playerObject=[[[GetPlayersClass alloc]init]autorelease];
    }
   // }
    
}
- (void)parser:(SBJsonStreamParser*)parser foundObjectKey:(NSString*)key
{
    //NSLog(@"Inside json delegate foundObjectKey");
    
    if((jsonQueryKey==kGetPlayers)||(jsonQueryKey==kRegisterPlayer)||(jsonQueryKey==kLoginPlayer)||(jsonQueryKey==kForgotPassword)){  
        if ([key isEqualToString:@"birth_date"]) {
                mappedKey=key;
        }
        else if ([key isEqualToString:@"created_at"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"email"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"first_name"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"id"]){
            mappedKey=key;
        }
        else if ([key isEqualToString:@"last_name"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"updated_at"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"password_status"]) {
			mappedKey=key;
        }
        
        else if ([key isEqualToString:@"status"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"registered"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"atypes"]) {
			mappedKey=key;
        }
        else if ([key isEqualToString:@"photo_url"]) {
			mappedKey=key;
        }

       
        
    }
        
    
}
- (void)parserFoundObjectEnd:(SBJsonStreamParser*)parser{
    
    
    //if(arrayInsert){
    if((jsonQueryKey==kGetPlayers)||(jsonQueryKey==kRegisterPlayer)||(jsonQueryKey==kLoginPlayer)||(jsonQueryKey==kForgotPassword)){
        if((responseStatus)||(jsonQueryKey==kRegisterPlayer)){
            [[self workingArray] addObject:self.playerObject];
             responseStatus=FALSE;
        }
    }
    //}
    
}


- (void)parserFoundArrayStart:(SBJsonStreamParser*)parser{
    //    NSLog(@"Inside json delegate parserFoundArrayStart");
    
    //response ke baad idhar
    arrayInsert=TRUE;
}

- (void)parserFoundArrayEnd:(SBJsonStreamParser*)parser{
    //    NSLog(@"Inside json delegate parserFoundArrayEnd");
    arrayInsert=FALSE;
    //sab kaam khatam
}


- (void)parser:(SBJsonStreamParser*)parser foundBoolean:(BOOL)x{
    // NSLog(@"Inside json delegate foundBoolean");
    if(jsonQueryKey==kGetPlayers||jsonQueryKey==kRegisterPlayer||jsonQueryKey==kLoginPlayer||(jsonQueryKey==kForgotPassword)){
        if ([mappedKey isEqualToString:@"status"]) {
            self.playerObject.status = x;
            mappedKey=nil;
            responseStatus=TRUE;
        }
        else if([mappedKey isEqualToString:@"registered"]){
            self.playerObject.registered = x;
            mappedKey=nil;
            responseStatus=TRUE;
        }
        
    }
}
- (void)parserFoundNull:(SBJsonStreamParser*)parser{
    //    NSLog(@"Inside json delegate parserFoundNull");
	if(jsonQueryKey==kGetPlayers||jsonQueryKey==kRegisterPlayer||jsonQueryKey==kLoginPlayer||(jsonQueryKey==kForgotPassword)){
        if ([mappedKey isEqualToString:@"password_status"]) {
            self.playerObject.password_status = @"null";
            mappedKey=nil;
        }
        
    }
}


- (void)parser:(SBJsonStreamParser*)parser foundNumber:(NSNumber*)num{
    //    NSLog(@"Inside json delegate foundNumber");
    
    if(jsonQueryKey==kGetPlayers||jsonQueryKey==kRegisterPlayer||jsonQueryKey==kLoginPlayer||(jsonQueryKey==kForgotPassword)){
        if ([mappedKey isEqualToString:@"id"]) {
            self.playerObject.idSoc = num;
            mappedKey=nil;
        }
        
        
    }
    
}

- (void)parser:(SBJsonStreamParser*)parser foundString:(NSString*)string{
    //    	NSLog(@"Inside json delegate foundString");
    
    if((jsonQueryKey==kGetPlayers)||(jsonQueryKey==kRegisterPlayer)||(jsonQueryKey==kLoginPlayer)||(jsonQueryKey==kForgotPassword)){
            
        if ([mappedKey isEqualToString:@"birth_date"]) {
            self.playerObject.birth_date = string;
            
            mappedKey=nil;
            }
        else if ([mappedKey isEqualToString:@"created_at"]) {
            self.playerObject.created_at = string;
            
            mappedKey=nil;
        }
        else if ([mappedKey isEqualToString:@"email"]) {
            self.playerObject.email = string;
            
            mappedKey=nil;
        }
        else if ([mappedKey isEqualToString:@"first_name"]) {
            self.playerObject.first_name = string;
            
            mappedKey=nil;
        }
        else if ([mappedKey isEqualToString:@"last_name"]) {
            self.playerObject.last_name = string;
            
            mappedKey=nil;
        }
        else if ([mappedKey isEqualToString:@"updated_at"]) {
            self.playerObject.updated_at = string;
            
            mappedKey=nil;
        }
        
        else if ([mappedKey isEqualToString:@"password_status"]) {
            self.playerObject.password_status = string;
            
            mappedKey=nil;
        }
        else if([mappedKey isEqualToString:@"photo_url"]){
            self.playerObject.profileImageUrl = [NSString stringWithFormat:@"http://dev.soclivity.com%@",string];
            
            mappedKey=nil;

        }
        
        else if ([mappedKey isEqualToString:@"atypes"]) {
            self.playerObject.activityTypes = string;
            SoclivityManager *SOC=[SoclivityManager SharedInstance];
            SOC.filterObject.playAct=FALSE;
            SOC.filterObject.eatAct=FALSE;
            SOC.filterObject.seeAct=FALSE;
            SOC.filterObject.createAct=FALSE;
            SOC.filterObject.learnAct=FALSE;
            
            NSArray *timeArray = [string componentsSeparatedByString:@","];
            
            for(NSString *actType in timeArray){
                
                int activity=[actType intValue];
                switch (activity) {
                    case 1:
                    {
                        SOC.filterObject.playAct=TRUE;
                    }
                        break;
                    case 2:
                    {
                        SOC.filterObject.eatAct=TRUE;
                        
                    }
                        break;
                    case 3:
                    {
                        SOC.filterObject.seeAct=TRUE;
                        
                    }
                        break;
                    case 4:
                    {
                        SOC.filterObject.createAct=TRUE;
                        
                    }
                        break;
                    case 5:
                    {
                        SOC.filterObject.learnAct=TRUE;
                        
                    }
                        break;
                        
                }
            }
            
            mappedKey=nil;
        }

        else if ([mappedKey isEqualToString:@"status"]) {
            self.playerObject.statusMessage = string;
            responseStatus=TRUE;
			mappedKey=nil;
        }
        
    }
    
        
        
        
	
    
}



// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
    //[dataToParse release];
    //[workingArray release];
    [super dealloc];
}
@end
