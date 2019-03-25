//
//  Message.h
//  ChatSample
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Location : NSObject

@property (nonatomic, retain) NSString* sender;
@property (nonatomic, retain) NSString* location;
@property (nonatomic) BOOL received;
@property (nonatomic, retain) NSDate* date;

@end
