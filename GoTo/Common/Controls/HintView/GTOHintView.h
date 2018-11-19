//
//  GTOHintView.h
//  GoTo
//
//  Created by Sergey Dokukin on 11/8/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GTOColoredView.h"

@interface GTOHintView : GTOColoredView

@property (copy, nonatomic) IBInspectable NSString *stringValue;
@property (strong, nonatomic) IBInspectable NSColor *dashLineColor;
@property (assign, nonatomic) IBInspectable BOOL drawDashLine;

@property (strong, nonatomic) NSFont *font;

@end
