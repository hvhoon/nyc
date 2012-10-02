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

#define kPlay 0
#define kEat 1
#define kSee 2
#define kCreate 3
#define kLearn 4

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
    }
    else{
        playImageView.alpha=HIDDEN;
    }

    if(idObj.eatAct){
        eatImageView.alpha=SHOW;
    }
    else{
        eatImageView.alpha=HIDDEN;
        
    }

    
    if(idObj.createAct){
        createImageView.alpha=SHOW;
    }
    else{
        createImageView.alpha=HIDDEN;
        
    }

    if(idObj.seeAct){
        seeImageView.alpha=SHOW;
    }
    else{
        seeImageView.alpha=HIDDEN;
        
    }

    
    if(idObj.learnAct){
        learnImageView.alpha=SHOW;
    }
    else{
        learnImageView.alpha=HIDDEN;
        
    }

    
}

-(IBAction)getStartedClicked:(id)sender{
    [self MakeSureAtLeastOneActivitySelected];
}


-(IBAction)ActivitySelectClicked:(UIButton*)sender{
    
    SOC=[SoclivityManager SharedInstance];
    idObj= SOC.filterObject;

    switch (sender.tag) {
        case 1:
        {
            idObj.playAct=!idObj.playAct;
            
            if(idObj.playAct){
                playImageView.alpha=SHOW;
            }
            else{
                playImageView.alpha=HIDDEN;
            }

        }
            break;
            
        case 2:
        {
            idObj.eatAct=!idObj.eatAct;
            
            if(idObj.eatAct){
                eatImageView.alpha=SHOW;
            }
            else{
                eatImageView.alpha=HIDDEN;
                
            }

        }
            break;
        case 3:
        {
            idObj.seeAct=!idObj.seeAct;
            
            if(idObj.seeAct){
                seeImageView.alpha=SHOW;
            }
            else{
                seeImageView.alpha=HIDDEN;
                
            }

            
        }
            break;
        case 4:
        {
            idObj.createAct=!idObj.createAct;
            
            if(idObj.createAct){
                createImageView.alpha=SHOW;
            }
            else{
                createImageView.alpha=HIDDEN;
                
            }

        }
            break;
        case 5:
        {
            idObj.learnAct=!idObj.learnAct;
            
            if(idObj.learnAct){
                learnImageView.alpha=SHOW;
            }
            else{
                learnImageView.alpha=HIDDEN;
                
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
        
    }
}

-(void)MakeSureAtLeastOneActivitySelected{
    
    SOC=[SoclivityManager SharedInstance];
    playerObj=SOC.registrationObject;

    if(!idObj.playAct && !idObj.eatAct && !idObj.createAct && !idObj.seeAct && !idObj.learnAct){
        NSLog(@"No Activity Selected");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing here interests you?"
                                                        message:@"C'mon, please select at least 1 activity type!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
        return;
    }
    else{
        NSString *activitySelect=nil;
        for(int i=0;i<5;i++){
            switch (i) {
                case kPlay:
                {
                    if(idObj.playAct){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"1"];
                    }
                }
                    break;
                    
                case kEat:
                {
                    if(idObj.eatAct){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"2"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,2",activitySelect];
                            
                        }
                    }
                }
                    break;
                case kSee:
                {
                    if(idObj.seeAct){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"3"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,3",activitySelect];
                            
                        }
                    }
                }
                    break;
                case kCreate:
                {
                    if(idObj.createAct){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"4"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,4",activitySelect];
                            
                        }
                    }
                }
                    break;
                case kLearn:
                {
                    if(idObj.learnAct){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"5"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,5",activitySelect];
                            
                        }
                    }
                }
                    break;

   
                    
            }
        }
        playerObj.activityTypes=activitySelect;
        [delegate RegisterUserForTheFirstTime];
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
