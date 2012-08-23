#import "TableViewController.h"

@implementation TableViewController

@synthesize allContacts;

#pragma mark - UIViewController

- (void)viewDidUnload {
    allContacts = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"My Contacts", nil);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Contact *contact = [allContacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.displayName;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [allContacts objectAtIndex:indexPath.row];
    UIViewController *detailViewController = [[UIViewController alloc] init];
    detailViewController.title = contact.displayName;
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController.view.backgroundColor = [UIColor whiteColor];
}

@end

#pragma mark - Contact

@implementation Contact

@synthesize name;
@synthesize phones;
@synthesize emails;

@synthesize sortName;
@synthesize displayName;

- (void)configureName {
    if (self.name) {
        displayName = self.name;
    } else if (self.emails.count) {
        displayName = [self.emails objectAtIndex:0];
    } else if (self.phones.count) {
        displayName = [self.phones objectAtIndex:0];
    }
    
    if (self.displayName) {
        sortName = [displayName lowercaseString];
    }
}

@end
