//
//  DetailsForm.m
//  ChatSample
//

#import "DetailsForm.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailsForm ()

@end

@implementation DetailsForm

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameText.delegate = self;
    self.descText.delegate = self;

    self.nameText.layer.borderWidth = 1.0f;
    self.nameText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descText.layer.borderWidth = 1.0f;
    self.descText.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -70; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textViewDidBeginEditing:(UITextField *)textView
{
    [self animateTextView:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextField *)textView
{
    [self animateTextView:textView up:NO];
}

-(void)animateTextView:(UITextField*)textView up:(BOOL)up
{
    const int movementDistance = -70; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextView" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void) dismissKeyboard
{
    // add self
    [self.descText resignFirstResponder];
    [self.nameText resignFirstResponder];
}

- (IBAction)submitForm:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

@end
