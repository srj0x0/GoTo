//
//  GTOLocalHotkeyMonitor.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/16/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

typedef void(^GTOLocalHotkeyMonitorAction)(void);

@interface GTOLocalHotkeyMonitor : NSObject

+ (instancetype)monitorWithCarbonKey:(UInt32)key modifiers:(NSEventModifierFlags)modifiers;

- (void)beginKeyboardListening:(GTOLocalHotkeyMonitorAction)action;
- (void)endKeyboardListening;

@end
