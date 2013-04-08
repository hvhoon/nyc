//
//  GetUsersByFirstLastNameInvocation.m
//  Soclivity
//
//  Created by Kanav on 11/20/12.
//
//

#import "GetUsersByFirstLastNameInvocation.h"
#import "InviteObjectClass.h"
#import "InviteObjectClass+Parse.h"

@implementation GetUsersByFirstLastNameInvocation
@synthesize searchName,playerId,activityId,typeOfSearch;
-(void)dealloc {
	[super dealloc];
}


-(void)invoke {
    
    //NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/mutualfriends.json?pid=&fid="];
        //NSString*a= [NSString stringWithFormat:@"dev.soclivity.com/players/search_contact.json?id=%d&aid=%d&name=%@",playerId,activityId,searchName];
    NSString *a=nil;
    switch (typeOfSearch) {
        case 1:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/players/global_search.json?id=%d&aid=%d&name=%@",playerId,activityId,searchName];
            
        }
            break;
            
        case 2:
        {
            a= [NSString stringWithFormat:@"dev.soclivity.com/players/searchuser.json?id=%d&name=%@",playerId,searchName];
            
        }
            break;
    }
    

    
    [self get:a];
}

-(BOOL)handleHttpOK:(NSMutableData *)data {
    
    
    NSLog(@"handleHttpOK");
	NSDictionary* resultsd = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    NSLog(@"resultsd=%@",resultsd);
    NSArray*response=nil;
    switch (typeOfSearch) {
        case 1:
        {
            response =[InviteObjectClass PlayersInvitesGlobalSearchToActivity:resultsd];

        }
            break;
            
        case 2:
        {
            response =[InviteObjectClass PlayersInvitesToJoinSoclivityParse:resultsd];
            
        }
            break;
    }

	[self.delegate SearchUsersInvocationDidFinish:self withResponse:response type:typeOfSearch withError:Nil];
	return YES;
}

-(BOOL)handleHttpError:(NSInteger)code {
	[self.delegate SearchUsersInvocationDidFinish:self
                                         withResponse:nil type:typeOfSearch
                                            withError:[NSError errorWithDomain:@"UserId"
                                                                          code:[[self response] statusCode]
                                                                      userInfo:[NSDictionary dictionaryWithObject:@"Failed to Get activities for a user. Please try again later" forKey:@"message"]]];
	return YES;
}
@end
