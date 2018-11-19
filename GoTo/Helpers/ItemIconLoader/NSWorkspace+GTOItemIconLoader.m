//
//  NSWorkspace+Extra.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/29/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "NSWorkspace+GTOItemIconLoader.h"

@implementation NSWorkspace (IconLoader)

- (NSImage *)iconForItemWithURL:(NSURL *)url {
    NSURL *applicationURL = [self URLForApplicationToOpenURL:url];
    return applicationURL ? [self iconForFile:applicationURL.path] : [self iconForFile:url.path];
}

@end
