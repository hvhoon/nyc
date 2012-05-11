//
//  ActivityTypeSelectView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityTypeSelectView.h"

@implementation ActivityTypeSelectView
@synthesize delegate;
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
        playImageView.hidden=NO;
    }
    else{
        playImageView.hidden=YES;
        
    }
}
                                          
-(IBAction)eatActivityClicked:(id)sender{
    eat=!eat;
    
    if(eat){
        eatImageView.hidden=NO;
    }
    else{
        eatImageView.hidden=YES;
        
    }
}
-(IBAction)seeActivityClicked:(id)sender{
    see=!see;
    
    if(see){
        seeImageView.hidden=NO;
    }
    else{
        seeImageView.hidden=YES;
        
    }
}
-(IBAction)createActivityClicked:(id)sender{
    create=!create;
    
    if(create){
        createImageView.hidden=NO;
    }
    else{
        createImageView.hidden=YES;
        
    }
}
-(IBAction)learnActivityClicked:(id)sender{
    learn=!learn;
    
    if(learn){
        learnImageView.hidden=NO;
    }
    else{
        learnImageView.hidden=YES;
        
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}


@end
