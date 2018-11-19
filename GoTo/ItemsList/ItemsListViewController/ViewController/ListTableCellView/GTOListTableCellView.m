//
//  GTOListTableCellView.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOListTableCellView.h"

static NSString * const kGTOListTableCellViewNibName = @"GTOListTableCellView";
static NSString * const kGTOListTableCellViewReuseIdentifier = @"GTOListTableCellReuseIdentifier";

@interface GTOListTableCellView()

@property (strong) IBOutlet NSImageView *itemImageView;
@property (strong) IBOutlet NSTextField *itemNameLabel;

@end

@implementation GTOListTableCellView

- (void)setupWithItem:(id<GTOItemProtocol>)item andIconsLoader:(id<GTOItemIconLoader>)loader;
{
    self.itemImageView.image = [loader iconForItemWithURL:item.url];
    self.itemNameLabel.stringValue = [item name] ? [item name] : [item url].path;
    self.toolTip = [[item url].absoluteString stringByRemovingPercentEncoding];
}

+ (NSNib *)nib {
    return [[NSNib alloc] initWithNibNamed:kGTOListTableCellViewNibName bundle:[NSBundle bundleForClass:self]];
}

+ (NSString *)reuseIdentifier {
    return kGTOListTableCellViewReuseIdentifier;
}

@end
