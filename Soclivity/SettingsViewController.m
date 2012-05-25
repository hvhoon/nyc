//
//  SettingsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "HomeViewController.h"
#import "UpComingEventsViewController.h"
#import "DDMenuController.h"
#import "WelcomeScreenViewController.h"

@implementation SettingsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 390)];
    [settingTableView setDelegate:self];
    [settingTableView setDataSource:self];
    [settingTableView setRowHeight:40];
    [settingTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    settingTableView.scrollEnabled=YES;
    [self.view addSubview:settingTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"MediaTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = 1;
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        
		cell.textLabel.text = @"Logout";
        cell.detailTextLabel.text = @"Check This Out";
		
        // Only load cached images; defer new downloads until scrolling ends
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    UpComingEventsViewController *controller = [[UpComingEventsViewController alloc] init];
    WelcomeScreenViewController *welcomeScreenViewController=[[WelcomeScreenViewController alloc] initWithNibName:@"WelcomeScreenViewController" bundle:nil];
	[[self navigationController] pushViewController:welcomeScreenViewController animated:YES];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:welcomeScreenViewController];
    
    [menuController setRootController:navController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [welcomeScreenViewController release];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
