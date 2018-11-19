//
//  GTODraggingDestinationView.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTODraggingDestinationView.h"

@interface GTODraggingDestinationView()

@property (nonatomic, assign, readwrite) BOOL isReceivingDrag;

@end

@implementation GTODraggingDestinationView
{
    struct {
        unsigned int filteringOptionsForDraggingView:1;
        unsigned int didBeginDrag: 1;
        unsigned int didEndDrag:1;
    } delegateResponds;
}

- (NSDictionary<NSPasteboardReadingOptionKey,id> *)filteringOptions {
    return delegateResponds.filteringOptionsForDraggingView ? [self.delegate filteringOptionsForDraggingView:self] : nil;
}

- (void)setDelegate:(id<GTODraggingDestinationDelegate>)delegate {
    if (delegate != self.delegate) {
        delegateResponds.filteringOptionsForDraggingView = [delegate respondsToSelector:@selector(filteringOptionsForDraggingView:)];
        delegateResponds.didBeginDrag = [delegate respondsToSelector:@selector(didEndDrag:)];
        delegateResponds.didEndDrag = [delegate respondsToSelector:@selector(didBeginDrag:)];
        _delegate = delegate;
    }
}

- (BOOL)shouldAllowDrag:(id<NSDraggingInfo>)info {
    return [info.draggingPasteboard canReadObjectForClasses:[self.delegate draggedObjectClassesForDraggingView:self]
                                                    options:[self filteringOptions]];
}

- (void)setIsReceivingDrag:(BOOL)isReceivingDrag {
    _isReceivingDrag = isReceivingDrag;
    if (isReceivingDrag) {
        if (delegateResponds.didBeginDrag) {
            [self.delegate didBeginDrag:self];
        }
    } else {
        if (delegateResponds.didEndDrag) {
            [self.delegate didEndDrag:self];
        }
    }
}

- (void)startDropHandling {
    [self registerForDraggedTypes:[self.delegate draggedTypesForDraggingView:self]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    BOOL isDraggingAllowed = [self shouldAllowDrag:sender];
    self.isReceivingDrag = isDraggingAllowed;
    return isDraggingAllowed ? [self.delegate decidedOperationForDraggingView:self] : NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    self.isReceivingDrag = NO;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return [self shouldAllowDrag:sender];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    self.isReceivingDrag = NO;
    return [self.delegate draggingDestinationView:self didReceiveDataWithPasteboard:sender.draggingPasteboard atPoint:sender.draggingLocation];
}

@end
