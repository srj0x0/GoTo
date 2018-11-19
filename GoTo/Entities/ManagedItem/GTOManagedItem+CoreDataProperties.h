//
//  GTOManagedItem+CoreDataProperties.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/5/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//
//

#import "GTOManagedItem+CoreDataClass.h"
#import "GTOItemProtocol.h"

@interface GTOManagedItem (CoreDataProperties) <GTOItemProtocol>

@property (nonatomic) int64_t order;
@property (nonnull, nonatomic, copy) NSURL *url;
@property (nullable, nonatomic, copy) NSString *name;

@end
