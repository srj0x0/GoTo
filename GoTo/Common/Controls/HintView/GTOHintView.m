//
//  GTOHintView.m
//  GoTo
//
//  Created by Sergey Dokukin on 11/8/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOHintView.h"

static NSString * const kGTOHintViewNibName = @"GTOHintView";

@interface GTOHintView()

@property (strong) IBOutlet NSTextField *hintTextLabel;
@property (strong) IBOutlet NSView *contentView;

@end

@implementation GTOHintView

- (void)setStringValue:(NSString *)stringValue {
    _stringValue = stringValue;
    _hintTextLabel.stringValue = stringValue;
    [self updateView];
}

- (void)setDashLineColor:(NSColor *)dashLineColor {
    _dashLineColor = dashLineColor;
    [self updateView];
}

- (void)setFont:(NSFont *)font {
    _font = font;
    _hintTextLabel.font = font;
    [self updateView];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self loadFromNib];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.drawDashLine) {
        [self drawDashLineInRect:dirtyRect];
    }
}

- (void)drawDashLineInRect:(NSRect)rect {
    [self.dashLineColor setStroke];
    
    NSRect dashLineRect = NSMakeRect(rect.origin.x + 10.0,
                                     rect.origin.y + 10.0,
                                     rect.size.width - 20.0,
                                     rect.size.height - 20.0);
    
    CGFloat dashPattern[] = {5.0, 5.0};
    NSInteger count = sizeof(dashPattern)/sizeof(dashPattern[0]);
    
    NSBezierPath *dashLinePath = [NSBezierPath bezierPathWithRoundedRect:dashLineRect xRadius:8.0 yRadius:8.0];
    [dashLinePath setLineDash:dashPattern count:count phase:0];
    [dashLinePath setLineWidth:3.0];
    
    [dashLinePath stroke];
}

- (void)updateView {
    [self setNeedsDisplay:YES];
    [self setNeedsLayout:YES];
}

- (void)loadFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [bundle loadNibNamed:kGTOHintViewNibName owner:self topLevelObjects:nil];
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self addSubview:self.contentView];
}

@end
