//
//  GTOCoreDataStack.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOCoreDataStack.h"

static NSString * const kGTOPersitentContainerName = @"GoTo";

@interface GTOCoreDataStack()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

@implementation GTOCoreDataStack

+ (instancetype)sharedInstance {
    static GTOCoreDataStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mergeChangesWithNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}

- (NSManagedObjectContext *)viewContext {
    return self.persistentContainer.viewContext;
}

- (NSPersistentContainer*)persistentContainer {
    @synchronized (self) {
        if (!_persistentContainer) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:kGTOPersitentContainerName];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

- (void)mergeChangesWithNotification:(NSNotification *)notification {
    [self.viewContext mergeChangesFromContextDidSaveNotification:notification];
}

- (void)performTransaction:(GTOCoreDataStackTransaction)transaction {
    [self.persistentContainer performBackgroundTask:^(NSManagedObjectContext *context) {
        transaction(context);
        if (context.hasChanges) {
            [context save:nil];
        }
    }];
}

@end
