//
//  GTOLocalHotkeyMonitor.m
//  GoTo
//
//  Created by Sergey Dokukin on 11/16/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOLocalHotkeyMonitor.h"

@interface GTOLocalHotkeyMonitor()

@property (strong, nonatomic) GTOLocalHotkeyMonitorAction action;
@property (assign, nonatomic) UInt32 key;
@property (assign, nonatomic) NSEventModifierFlags modifiers;
@property (strong, nonatomic) id eventMonitor;

@end

@implementation GTOLocalHotkeyMonitor

+ (instancetype)monitorWithCarbonKey:(UInt32)key modifiers:(NSEventModifierFlags)modifiers {
    return [[self alloc] initWithCarbonKey:key modifiers:modifiers];
}

- (instancetype)initWithCarbonKey:(UInt32)key modifiers:(NSEventModifierFlags)modifiers {
    self = [super init];
    if (self) {
        _key = key;
        _modifiers = modifiers;
    }
    return self;
}

- (void)beginKeyboardListening:(GTOLocalHotkeyMonitorAction)action {
    self.action = action;
    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent *event) {
        if (event.keyCode == self.key && (event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == self.modifiers) {
            self.action();
            return nil;
        }
        return event;
    }];
}

- (void)endKeyboardListening {
    if (self.eventMonitor) {
        [NSEvent removeMonitor:self.eventMonitor];
    }
}

- (void)dealloc
{
    [self endKeyboardListening];
}

@end
