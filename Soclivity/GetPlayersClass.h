//
//  GetPlayersClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPlayersClass : NSObject{
    
    NSString *birth_date;
    NSString *created_at;
    NSString *email;
    NSString *first_name;
    NSNumber *idSoc;
    NSString *last_name;
    NSString *updated_at;

    
}
@property(nonatomic,retain)NSString *birth_date;
@property(nonatomic,retain)NSString *created_at;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *first_name;
@property(nonatomic,retain)NSNumber *idSoc;
@property(nonatomic,retain)NSString *last_name;
@property(nonatomic,retain)NSString *updated_at;

@end