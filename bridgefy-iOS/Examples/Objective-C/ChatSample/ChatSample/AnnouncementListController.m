//
//  AnnouncementListController.m
//  ChatSample
//

#import "AnnouncementListController.h"
#import "ChatListController.h"

@interface AnnouncementListController ()

@end

@implementation AnnouncementListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.announcements = [self loadAnnouncements];
    if(self.announcements != nil) {
        [self addRowToTable];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSMutableArray * newArray = [self loadAnnouncements];
    if(newArray != nil) {
        if([newArray count] != [self.announcements count]){
            self.announcements = newArray;
            [self addRowToTable];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addRowToTable
{
    [self.tableView beginUpdates];
    NSIndexPath* index = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[ index ] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

#pragma mark - Table Data Source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of announcements: %lu",[self.announcements count]);
    return [self.announcements count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"announcementCell" forIndexPath:indexPath];
    
    UILabel* userLabel = [(UILabel*)cell.contentView viewWithTag:1000];
    UILabel* messageLabel = [(UILabel*)cell.contentView viewWithTag:1001];
    UILabel* dateLabel = [(UILabel*)cell.contentView viewWithTag:1002];

    Announcement* announcement = [self.announcements objectAtIndex:indexPath.item];
    userLabel.textColor = [UIColor redColor];
    userLabel.text = announcement.sender;
    messageLabel.text = announcement.text;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    dateLabel.text = [dateFormatter stringFromDate:announcement.date];

    return cell;
}

#pragma mark - Table Delegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSMutableArray *)loadAnnouncements
{
    NSString * announcementFile = @"announcementfile";
    NSString * filePath = FULLPATHCHECK(announcementFile);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableArray *messages;
    if (data) {
        messages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return messages;
}

@end
