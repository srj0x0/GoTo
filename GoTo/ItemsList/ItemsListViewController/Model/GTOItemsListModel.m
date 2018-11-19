//
//  GTOItemsListModel.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOItemsListModel.h"
#import "NSWorkspace+GTOItemIconLoader.h"
#import "GTOCoreDataStack.h"
#import "GTOItemsFacade.h"
#import "GTOManagedItem+CoreDataClass.h"

static NSString * const kGTOItemsListFilteringPredicateFormat = @"(name CONTAINS %@) OR (url.absoluteString CONTAINS %@)";

@interface GTOItemsListModel()

@property (strong, nonatomic) NSWorkspace *workspace;
@property (strong, nonatomic) GTOItemsFacade *itemsFacade;
@property (strong, nonatomic) NSPredicate *filteringPredicate;
@property (strong, nonatomic) NSArray<GTOManagedItem *> *items;
@property (strong, nonatomic) NSArray<GTOManagedItem *> *filteredItems;

@end

@implementation GTOItemsListModel

+ (instancetype)withCoreDataStack:(GTOCoreDataStack *)coreDataStack andWorkspace:(NSWorkspace *)workspace {
    return [[self alloc] initWithCoreDataStack:coreDataStack andWorkspace:workspace];
}

- (instancetype)initWithCoreDataStack:(GTOCoreDataStack *)coreDataStack andWorkspace:(NSWorkspace *)workspace {
    self = [super init];
    if (self) {
        _itemsFacade = [GTOItemsFacade withCoreDataStack:coreDataStack];
        _workspace = workspace;
    }
    return self;
}

- (void)setItems:(NSArray<GTOManagedItem *> *)items {
    _items = items;
    [self filterItemsIfNeeded];
}

#pragma mark GTOItemsListViewOutput protocol implementation

- (void)viewDidBecomeActive:(BOOL)isActive {
    if (isActive) {
        __weak typeof(self) weakSelf = self;
        [self.itemsFacade beginChangesObserving:^(NSArray<GTOManagedItem *> *items) {
            weakSelf.items = items;
        }];
    } else {
        [self.itemsFacade endChangesObserving];
    }
}

- (id <GTOItemIconLoader>)iconLoader {
    return self.workspace;
}

- (void)applyFilter:(nonnull NSString *)filter {
    if (filter.length) {
        self.filteringPredicate = [NSPredicate predicateWithFormat:kGTOItemsListFilteringPredicateFormat, filter, filter];
    } else {
        self.filteringPredicate = nil;
    }
    [self filterItemsIfNeeded];
}

- (BOOL)hasItems {
    return self.items.count > 0;
}

- (id <GTOItemProtocol>)itemForRowAt:(NSInteger)index {
    return self.filteredItems[index];
}

- (NSInteger)numberOfItems {
    return [self.filteredItems count];
}

- (void)removeItemAt:(NSInteger)index {
    [self.itemsFacade removeItemWithOrder:self.filteredItems[index].order];
}

- (void)selectItemAt:(NSInteger)index {
    NSURL *url = self.filteredItems[index].url;
    [self.workspace openURL:url];
}

- (void)setOrder:(NSInteger)sourceIndex forItemAt:(NSInteger)destinationIndex {
    int64_t sourceOrder = self.items[sourceIndex].order;
    int64_t destinationOrder = self.items[destinationIndex].order;
    
    [self.itemsFacade setOrder:sourceOrder forItemAt:destinationOrder];
}

- (void)saveItems:(NSArray<GTOItemProtocol> *)items {
    [self.itemsFacade insertItems:items];
}

- (void)filterItemsIfNeeded {
    self.filteredItems = self.filteringPredicate ? [self.items filteredArrayUsingPredicate:self.filteringPredicate] : self.items;
    [self.view contentChanged];
}

@end
