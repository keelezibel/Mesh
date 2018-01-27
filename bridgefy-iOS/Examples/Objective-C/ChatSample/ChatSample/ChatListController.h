//
//  ChatListController.h
//  ChatSample
//
//  Created by Daniel Heredia on 7/18/16.
//  Copyright © 2017 Bridgefy Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
