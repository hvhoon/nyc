//
//  CameraCustom.m
//  Xling
//
//  Created by Kanav Gupta on 2/12/12.
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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo 
{
    
    NSLog(@"didFinishPickingMediaWithInfo");
    NSString *mediaType = [editingInfo objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage*original=[editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"found an image");
   
        
#if 0        
#if 0        
        CGSize size = {57, 57};
        UIGraphicsBeginImageContext(size);
        
        CGRect rect;
        rect.origin = CGPointZero;
        rect.size = size;
        [original drawInRect:rect];
        
        UIImage *shinked;
        shinked = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        original = shinked;
        
#else
        CGRect bounds = CGRectMake(246,44,57, 57);
        original=[SoclivityUtilities updateResult:bounds.size originalImage:original switchCaseIndex:0];
#endif  
#endif        
         //if(!galleryImage)
         UIImageWriteToSavedPhotosAlbum(original, nil, nil, nil);
        [delegate imageCapture:original];
    }
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
