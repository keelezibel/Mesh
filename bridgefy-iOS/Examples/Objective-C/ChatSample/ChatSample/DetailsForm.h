//
//  DetailsForm.h
//  ChatSample
//

#import <UIKit/UIKit.h>
#import "Announcement.h"

@interface DetailsForm : UIViewController <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, retain) IBOutlet UITextField * _Nonnull  nameText;
@property (nonatomic, retain) IBOutlet UITextView * _Nonnull descText;
@property (nonatomic, retain) IBOutlet UISwitch * _Nonnull statusSwitch;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descField;

- (IBAction)submitForm:(id)sender;
@end
