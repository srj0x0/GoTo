//
//  GTOGlobalHotkeyMonitor.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/16/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

typedef void(^GTOGlobalHotkeyMonitorAction)(void);

@interface GTOGlobalHotkeyMonitor : NSObject

+ (instancetype)monitorWithCarbonKey:(UInt32)key modifiers:(UInt32)modifiers;

- (void)beginKeyboardListening:(GTOGlobalHotkeyMonitorAction)action;
- (void)endKeyboardListening;

@end
