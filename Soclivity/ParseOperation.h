//
//  ParseOperation.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON/JSON.h"
@protocol ParseOperationDelegate;
@class GetPlayersClass;
@interface ParseOperation : NSOperation<SBJsonStreamParserAdapterDelegate,SBJsonStreamParserDelegate>{
@private
    id <ParseOperationDelegate> delegate;
    
    NSData          *dataToParse;
    SBJsonStreamParser *parser;
    SBJsonStreamParserAdapter *adapter;
    NSMutableArray  *workingArray;
    NSString *mappedKey;
    NSInteger jsonQueryKey;
    BOOL arrayInsert;
    GetPlayersClass *playerObject;
    
    
}

@property (nonatomic,assign)NSInteger jsonQueryKey;
- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate tagJsonService:(NSInteger)tagJsonService;

@end

@protocol ParseOperationDelegate
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSString *)error;
@end
