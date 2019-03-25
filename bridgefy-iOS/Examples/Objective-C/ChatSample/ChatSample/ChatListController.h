//
//  ChatListController.h
//  ChatSample
//

#import <UIKit/UIKit.h>

@interface ChatListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
