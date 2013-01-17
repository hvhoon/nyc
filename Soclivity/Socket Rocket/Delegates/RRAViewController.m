//
//  RRAViewController.m
//  PrivatePubSocketRocketExample
//
//  Created by Raphael Randschau on 4/14/12.
//  Copyright (c) 2012 Weluse gmbH. All rights reserved.
//

#import "RRAViewController.h"
#import "AppDelegate.h"

@interface RRAViewController ()
  @property (nonatomic, retain) SRWebSocket *websocketClient;
  @property (nonatomic, retain) PrivatePubWebSocketDelegate* websocketDelegate;
  
- (void) initializePrivatePubClientWithSubscriptionInformation: (id) JSON:(NSString *)lstrnewschnl;
@end

@implementation RRAViewController

@synthesize websocketClient = _websocketClient, 
            websocketDelegate = _websocketDelegate;

- (void) initializePrivatePubClientWithSubscriptionInformation: (id) JSON:(NSString *)lstrnewschnl {
    
    self.websocketDelegate = [[PrivatePubWebSocketDelegate alloc]
    initWithPrivatePubTimestamp: [JSON valueForKeyPath:@"timestamp"] 
    andSignature: [JSON valueForKeyPath:@"signature"] 
    andChannel:lstrnewschnl];
  
  NSString *server = [JSON valueForKeyPath:@"server"];
  NSURL *url = [NSURL URLWithString:server];
    
  NSMutableURLRequest *configurationRequest = [[NSMutableURLRequest requestWithURL:url] retain];
    
  self.websocketClient = [[SRWebSocket alloc] initWithURLRequest:configurationRequest];
  self.websocketClient.delegate = self.websocketDelegate;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.objsrwebsocket = self.websocketClient;
    
    
  [self.websocketClient open];
}

- (void) fetchPrivatePubConfiguration:(NSString *)lstrnewchannel {
//  NSString *resourceUrl = [NSString stringWithFormat:@"http://localhost:3000/api/websockets/configuration.json?channel=%@", NEW_MESSAGES_CHANNEL];
    
    NSString *resourceUrl = [NSString stringWithFormat:@"http://dev.soclivity.com/api/websockets/configuration.json?channel=%@",lstrnewchannel];
    
  NSURL *url = [NSURL URLWithString:resourceUrl];
    
  NSURLRequest *request = [NSURLRequest requestWithURL:url];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self initializePrivatePubClientWithSubscriptionInformation: JSON:lstrnewchannel];
    } 
    failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id JSON) {
      NSLog(@"request was failed: %@", error);
    }
  ];

  [operation start];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
