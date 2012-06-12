//
//  ActivityEventViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventDetailView;
@class InfoActivityClass;
@interface ActivityEventViewController : UIViewController{
    
    EventDetailView *eventView;
    InfoActivityClass *activityInfo;
}
@property (nonatomic,retain)InfoActivityClass *activityInfo;
@end
