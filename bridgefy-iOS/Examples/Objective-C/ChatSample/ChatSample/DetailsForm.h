//
//  DetailsForm.h
//  ChatSample
//
//  Created by Le Tang Boon on 2/23/18.
//  Copyright © 2018 Bridgefy Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsForm : UIViewController <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, retain) IBOutlet UIImageView * _Nullable cameraView;
@property (nonatomic, retain) IBOutlet UIButton * _Nonnull snapPhoto;
@property (nonatomic, retain) IBOutlet UITextField * _Nonnull  titleText;
@property (nonatomic, retain) IBOutlet UITextView * _Nonnull descText;
@property (nonatomic, retain) IBOutlet UISwitch * _Nonnull statusSwitch;

- (IBAction)snapPhoto:(id _Nonnull )sender;
- (IBAction)submitAction:(id _Nonnull )sender;

@end
