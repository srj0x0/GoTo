//
//  GTOItemsFacade.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/13/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTOItemProtocol.h"

@class GTOCoreDataStack;
@class GTOManagedItem;

typedef void(^GTOItemsFacadeDidChangeContent)(NSArray<GTOManagedItem *> *);

@interface GTOItemsFacade : NSObject

+ (instancetype)withCoreDataStack:(GTOCoreDataStack *)coreDataStack;

- (void)insertItems:(NSArray<id <GTOItemProtocol>> *)items;
- (void)removeItemWithOrder:(NSInteger)order;
- (void)setOrder:(NSInteger)destinationOrder forItemAt:(NSInteger)sourceOrder;

- (void)beginChangesObserving:(GTOItemsFacadeDidChangeContent)observer;
- (void)endChangesObserving;

@end
