//
//  SoclivityUtilities.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivityUtilities.h"
#import "UIImage+ProportionalFill.h"
#import "UIImage+Tint.h"

@implementation SoclivityUtilities


+(UIColor*)returnTextFontColor:(NSInteger)colorType{
    
    switch(colorType){
        case 0:
        {
            return [UIColor colorWithRed:255.0/255.0 green:255./255.0 blue:255.0/255.0 alpha:1.0];
            
            break;
        }
            
            
        case 1:
        {
            return [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
            
            break;
        }
        case 2:
        {
            return [UIColor colorWithRed:32.0/255.0 green:110.0/255.0 blue:183.0/255.0 alpha:1.0];
            
            break;
        }
            
        case 3:
        {
            return [UIColor colorWithRed:118.0/255.0 green:20.0/255.0 blue:158.0/255.0 alpha:1.0];
            
            break;
        }
            
            
        case 4:
        {
            return [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0];
            
            break;
        }
            
        default:
        {
            return [UIColor colorWithRed:255.0/255.0 green:255./255.0 blue:255.0/255.0 alpha:1.0];
        }
            break;
    }
	
}

+(UIImage*)updateResult:(CGSize)sizeToFitTheImage originalImage:(UIImage*)originalImage switchCaseIndex:(int)switchCaseIndex
{
	UIImage *oldImage = originalImage;
	UIImage *newImage=nil;
    //	CGSize newSize = resultView.frame.size;
	CGSize newSize = sizeToFitTheImage;
	
#if 1	
	
    // Resize the image using the user's chosen method.
	switch (switchCaseIndex) {
		case 0:
			newImage = [oldImage imageScaledToFitSize:newSize]; // uses MGImageResizeScale
			break;
		case 1:
			newImage = [oldImage imageCroppedToFitSize:newSize]; // uses MGImageResizeCrop
			break;
		case 2:
			newImage = [oldImage imageToFitSize:newSize method:MGImageResizeCropStart];
			break;
		case 3:
			newImage = [oldImage imageToFitSize:newSize method:MGImageResizeCropEnd];
			break;
		default:
			break;
	}
	
	
	return newImage;
    
#endif	
	
}
@end
