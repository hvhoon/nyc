//
//  ActivityTypeSelectView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityTypeSelectView.h"
#import "GetPlayersClass.h"
#import "MBProgressHUD.h"
#import "SoclivityManager.h"
#import "FilterPreferenceClass.h"
// Private properties
@interface ActivityTypeSelectView() <MBProgressHUDDelegate>
@end

@implementation ActivityTypeSelectView

@synthesize delegate,playerObj,isRegisteration;

// Defining the transparency used to display the tick for activity categories selected
#define HIDDEN 0.2
#define SHOW 1.0


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateActivityTypes{
    SOC=[SoclivityManager SharedInstance];
    idObj= SOC.filterObject;
    if(idObj.playAct){
        playImageView.alpha=SHOW;
        playUpdate=TRUE;
    }
    else{
        playImageView.alpha=HIDDEN;
        playUpdate=FALSE;
    }

    if(idObj.eatAct){
        eatImageView.alpha=SHOW;
        eatUpdate=TRUE;
    }
    else{
        eatImageView.alpha=HIDDEN;
        eatUpdate=FALSE;
        
    }

    
    if(idObj.createAct){
        createImageView.alpha=SHOW;
        createUpdate=TRUE;
    }
    else{
        createImageView.alpha=HIDDEN;
        createUpdate=FALSE;
        
    }

    if(idObj.seeAct){
        seeImageView.alpha=SHOW;
        seeUpdate=TRUE;
    }
    else{
        seeImageView.alpha=HIDDEN;
        seeUpdate=FALSE;
        
    }

    
    if(idObj.learnAct){
        learnImageView.alpha=SHOW;
        learnUpdate=TRUE;
    }
    else{
        learnImageView.alpha=HIDDEN;
        learnUpdate=FALSE;
        
    }

    
}

-(IBAction)getStartedClicked:(id)sender{
    
    if([self MakeSureAtLeastOneActivitySelected]){
        
        [delegate RegisterUserForTheFirstTime];
   
    }
    else{
        
        NSLog(@"No Activity Selected");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing here interests you?"
                                                        message:@"C'mon, please select at least 1 activity type!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
        return;

    }
}


-(IBAction)ActivitySelectClicked:(UIButton*)sender{
    
    SOC=[SoclivityManager SharedInstance];
    idObj= SOC.filterObject;
    int addRemove=0;
    switch (sender.tag) {
        case 1:
        {
            idObj.playAct=!idObj.playAct;
            
            if(idObj.playAct){
                playImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                playImageView.alpha=HIDDEN;
                addRemove=3;
            }

        }
            break;
            
        case 2:
        {
            idObj.eatAct=!idObj.eatAct;
            
            if(idObj.eatAct){
                eatImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                eatImageView.alpha=HIDDEN;
                addRemove=3;
                
            }

        }
            break;
        case 3:
        {
            idObj.seeAct=!idObj.seeAct;
            
            if(idObj.seeAct){
                seeImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                seeImageView.alpha=HIDDEN;
                addRemove=3;
                
            }

            
        }
            break;
        case 4:
        {
            idObj.createAct=!idObj.createAct;
            
            if(idObj.createAct){
                createImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                createImageView.alpha=HIDDEN;
                addRemove=3;
                
            }

        }
            break;
        case 5:
        {
            idObj.learnAct=!idObj.learnAct;
            
            if(idObj.learnAct){
                learnImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                learnImageView.alpha=HIDDEN;
                addRemove=3;
                
            }
            
        }
            break;
    }
    
    if(isRegisteration){
        if(!idObj.playAct && !idObj.eatAct && !idObj.createAct && !idObj.seeAct && !idObj.learnAct){
            [delegate showgetStartedBtnOrNot:NO];
        }
        else{
            [delegate showgetStartedBtnOrNot:YES];
        }
    }
    else{
        [delegate updateActivityTypes:addRemove];
    }
}

-(BOOL)MakeSureAtLeastOneActivitySelected{
    

    if(!idObj.playAct && !idObj.eatAct && !idObj.createAct && !idObj.seeAct && !idObj.
       learnAct){
        
        return NO;
    }
    
    else{
        return YES;
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
#pragma mark -
#pragma mark Animation methods

-(void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
// Start the animation
- (void)startAnimation{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self];
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Registering You";
    
    [self addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
}

// Stop the animation
- (void)stopAnimation{
    [HUD hide:YES];
}


- (void)dealloc {
    [super dealloc];
}
@end
