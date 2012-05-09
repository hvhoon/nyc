//
//  CAVNSArrayTypeCategory.m
//  Shopping
//
//  Created by Mac on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CAVNSArrayTypeCategory.h"

@implementation NSArray (Type)
-(id)firstObjectWithClass:(Class)class {
	for (NSObject* o in self) {
		if ([o isKindOfClass:class])  {
			return o;
		}
	}
	return nil;
}
@end
