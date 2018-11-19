//
//  GTOItemsListModel.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTOItemsListModelOutput.h"
#import "GTOItemsListViewOutput.h"

@class GTOCoreDataStack;
@class NSWorkspace;

@interface GTOItemsListModel : NSObject <GTOItemsListViewOutput>

@property (nonatomic, weak) id <GTOItemsListModelOutput> view;

+ (instancetype)withCoreDataStack:(GTOCoreDataStack *)coreDataStack andWorkspace:(NSWorkspace *)workspace;

@end
