#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

@property (strong, nonatomic) NSArray *allContacts;

@end

@interface Contact : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *phones;
@property (copy, nonatomic) NSArray *emails;

@property (nonatomic, readonly) NSString *sortName;
@property (nonatomic, readonly) NSString *displayName;

- (void)configureName;

@end
