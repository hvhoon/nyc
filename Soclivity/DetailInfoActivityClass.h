//
//  DetailInfoActivityClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailInfoActivityClass : NSObject{
    
    NSString *dateAndTime;
    NSString *location;
    NSInteger DOS_1;
    NSInteger DOS_2;
}
@property(nonatomic,retain)NSString *dateAndTime;
@property(nonatomic,retain)NSString *location;
@property(nonatomic,assign)NSInteger DOS_1;
@property(nonatomic,assign)NSInteger DOS_2;
@end
