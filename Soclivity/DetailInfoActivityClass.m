//
//  DetailInfoActivityClass.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailInfoActivityClass.h"

@implementation DetailInfoActivityClass
@synthesize dateAndTime,location,DOS_1,DOS_2;


-(void)dealloc{
    [super dealloc];
    [dateAndTime release];
    [location release];
}
@end
