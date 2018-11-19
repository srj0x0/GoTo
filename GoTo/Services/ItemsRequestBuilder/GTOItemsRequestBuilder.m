//
//  GTOItemsRequestBuilder.m
//  GoTo
//
//  Created by Sergey Dokukin on 11/6/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOItemsRequestBuilder.h"
#import "GTOManagedItem+CoreDataClass.h"

static NSString * const kGTOItemOrderKey = @"order";
static NSString * const kGTOItemOrderInRangePredicateFormat = @"(order >= %ld) AND (order <= %ld)";
static NSString * const kGTOItemOrderGreaterThanPredicateFormat = @"(order >= %ld) AND (order <= %ld)";

@implementation GTOItemsRequestBuilder

+ (NSFetchRequest *)lastItemRequest {
    NSFetchRequest *lastItemRequest = [NSFetchRequest fetchRequestWithEntityName:GTOManagedItem.entity.name];
    lastItemRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kGTOItemOrderKey ascending:NO]];
    lastItemRequest.fetchLimit = 1;
    return lastItemRequest;
}

+ (NSFetchRequest *)orderedObservationRequest {
    NSFetchRequest *observationRequest = [NSFetchRequest fetchRequestWithEntityName:GTOManagedItem.entity.name];
    observationRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:kGTOItemOrderKey ascending:YES]];
    return observationRequest;
}

+ (NSFetchRequest *)orderedByRange:(NSRange)range ascending:(BOOL)ascending {
    NSFetchRequest *orderedRequest = [NSFetchRequest fetchRequestWithEntityName:GTOManagedItem.entity.name];
    orderedRequest.sortDescriptors = [self orderedSortDescriptorsByAscending:ascending];
    orderedRequest.predicate = [NSPredicate predicateWithFormat:kGTOItemOrderInRangePredicateFormat, range.location, range.length];
    return orderedRequest;
}

+ (NSFetchRequest *)orderedAfter:(int64_t)order ascending:(BOOL)ascending {
    NSFetchRequest *orderedRequest = [NSFetchRequest fetchRequestWithEntityName:GTOManagedItem.entity.name];
    orderedRequest.sortDescriptors = [self orderedSortDescriptorsByAscending:ascending];
    orderedRequest.predicate = [NSPredicate predicateWithFormat:kGTOItemOrderGreaterThanPredicateFormat, order];
    
    return orderedRequest;
}

+ (NSArray<NSSortDescriptor *> *)orderedSortDescriptorsByAscending:(BOOL)ascending {
    return @[[NSSortDescriptor sortDescriptorWithKey:kGTOItemOrderKey ascending:ascending]];
}

@end
