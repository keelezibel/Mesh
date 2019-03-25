//
//  Announcement.h
//  ChatSample
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Announcement : NSObject

@property (nonatomic, retain) NSString* sender;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSDate* date;

@end
