//
//  Announcement.m
//  ChatSample
//

#import "Announcement.h"

@implementation Announcement

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init]) {
        self.sender = [decoder decodeObjectForKey:@"sender"];
        self.text = [decoder decodeObjectForKey:@"text"];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:self.sender forKey:@"sender"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.date forKey:@"date"];
}

@end
