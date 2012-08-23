#import "AppDelegate.h"
#import "TableViewController.h"

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // IMPORTANT: Add "AddressBook.framework" to Targets --> Summary --> Linked Frameworks & Libraries
    
    // Create the address book object.
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex personCount = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *contactsArray = ((personCount > 0 && personCount < 100000) ?
                                     [NSMutableArray arrayWithCapacity:personCount] :
                                     [NSMutableArray arrayWithCapacity:250]);
    //CFIndex is weird and sometimes returns max NSInteger, which overflows array capacity
    
    // Create the array of contact objects to upload.
    for (int i = 0; i < personCount; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFRetain(person);
        
        Contact *contact = [[Contact alloc] init];
        
        // Parse the name from the Address book entity.
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person,
                                                                  kABPersonFirstNameProperty));
        NSString *middleName = CFBridgingRelease(ABRecordCopyValue(person,
                                                                   kABPersonMiddleNameProperty));
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person,
                                                                 kABPersonLastNameProperty));

        if (firstName || middleName || lastName) {
            contact.name = [NSString stringWithFormat:@"%@ %@ %@",
                            (firstName ? firstName : @""),
                            (middleName ? middleName : @""),
                            (lastName ? lastName : @""), nil];
            // May still contain extraneous white spaces.
        }
        
        // Phones
        ABMultiValueRef phonesRefs = ABRecordCopyValue(person, kABPersonPhoneProperty);
        contact.phones = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(phonesRefs));
        CFRelease(phonesRefs);
        
        // Emails
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        contact.emails = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(emails));
        CFRelease(emails);
        
        CFRelease(person);
        
        [contact configureName];
        [contactsArray addObject:contact];
    }
    
    // Sort array by name
    [contactsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Contact *contact1 = (Contact *)obj1;
        Contact *contact2 = (Contact *)obj2;
        return [contact1.sortName compare:contact2.sortName];
    }];
    
    // Init and show the root tableView
    TableViewController *tableViewController = [[TableViewController alloc]
                                                initWithStyle:UITableViewStylePlain];
    tableViewController.allContacts = contactsArray;
    self.window.rootViewController =
    [[UINavigationController alloc] initWithRootViewController:tableViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
