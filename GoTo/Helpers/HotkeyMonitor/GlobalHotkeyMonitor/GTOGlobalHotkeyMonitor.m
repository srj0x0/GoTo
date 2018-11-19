//
//  GTOGlobalHotkeyMonitor.m
//  GoTo
//
//  Created by Sergey Dokukin on 11/16/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOGlobalHotkeyMonitor.h"

static const OSType kGTOGlobalHotkeySignature = 'GoTo';

@interface GTOGlobalHotkeyMonitor()

@property (strong, nonatomic) GTOGlobalHotkeyMonitorAction action;
@property (assign, nonatomic) UInt32 key;
@property (assign, nonatomic) UInt32 modifiers;

@end

@implementation GTOGlobalHotkeyMonitor
{
    EventHandlerRef eventHandlerReference;
    EventHotKeyRef hotkeyReference;
    EventHotKeyID identifier;
    EventTypeSpec type;
}

+ (instancetype)monitorWithCarbonKey:(UInt32)key modifiers:(UInt32)modifiers {
    return [[self alloc] initWithCarbonKey:key modifiers:modifiers];
}

- (instancetype)initWithCarbonKey:(UInt32)key modifiers:(UInt32)modifiers {
    self = [super init];
    if (self) {
        _key = key;
        _modifiers = modifiers;
        identifier.signature = kGTOGlobalHotkeySignature;
        identifier.id = key + modifiers;
        type.eventClass=kEventClassKeyboard;
        type.eventKind=kEventHotKeyPressed;
        InstallApplicationEventHandler(&handle, 1, &type, (__bridge void *)(self), &eventHandlerReference);
    }
    return self;
}

- (void)beginKeyboardListening:(GTOGlobalHotkeyMonitorAction)action {
    self.action = action;
    RegisterEventHotKey(self.key, self.modifiers, identifier, GetApplicationEventTarget(), 0, &hotkeyReference);
}

- (void)endKeyboardListening {
    if (hotkeyReference) {
        UnregisterEventHotKey(hotkeyReference);
    }
}

OSStatus handle(EventHandlerCallRef nextHandler, EventRef theEvent , void *userData) {
    GTOGlobalHotkeyMonitor *unwrappedSelf = (__bridge GTOGlobalHotkeyMonitor *)(userData);
    unwrappedSelf.action();
    return noErr;
}

- (void)dealloc {
    RemoveEventHandler(eventHandlerReference);
    [self endKeyboardListening];
}

@end
