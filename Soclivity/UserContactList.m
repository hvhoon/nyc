//
//  UserContactList.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserContactList.h"
#import "JSON/JSON.h"
@implementation UserContactList

-(id)init{
    
    if (self = [super init]) {
        
    }
    return self;
    
}


-(int)GetAddressBookcount{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
	return nPeople;
	
}
-(void)GetAddressBook
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
	NSMutableArray *content = [NSMutableArray new];
	NSMutableArray *jsonContentArray=[NSMutableArray new];
	CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
	CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
	
	for(int i = 0 ; i < nPeople ; i++) {
		NSMutableArray *contactNames = [[[NSMutableArray alloc] init] autorelease];
        NSMutableArray *personDealingWithEmails = [[[NSMutableArray alloc] init]autorelease];
		NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
		NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
		NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
		ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i );
		NSString *name  = (NSString *)ABRecordCopyCompositeName(ref);
		NSString *status=@"Invite";
		NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init]autorelease];
        
		ABMutableMultiValueRef multi = ABRecordCopyValue(ref, kABPersonEmailProperty);
		if (ABMultiValueGetCount(multi) > 0) {
			bool insertNewElement = TRUE;
            if(name!=nil){
            NSArray *wordsAndEmptyStrings = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
                NSString*firstName=nil;
                NSString*lastName=nil;
            if([words count]>=2){
                firstName=[words objectAtIndex:0];
                lastName=[words objectAtIndex:1];
                [dictionary setObject:firstName forKey:@"first_name"];
                [dictionary setObject:lastName forKey:@"last_name"];

            }
            else{
                firstName=[words objectAtIndex:0];
                [dictionary setObject:firstName forKey:@"first_name"];

            }
			}
			CFStringRef emailRefIndex = ABMultiValueCopyValueAtIndex(multi, 0);
			[dictionary setObject:(NSString*)emailRefIndex forKey:@"email"];
			[jsonContentArray addObject:dictionary];
			CFRelease(emailRefIndex);
			
			unichar *buffer = calloc([name length], sizeof(unichar));
			[name getCharacters:buffer];
			*buffer = toupper(*buffer);
			NSUInteger length = 1;
			NSString *headerLetter = [[NSString alloc] initWithCharacters:(const unichar *)buffer length:length];
			//NSString *headerLetter=[name characterAtIndex:0];
			[row setValue:[NSString stringWithString:headerLetter] forKey:@"headerTitle"];
			if(name!=nil)
                [contactNames addObject:name];
			for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
				CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
				
				
				[personDealingWithEmails addObject:(NSString *)emailRef];
				CFRelease(emailRef);
				
			}
			for(NSDictionary *dict in content) {
				NSString *headerKey = [dict objectForKey:@"headerTitle"];
				unichar firstCharOfName = toupper([name characterAtIndex:0]);
				if ([headerKey characterAtIndex:0] == firstCharOfName) {
					NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
					[elements setValue:personDealingWithEmails forKey:@"Email"];
					[elements setValue:name forKey:@"ContactNames"];
					[elements setValue:status forKey:@"StatusMessage"];
					[oldEntries addObject:elements];
					insertNewElement = FALSE;
					break;
				}
				else {
					insertNewElement = TRUE;    
				}
			}					
			if (insertNewElement) {
				[elements setValue:personDealingWithEmails forKey:@"Email"];
				[elements setValue:name forKey:@"ContactNames"];
				[elements setValue:status forKey:@"StatusMessage"];
				[entries addObject:elements];
				[row setValue:entries forKey:@"Elements"];
				[content addObject:row];
			}
		}
		CFRelease(multi);
	}
    
	
	
	
	NSString *requestString =[jsonContentArray JSONRepresentation];
    NSLog(@"requestString=%@",requestString);
	
    
	
}
@end
