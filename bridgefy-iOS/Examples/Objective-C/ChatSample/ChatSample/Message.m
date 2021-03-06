//
//  Message.m
//  ChatSample
//

#import "Message.h"

@implementation Message

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        self.sender = [decoder decodeObjectForKey:@"sender"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.imageData = [decoder decodeObjectForKey:@"image"];
        self.received = [[decoder decodeObjectForKey:@"received"] boolValue];
        self.announcement = [[decoder decodeObjectForKey:@"announcement"] boolValue];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.mesh = [[decoder decodeObjectForKey:@"mesh"] boolValue];
        self.broadcast = [[decoder decodeObjectForKey:@"broadcast"] boolValue];
        self.deviceType = (DeviceType)[[decoder decodeObjectForKey:@"device_type"] intValue];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.sender forKey:@"sender"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.imageData forKey:@"image"];
    [encoder encodeObject:@(self.received) forKey:@"received"];
    [encoder encodeObject:@(self.announcement) forKey:@"announcement"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:@(self.mesh) forKey:@"mesh"];
    [encoder encodeObject:@(self.broadcast) forKey:@"broadcast"];
    [encoder encodeObject:@(self.deviceType) forKey:@"device_type"];
}

@end
