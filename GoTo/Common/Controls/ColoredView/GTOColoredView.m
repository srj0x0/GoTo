//
//  GTOColoredView.m
//  GoTo
//
//  Created by Sergey Dokukin on 11/8/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOColoredView.h"

@implementation GTOColoredView

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self.backgroundColor setFill];
    NSRectFill(dirtyRect);
}

- (BOOL)allowsVibrancy {
    return YES;
}

@end
