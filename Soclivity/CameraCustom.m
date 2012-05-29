//
//  CameraCustom.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "CameraCustom.h"
#include <CoreFoundation/CoreFoundation.h>
#import "SoclivityUtilities.h"
@implementation CameraCustom
@synthesize m_picker,delegate,galleryImage;

- (id)init{
	
    self = [super init];
    if (self) {
        m_picker=[[UIImagePickerController alloc]init];
        m_picker.allowsEditing = YES;
        m_picker.delegate = self;
        
    }

	return self;
}

// Pick the section of the image that you wish to use
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo 
{
    // Pull in the media type
    NSString *mediaType = [editingInfo objectForKey:UIImagePickerControllerMediaType];
    
    // Check if the mediatype is an image
    if([mediaType isEqualToString:@"public.image"]){
        UIImage*cropped=[editingInfo objectForKey:UIImagePickerControllerEditedImage];
/*
#if 0
      
        CGSize size = {52, 52};
        UIGraphicsBeginImageContext(size);
        
        CGRect rect;
        rect.origin = CGPointZero;
        rect.size = size;
        [original drawInRect:rect];
        
        UIImage *shinked;
        shinked = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        original = shinked;
        
#endif    
 */
        // If the image doesn't already exist in the gallery, please add it.
        if(!galleryImage)
            UIImageWriteToSavedPhotosAlbum(cropped, nil, nil, nil);
        
        // Send the image back to the view controller
        [delegate imageCapture:cropped];
        }
    
    // If the image is a video
    else if ([mediaType isEqualToString:@"public.movie"]){
        NSLog(@"found an Video");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	  [delegate dismissPickerModalController];
}

-(void)dealloc{
    
    [m_picker release];
}
@end
