//
//  AnnouncementListController.h
//  ChatSample
//

#import <UIKit/UIKit.h>
#import "Announcement.h"
#define FULLPATHCHECK(X) [[NSSearchPathForDirectoriesInDomains\
(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]\
stringByAppendingPathComponent:(X)]


@interface AnnouncementListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
}

@property (nonatomic) NSMutableArray* announcements;

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end
