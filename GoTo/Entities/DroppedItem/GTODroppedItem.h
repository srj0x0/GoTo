//
//  GTODroppedItem.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/30/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTOItemProtocol.h"

@interface GTODroppedItem : NSObject <GTOItemProtocol>

+ (instancetype)itemWithURL:(NSURL *)url name:(NSString * _Nullable)name;

@end
