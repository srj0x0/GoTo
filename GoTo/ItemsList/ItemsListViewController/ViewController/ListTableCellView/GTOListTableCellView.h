//
//  GTOListTableCellView.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GTOItemProtocol.h"
#import "GTOItemIconLoader.h"
#import "GTONibReusableView.h"

@interface GTOListTableCellView : NSTableCellView <GTONibReusableView>

- (void)setupWithItem:(id <GTOItemProtocol>)item andIconsLoader:(id <GTOItemIconLoader>)loader;

@end
