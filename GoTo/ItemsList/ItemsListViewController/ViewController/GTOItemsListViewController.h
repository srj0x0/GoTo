//
//  GTOListViewController.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GTOItemsListViewOutput.h"
#import "GTOItemsListModelOutput.h"
#import "GTOItemIconLoader.h"

@interface GTOItemsListViewController : NSViewController <GTOItemsListModelOutput>

@property (strong, nonatomic) id <GTOItemsListViewOutput> model;

+ (instancetype)instantiate;

- (BOOL)isSearchBarVisible;
- (void)toggleSearchBarVisibility;

@end

