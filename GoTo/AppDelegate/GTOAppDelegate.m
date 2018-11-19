//
//  GTOAppDelegate.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOAppDelegate.h"
#import "GTOItemsListCoordinator.h"

@interface GTOAppDelegate()

@property (strong, nonatomic) GTOItemsListCoordinator *listViewCoordinator;

@end

@implementation GTOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSApplication *application = aNotification.object;
    self.listViewCoordinator = [GTOItemsListCoordinator coordinatorWithApplication:application];
    [self.listViewCoordinator start];
}

@end
