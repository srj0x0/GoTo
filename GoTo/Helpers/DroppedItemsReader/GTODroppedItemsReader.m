//
//  GTODroppedItemsReader.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/30/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTODroppedItemsReader.h"
#import "GTODroppedItem.h"
#import <Cocoa/Cocoa.h>

static NSString * const kUTTypeURLName = @"public.url-name";

@implementation GTODroppedItemsReader

- (NSArray<id <GTOItemProtocol>> *)readItemsFrom:(NSPasteboard *)pasteboard {
    NSArray<NSPasteboardType> *urlTypes = @[(__bridge NSString*)kUTTypeURL];
    NSMutableArray<GTODroppedItem *> *readedItems = [NSMutableArray array];
    
    for (NSPasteboardItem *item in pasteboard.pasteboardItems) {
        NSString *urlString = [item stringForType:[item availableTypeFromArray:urlTypes]];
        NSURL *itemURL = [[NSURL URLWithString:urlString] URLByStandardizingPath];
        if (itemURL) {
            NSString *itemName = itemURL.isFileURL ? itemURL.URLByDeletingPathExtension.lastPathComponent : [item stringForType:kUTTypeURLName];
            GTODroppedItem *data = [GTODroppedItem itemWithURL:itemURL name:itemName];
            [readedItems addObject:data];
        }
    }
    return readedItems;
}

@end
