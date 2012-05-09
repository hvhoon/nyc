//
//  ProjectAsyncInvocation.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProjectAsyncInvocation.h"

@implementation ProjectAsyncInvocation


-(id)init {
	self = [super init];
	if (self) {
		self.clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
		self.clientVersionHeaderName = @"ProductStore-Client-Version";
	}
	return self;
}
@end
