//
//  Message.h
//  ChatSample
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Message : NSObject

typedef NS_ENUM(NSUInteger, DeviceType) {
    DeviceTypeUndefined = 0,
    DeviceTypeAndroid,
    DeviceTypeIos
};

@property (nonatomic, retain) NSString* sender;
@property (nonatomic, retain) NSString* text;
@property (nonatomic) BOOL announcement;
@property (nonatomic, retain) NSData* imageData;
@property (nonatomic) BOOL received;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic) BOOL mesh;
@property (nonatomic) BOOL broadcast;
@property (nonatomic) DeviceType deviceType;

@end
