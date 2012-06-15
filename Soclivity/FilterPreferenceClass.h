//
//  FilterPreferenceClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterPreferenceClass : NSObject{
    BOOL playAct;
    BOOL eatAct;
    BOOL seeAct;
    BOOL createAct;
    BOOL learnAct;
    NSInteger whenSearchType;
}
@property (nonatomic,assign)BOOL playAct;
@property (nonatomic,assign)BOOL eatAct;
@property (nonatomic,assign)BOOL seeAct;
@property (nonatomic,assign)BOOL createAct;
@property (nonatomic,assign)BOOL learnAct;
@property (nonatomic,assign) NSInteger whenSearchType;
@end
