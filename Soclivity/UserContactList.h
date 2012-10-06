//
//  UserContactList.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@protocol UserContactListDelegate <NSObject>

@optional
-(void)addressBookHelperError;
-(void)addressBookHelperDeniedAcess;
-(void)AddressBookSuccessful:(NSString*)response;
@end

@interface UserContactList : NSObject{
    
    id<UserContactListDelegate>delegate;
}
@property (nonatomic,retain)id<UserContactListDelegate>delegate;
-(int)GetAddressBookcount;
-(NSString*)GetAddressBook:(ABAddressBookRef)addressBook;
-(void)loadContacts;
@end
