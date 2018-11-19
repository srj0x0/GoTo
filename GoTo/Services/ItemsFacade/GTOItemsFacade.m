//
//  GTOItemsFacade.m
//  GoTo
//
//  Created by Sergey Dokukin on 11/13/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOItemsFacade.h"
#import "GTOManagedItem+CoreDataClass.h"
#import "GTOCoreDataStack.h"
#import "GTOItemsRequestBuilder.h"

@interface GTOItemsFacade() <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) GTOCoreDataStack *coreDataStack;
@property (strong, nonatomic) NSFetchedResultsController *itemsController;
@property (strong, nonatomic) GTOItemsFacadeDidChangeContent observer;

@end

@implementation GTOItemsFacade

+ (instancetype)withCoreDataStack:(GTOCoreDataStack *)coreDataStack {
    return [[self alloc] initWithCoreDataStack:coreDataStack];
}

- (instancetype)initWithCoreDataStack:(GTOCoreDataStack *)coreDataStack {
    self = [super init];
    if (self) {
        _coreDataStack = coreDataStack;
    }
    return self;
}

- (void)beginChangesObserving:(GTOItemsFacadeDidChangeContent)observer {
    NSManagedObjectContext *viewContext = self.coreDataStack.viewContext;
    NSFetchRequest *itemsObservingRequest = GTOItemsRequestBuilder.orderedObservationRequest;
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:itemsObservingRequest
                                                                                 managedObjectContext:viewContext
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    controller.delegate = self;
    [controller performFetch:nil];
    observer(controller.fetchedObjects);
    
    self.itemsController = controller;
    self.observer = observer;
}

- (void)endChangesObserving {
    self.itemsController = nil;
    self.observer = nil;
}

- (void)insertItems:(NSArray<id <GTOItemProtocol>> *)items {
    [self.coreDataStack performTransaction:^(NSManagedObjectContext *context) {
        NSFetchRequest *lastItemRequest = [GTOItemsRequestBuilder lastItemRequest];
        GTOManagedItem *lastItem = [context executeFetchRequest:lastItemRequest error:nil].firstObject;
        int64_t offset = (lastItem == nil) ? 0 : lastItem.order + 1;
        
        [items enumerateObjectsUsingBlock:^(id<GTOItemProtocol> item, NSUInteger index, BOOL *stop) {
            GTOManagedItem *insertedItem = [[GTOManagedItem alloc] initWithContext:context];
            insertedItem.url = [item url];
            insertedItem.name = [item name];
            insertedItem.order = offset + index;
        }];
    }];
}

- (void)removeItemWithOrder:(NSInteger)order {
    [self.coreDataStack performTransaction:^(NSManagedObjectContext *context) {
        NSFetchRequest *updatableItemsRequest = [GTOItemsRequestBuilder orderedAfter:order ascending:YES];
        NSArray<GTOManagedItem *> *updatableItems = [context executeFetchRequest:updatableItemsRequest error:nil];
        for (GTOManagedItem *updatableItem in updatableItems) {
            if (updatableItem.order == order) {
                [context deleteObject:updatableItem];
            } else {
                updatableItem.order -= 1;
            }
        }
    }];
}

- (void)setOrder:(NSInteger)destinationOrder forItemAt:(NSInteger)sourceOrder {
    if (sourceOrder == destinationOrder) {
        return;
    }
    
    NSInteger lowerBound = MIN(sourceOrder, destinationOrder);
    NSInteger upperBound = MAX(sourceOrder, destinationOrder);
    
    BOOL isMovedUp = destinationOrder < sourceOrder;
    
    [self.coreDataStack performTransaction:^(NSManagedObjectContext *context) {
        NSFetchRequest *updatableItemsRequest = [GTOItemsRequestBuilder orderedByRange:NSMakeRange(lowerBound, upperBound) ascending:YES];
        NSArray<GTOManagedItem *> *updatableItems = [context executeFetchRequest:updatableItemsRequest error:nil];
        for (GTOManagedItem *updatableItem in updatableItems) {
            if (updatableItem.order == sourceOrder) {
                updatableItem.order = destinationOrder;
            } else {
                updatableItem.order += isMovedUp ? 1 : -1;
            }
        }
    }];
}

#pragma mark NSFetchedResultsControllerDelegate protocol implementation

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.observer(controller.fetchedObjects);
}

@end
