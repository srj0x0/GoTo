//
//  GTOItemsRequestBuilder.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/6/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GTOItemsRequestBuilder : NSObject

+ (NSFetchRequest *)orderedObservationRequest;
+ (NSFetchRequest *)lastItemRequest;
+ (NSFetchRequest *)orderedByRange:(NSRange)range ascending:(BOOL)ascending;
+ (NSFetchRequest *)orderedAfter:(int64_t)order ascending:(BOOL)ascending;

@end
