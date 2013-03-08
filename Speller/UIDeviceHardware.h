//
//  UIDeviceHardware.h
//  game001
//
//  Created by liulei on 3/12/12.
//  Copyright (c) 2012 NibiruTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject 

- (NSString *)platform;
- (NSString *)platformString;
- (NSString *)getMacAddress;
- (BOOL)isJailBroken;

@end
