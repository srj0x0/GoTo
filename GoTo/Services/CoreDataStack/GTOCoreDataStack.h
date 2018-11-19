//
//  GTOCoreDataStack.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^GTOCoreDataStackTransaction)(NSManagedObjectContext *context);

@interface GTOCoreDataStack : NSObject

@property (readonly, strong) NSManagedObjectContext *viewContext;

+ (instancetype)sharedInstance;

- (void)performTransaction:(GTOCoreDataStackTransaction)transaction;

@end
