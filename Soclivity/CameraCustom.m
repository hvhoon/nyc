//
//  CameraCustom.m
//  Xling
//
//  Created by Kanav Gupta on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraCustom.h"
#include <CoreFoundation/CoreFoundation.h>

@implementation CameraCustom
@synthesize m_picker,delegate,galleryImage;

- (id)init{
	if(![super init]){
		return nil;
	}
	m_picker=[[UIImagePickerController alloc]init];
    m_picker.allowsEditing = YES;
	m_picker.delegate = self;

	return self;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo 
{
    
    NSLog(@"didFinishPickingMediaWithInfo");
    NSString *mediaType = [editingInfo objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"]){
        UIImage*original=[editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"found an image");
        
        CGSize size = {320, 460-48};
        UIGraphicsBeginImageContext(size);
        
        CGRect rect;
        rect.origin = CGPointZero;
        rect.size = size;
        [original drawInRect:rect];
        
        UIImage *shinked;
        shinked = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        original = shinked;
         //if(!galleryImage)
         UIImageWriteToSavedPhotosAlbum(original, nil, nil, nil);
        
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		
		NSMutableString *imageName = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
		
		CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
		if (theUUID) {
			[imageName appendString:NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID))];
            CFRelease(theUUID);
		}
		[imageName appendString:@".png"];
		NSString *imagePath=[NSString stringWithFormat:@"%@/%@",documentsDirectory,imageName];
		NSLog(@"ImagePath=%@",imagePath);
		//extracting image from the picker and saving it
		NSData *imageData = UIImagePNGRepresentation(original);
		[imageData writeToFile:imagePath atomically:YES];

        [delegate imageCapture:imagePath andUIImage:original];
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