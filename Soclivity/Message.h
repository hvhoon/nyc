//
//  Message.h
//  Soclivity
//
//  Created by Kanav Gupta on 23/02/13.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic,retain)NSString*text;
@property(nonatomic,assign)BOOL isImage;
@property (nonatomic,retain)NSDate *textDate;
@property(nonatomic,retain)NSString *formattedDate;
@property (nonatomic,assign)BOOL isMine;
@end
