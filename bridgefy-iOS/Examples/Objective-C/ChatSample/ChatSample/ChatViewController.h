//
//  ChatViewController.h
//  ChatSample
//
//  Created by Daniel Heredia on 7/18/16.
//  Copyright © 2017 Bridgefy Inc. All rights reserved.
//

#import "Message.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const broadcastConversation;

@protocol ChatViewControllerDelegate <NSObject>

- (void)sendMessage:(Message*)message toConversation:(NSString*)uuid;

@end

@interface ChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate> {
}

@property (nonatomic, retain) NSString* userUUID;
@property (nonatomic, retain) NSString *deviceName;
@property (nonatomic) DeviceType deviceType;
@property (nonatomic) BOOL online;
@property (nonatomic) BOOL broadcastType;
@property (nonatomic) NSMutableArray* messages;
@property (nonatomic, weak) id<ChatViewControllerDelegate> chatDelegate;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic) BOOL shareLocation;
@property (nonatomic) NSTimer * shareLocationTimer;

- (void)addMessage:(Message*)message;
- (void)updateOnlineTo:(BOOL)onlineStatus;


//UI controls and actions
@property (nonatomic, retain) IBOutlet UILabel* onlineLabel;
@property (nonatomic, retain) IBOutlet UITextField* textField;
@property (nonatomic, retain) IBOutlet UIView* typeView;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint* keyboardConstraint;


- (IBAction)sendText:(id)sender;
- (IBAction)accessPhotoLib:(id)sender;
- (IBAction)accessCamera:(id)sender;

@end
