//
//  GTOItemsListCoordinator.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/30/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GTOItemsListCoordinator.h"
#import "GTOItemsListModel.h"
#import "GTOItemsListViewController.h"
#import "GTOCoreDataStack.h"
#import "GTOGlobalHotkeyMonitor.h"

static NSString * const kGTOStatusItemIconName = @"StatusItemIcon";
static NSString * const kGTOItemsListShowKeyEquivalent = @"G";
static NSString * const kGTOItemsListSearchKeyEquivalent = @"f";
static NSString * const kGTOQuitKeyEquivalent = @"q";

@interface GTOItemsListCoordinator()

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSWindow *window;
@property (strong, nonatomic) GTOItemsListViewController *itemsListViewController;
@property (strong, nonatomic) NSApplication *application;
@property (strong, nonatomic) GTOGlobalHotkeyMonitor *itemsListVisibilityMonitor;

@end

@implementation GTOItemsListCoordinator

- (GTOItemsListViewController *)itemsListViewController {
    if (!_itemsListViewController) {
        _itemsListViewController = [self instantiateItemsListViewController];
    }
    return _itemsListViewController;
}

- (NSWindow *)window {
    if (!_window) {
        _window = [self instantiateWindowWithController:self.itemsListViewController];
    }
    return _window;
}

+ (instancetype)coordinatorWithApplication:(NSApplication *)application {
    return [[self alloc] initWithApplication:application];
}

- (instancetype)initWithApplication:(NSApplication *)application {
    self = [super init];
    if (self) {
        NSStatusItem *statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
        statusItem.button.image = [NSImage imageNamed:kGTOStatusItemIconName];
        
        _statusItem = statusItem;
        _application = application;
        _itemsListVisibilityMonitor = [self instantiateItemsListVisibilityMonitor];
    }
    return self;
}

- (void)start {
    [self toggleWindowVisibility];
}

- (void)toggleWindowVisibility {
    if (self.window.visible) {
        [self.window close];
    } else {
        [self.window makeKeyAndOrderFront:self];
        [self.application activateIgnoringOtherApps:YES];
    }
    [self updateStatusItem];
}

- (void)toggleSearchBarVisibility {
    [self.itemsListViewController toggleSearchBarVisibility];
    [self updateStatusItem];
}

- (void)terminateApp {
    [self.application terminate:self];
}

- (GTOItemsListViewController *)instantiateItemsListViewController {
    GTOItemsListViewController *controller = [GTOItemsListViewController instantiate];
    GTOItemsListModel *model = [GTOItemsListModel withCoreDataStack:[GTOCoreDataStack sharedInstance]
                                                       andWorkspace:NSWorkspace.sharedWorkspace];
    controller.model = model;
    model.view = controller;
    return controller;
}

- (NSWindow *)instantiateWindowWithController:(NSViewController *)controller {
    NSWindow *window = [NSWindow windowWithContentViewController:controller];
  
    [[window standardWindowButton: NSWindowZoomButton] setHidden:YES];
    [[window standardWindowButton: NSWindowMiniaturizeButton] setHidden:YES];
    [[window standardWindowButton: NSWindowCloseButton] setHidden:YES];
    
    window.titlebarAppearsTransparent = YES;
    window.titleVisibility = NSWindowTitleHidden;
    window.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable;
    window.minSize = controller.view.bounds.size;
    window.level = NSStatusWindowLevel;
    
    return window;
}

- (GTOGlobalHotkeyMonitor *)instantiateItemsListVisibilityMonitor {
    GTOGlobalHotkeyMonitor *monitor = [GTOGlobalHotkeyMonitor monitorWithCarbonKey:kVK_ANSI_G modifiers:optionKey + shiftKey];
    __weak typeof(self) weakSelf = self;
    [monitor beginKeyboardListening:^{
        [weakSelf toggleWindowVisibility];
    }];
    return monitor;
}

- (void)updateStatusItem {
    NSMenu *statusItemMenu = [NSMenu new];
    
    BOOL isWindowVisible = [self.window isVisible];
    BOOL isSearchBarVisible = [self.itemsListViewController isSearchBarVisible];
    
    NSMenuItem *windowVisibilityMenuItem = [NSMenuItem new];
    windowVisibilityMenuItem.title = NSLocalizedString(isWindowVisible ? @"itemsList.menu.hideWindow" : @"itemsList.menu.showWindow", nil);
    windowVisibilityMenuItem.target = self;
    windowVisibilityMenuItem.action = @selector(toggleWindowVisibility);
    windowVisibilityMenuItem.keyEquivalent = kGTOItemsListShowKeyEquivalent;
    windowVisibilityMenuItem.keyEquivalentModifierMask = NSEventModifierFlagOption;
    
    [statusItemMenu addItem:windowVisibilityMenuItem];
    
    if (isWindowVisible) {
        NSMenuItem *searchBarVisibilityMenuItem = [NSMenuItem new];
        searchBarVisibilityMenuItem.target = self;
        searchBarVisibilityMenuItem.action = @selector(toggleSearchBarVisibility);
        searchBarVisibilityMenuItem.keyEquivalent = kGTOItemsListSearchKeyEquivalent;
        searchBarVisibilityMenuItem.title = NSLocalizedString(isSearchBarVisible ? @"itemsList.menu.hideSearchBar" : @"itemsList.menu.showSearchBar", nil);
        [statusItemMenu addItem:NSMenuItem.separatorItem];
        [statusItemMenu addItem:searchBarVisibilityMenuItem];
    }
    
    NSMenuItem *terminateMenuItem = [NSMenuItem new];
    terminateMenuItem.title = NSLocalizedString(@"itemsList.menu.quit", nil);
    terminateMenuItem.target = self;
    terminateMenuItem.action = @selector(terminateApp);
    terminateMenuItem.keyEquivalent = kGTOQuitKeyEquivalent;
    
    [statusItemMenu addItem:NSMenuItem.separatorItem];
    [statusItemMenu addItem:terminateMenuItem];
    
    self.statusItem.menu = statusItemMenu;
}

@end
