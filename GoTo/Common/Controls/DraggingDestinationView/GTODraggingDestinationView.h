//
//  GTODraggingDestinationView.h
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GTODraggingDestinationView;

@protocol GTODraggingDestinationDelegate <NSObject>

@required
- (NSArray<NSPasteboardType> *)draggedTypesForDraggingView:(GTODraggingDestinationView *)draggingDestinationView;
- (NSArray<Class> *)draggedObjectClassesForDraggingView:(GTODraggingDestinationView *)draggingDestinationView;
- (NSDragOperation)decidedOperationForDraggingView:(GTODraggingDestinationView *)draggingDestinationView;

- (BOOL)draggingDestinationView:(GTODraggingDestinationView *)draggingDestinationView didReceiveDataWithPasteboard:(NSPasteboard*)pasteboard atPoint:(NSPoint)point;

@optional
- (NSDictionary<NSPasteboardReadingOptionKey,id> *)filteringOptionsForDraggingView:(GTODraggingDestinationView *)draggingDestinationView;
- (void)didBeginDrag:(GTODraggingDestinationView *)draggingDestinationView;
- (void)didEndDrag:(GTODraggingDestinationView *)draggingDestinationView;

@end

@interface GTODraggingDestinationView : NSView

@property (assign, nonatomic, readonly) BOOL isReceivingDrag;
@property (weak, nonatomic) id <GTODraggingDestinationDelegate> delegate;

- (void)startDropHandling;

@end
