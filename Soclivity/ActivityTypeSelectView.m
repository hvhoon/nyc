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
#define kOneActivityAlert 13
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
    
    SOC.filterObject.playDD=idObj.playAct;
    SOC.filterObject.eatDD=idObj.eatAct;
    SOC.filterObject.seeDD=idObj.seeAct;
    SOC.filterObject.createDD=idObj.createAct;
    SOC.filterObject.learnDD=idObj.learnAct;
    switch (sender.tag) {
        case 1:
        {
            idObj.playAct=!idObj.playAct;
            checkType=1;
            
            if(idObj.playAct){
                
                SOC.filterObject.playDD=TRUE;

                playImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                SOC.filterObject.playDD=FALSE;
                playImageView.alpha=HIDDEN;
                addRemove=3;
            }

        }
            break;
            
        case 2:
        {
            idObj.eatAct=!idObj.eatAct;
            checkType=2;
            
            if(idObj.eatAct){
                
                SOC.filterObject.eatDD=TRUE;
                eatImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                SOC.filterObject.eatDD=FALSE;
                eatImageView.alpha=HIDDEN;
                addRemove=3;
                
            }

        }
            break;
        case 3:
        {
            idObj.seeAct=!idObj.seeAct;
            checkType=3;
            
            if(idObj.seeAct){
                SOC.filterObject.seeDD=TRUE;
                seeImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                SOC.filterObject.seeDD=FALSE;
                seeImageView.alpha=HIDDEN;
                addRemove=3;
                
            }

            
        }
            break;
        case 4:
        {
            idObj.createAct=!idObj.createAct;
            checkType=4;
            
            if(idObj.createAct){
                
                SOC.filterObject.createDD=TRUE;
                createImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                SOC.filterObject.createDD=FALSE;
                createImageView.alpha=HIDDEN;
                addRemove=3;
                
            }

        }
            break;
        case 5:
        {
            idObj.learnAct=!idObj.learnAct;
            checkType=5;
            
            if(idObj.learnAct){
                SOC.filterObject.learnDD=TRUE;
                learnImageView.alpha=SHOW;
                addRemove=2;
            }
            else{
                SOC.filterObject.learnDD=FALSE;
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
        if([self MakeSureAtLeastOneActivitySelected]){
           [delegate updateActivityTypes:addRemove];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select at least 1 activity" message:nil
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=kOneActivityAlert;
            [alert show];
            [alert release];
            return;
            
        }

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
#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[alertView resignFirstResponder];
    
    if (buttonIndex == 0) {
        
        switch (alertView.tag) {
            case kOneActivityAlert:
            {
                [self updateUncheckActivity];
            }
                break;
            default:
                break;
        }
    }
    else
        NSLog(@"Clicked Cancel Button");
    
}

-(void)updateUncheckActivity{
    switch(checkType){
        case 1:
        {
            idObj.playAct=TRUE;
            SOC.filterObject.playDD=TRUE;
            playImageView.alpha=SHOW;
        }
            break;
            
        case 2:
        {
            idObj.eatAct=TRUE;
            SOC.filterObject.eatDD=TRUE;
            eatImageView.alpha=SHOW;
            
        }
            break;
        case 3:
        {
            idObj.seeAct=TRUE;
            SOC.filterObject.seeDD=TRUE;
            seeImageView.alpha=SHOW;
            
            
        }
            break;
        case 4:
        {
            createImageView.alpha=SHOW;
            SOC.filterObject.createDD=TRUE;
            idObj.createAct=TRUE;
            
        }
            break;
        case 5:
        {
            idObj.learnAct=TRUE;
            SOC.filterObject.learnDD=TRUE;
            learnImageView.alpha=SHOW;
            
        }
            break;
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
