//
//  SoclivityUtilities.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoclivityUtilities : NSObject{
    
}
+(UIColor*)returnTextFontColor:(NSInteger)colorType;
+(UIImage*)updateResult:(CGSize)sizeToFitTheImage originalImage:(UIImage*)originalImage switchCaseIndex:(int)switchCaseIndex;
+(BOOL)validEmail:(NSString*)email;

@end
