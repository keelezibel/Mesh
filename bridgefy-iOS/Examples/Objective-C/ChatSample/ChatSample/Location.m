//
//  Message.m
//  ChatSample
//

#import "Location.h"

@implementation Location

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        self.sender = [decoder decodeObjectForKey:@"sender"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.received = [[decoder decodeObjectForKey:@"received"] boolValue];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.sender forKey:@"sender"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:@(self.received) forKey:@"received"];
    [encoder encodeObject:self.date forKey:@"date"];
}

@end
