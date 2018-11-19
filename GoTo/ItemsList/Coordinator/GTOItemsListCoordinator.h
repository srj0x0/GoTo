//
//  GTOItemsListCoordinator.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/30/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTOItemsListCoordinator : NSObject

+ (instancetype)coordinatorWithApplication:(NSApplication *)application;

- (void)start;

@end
