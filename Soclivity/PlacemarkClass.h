//
//  PlacemarkClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacemarkClass : NSObject{
  
    
    float latitude;
    float longitude;
    NSString*formattedAddress;
    NSString *vicinityAddress;
}
@property (nonatomic,retain) NSString*formattedAddress;
@property (nonatomic,retain) NSString*vicinityAddress;
@property (nonatomic,assign) float latitude;
@property (nonatomic,assign) float longitude;
@end
