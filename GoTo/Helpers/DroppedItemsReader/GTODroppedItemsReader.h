//
//  GTODroppedItemsReader.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/30/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTOItemProtocol.h"

@class NSPasteboard;

@interface GTODroppedItemsReader : NSObject

- (NSArray<id <GTOItemProtocol>> *)readItemsFrom:(NSPasteboard *)pasteboard;

@end
