//
//  MapPerson.h
//  ChatSample
//

#import <UIKit/UIKit.h>

@interface MapPerson : UITableViewCell
@property(nonnull,strong) IBOutlet UIImageView *imgPerson;
@property(nonnull,strong) IBOutlet UILabel *titlePerson;
@property(nonnull,strong) IBOutlet UILabel *descPerson;

//-(void)updateCellWithTitle:(nonnull NSString *)title description:(nonnull NSString *)desc image:(nonnull NSString *)img;
-(void)updateCellWithTitle:(nonnull NSString *)title description:(nonnull NSString *)desc;

@end
