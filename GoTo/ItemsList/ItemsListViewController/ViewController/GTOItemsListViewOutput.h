//
//  GTOListViewControllerModel.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/5/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTOItemIconLoader.h"
#import "GTOItemProtocol.h"

@protocol GTOItemsListViewOutput <NSObject>

- (void)viewDidBecomeActive:(BOOL)isActive;

- (id <GTOItemIconLoader>)iconLoader;

- (BOOL)hasItems;
- (NSInteger)numberOfItems;
- (id <GTOItemProtocol>)itemForRowAt:(NSInteger)index;

- (void)saveItems:(NSArray<id <GTOItemProtocol>> *)items;
- (void)applyFilter:(NSString *)filter;
- (void)selectItemAt:(NSInteger)index;
- (void)setOrder:(NSInteger)destinationIndex forItemAt:(NSInteger)sourceIndex;
- (void)removeItemAt:(NSInteger)index;

@end
