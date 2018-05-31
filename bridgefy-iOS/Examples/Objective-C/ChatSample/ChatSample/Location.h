//
//  Message.h
//  ChatSample
//
//  Created by Daniel Heredia on 7/19/16.
//  Copyright © 2017 Bridgefy Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Location : NSObject

@property (nonatomic, retain) NSString* sender;
@property (nonatomic, retain) NSString* location;
@property (nonatomic) BOOL received;
@property (nonatomic, retain) NSDate* date;

@end
