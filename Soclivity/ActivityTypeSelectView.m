//
//  ActivityTypeSelectView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityTypeSelectView.h"
#import "GetPlayersClass.h"
@implementation ActivityTypeSelectView

@synthesize delegate,playerObj;

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

-(IBAction)getStartedClicked:(id)sender{
    [delegate pushHomeMapViewController];
}

-(IBAction)playActivityClicked:(id)sender{
    play=!play;

    if(play){
        playImageView.alpha=SHOW;
    }
    else{
        playImageView.alpha=HIDDEN;
    }
}
                                          
-(IBAction)eatActivityClicked:(id)sender{
    eat=!eat;
    
    if(eat){
        eatImageView.alpha=SHOW;
    }
    else{
        eatImageView.alpha=HIDDEN;
        
    }
}
-(IBAction)seeActivityClicked:(id)sender{
    see=!see;
    
    if(see){
        seeImageView.alpha=SHOW;
    }
    else{
        seeImageView.alpha=HIDDEN;
        
    }
}
-(IBAction)createActivityClicked:(id)sender{
    create=!create;
    
    if(create){
        createImageView.alpha=SHOW;
    }
    else{
        createImageView.alpha=HIDDEN;
        
    }
}
-(IBAction)learnActivityClicked:(id)sender{
    learn=!learn;
    
    if(learn){
        learnImageView.alpha=SHOW;
    }
    else{
        learnImageView.alpha=HIDDEN;
        
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}


@end
