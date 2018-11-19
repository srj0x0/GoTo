//
//  GTOListViewController.m
//  GoTo
//
//  Created by Sergey Dokukin on 10/28/18.
//  Copyright © 2018 Sergey Dokukin. All rights reserved.
//

#import "GTOItemsListViewController.h"
#import "GTOListTableCellView.h"
#import "GTODraggingDestinationView.h"
#import "GTODroppedItemsReader.h"
#import "GTOHintView.h"
#import "GTOLocalHotkeyMonitor.h"

static NSString * const kGTOItemsListRowDraggedType = @"private.GTOListViewController.tableView.row";
static NSString * const kGTOItemsListStoryboardName = @"ItemsList";
static NSString * const kGTOItemsListViewControllerIdentifier = @"GTOItemsListViewController";

static const CGFloat kGTOItemsListTableViewRowHeight = 33.0;
static const CGFloat kGTOItemsListSearchBarCollapsedVisibleHeight = 20.0;

static const NSTimeInterval kGTOItemsListFilterApplyingDelay = 0.25;

#pragma mark GTOItemsListViewController extension

@interface GTOItemsListViewController()

@property (strong, nonatomic) IBOutlet GTODraggingDestinationView *draggingDestinationView;
@property (strong, nonatomic) IBOutlet GTOColoredView *searchBarContainerView;
@property (strong, nonatomic) IBOutlet NSSearchField *searchField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBarContainerTopConstraint;
@property (strong, nonatomic) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) IBOutlet GTOHintView *emptyStateView;
@property (strong, nonatomic) IBOutlet GTOHintView *dropHintView;

@property (strong, nonatomic) GTOLocalHotkeyMonitor *searchBarVisibilityMonitor;

@end

#pragma mark GTOItemsListViewController(TableViewManagment) declaration extension

@interface GTOItemsListViewController(TableViewManagment) <NSTableViewDataSource, NSTableViewDelegate>

- (void)setupTableView:(NSTableView *)tableView;
- (void)setupEmptyStateView:(GTOHintView *)emptyStateView;

@end

#pragma mark GTOItemsListViewController(DroppedDataHandling) declaration extension

@interface GTOItemsListViewController(DroppedDataHandling) <GTODraggingDestinationDelegate>

- (void)setupDraggingDestinationView:(GTODraggingDestinationView *)draggingDestinationView;
- (void)setupDropHintView:(GTOHintView *)dropHintView;

@end

#pragma mark GTOItemsListViewController(SearchFieldManagment) declaration extension

@interface GTOItemsListViewController(SearchFieldManagment) <NSSearchFieldDelegate>

- (void)setupSearchField:(NSSearchField *)searchField;

@end

#pragma mark GTOItemsListViewController implementation

@implementation GTOItemsListViewController

+ (instancetype)instantiate {
    NSStoryboard *itemsListStoryboard = [NSStoryboard storyboardWithName:kGTOItemsListStoryboardName bundle:[NSBundle bundleForClass:self]];
    return [itemsListStoryboard instantiateControllerWithIdentifier:kGTOItemsListViewControllerIdentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchField:self.searchField];
    [self setupTableView:self.tableView];
    [self setupEmptyStateView:self.emptyStateView];
    [self setupDraggingDestinationView:self.draggingDestinationView];
    [self setupDropHintView:self.dropHintView];
    
    self.searchBarVisibilityMonitor = [GTOLocalHotkeyMonitor monitorWithCarbonKey:kVK_ANSI_F modifiers:NSEventModifierFlagCommand];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self.model viewDidBecomeActive:YES];
    
    __weak typeof(self) weakSelf = self;
    [self.searchBarVisibilityMonitor beginKeyboardListening:^{
        [weakSelf toggleSearchBarVisibility];
    }];
}

- (void)viewDidDisappear {
    [super viewDidDisappear];
    
    [self.model viewDidBecomeActive:NO];
    [self.searchBarVisibilityMonitor endKeyboardListening];
}

- (void)contentChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.dropHintView.hidden = [self.model hasItems];
        self.emptyStateView.hidden = [self.model numberOfItems] > 0;
    });
}

- (BOOL)isSearchBarVisible {
    return self.searchBarContainerTopConstraint.constant == 0;
}

- (void)toggleSearchBarVisibility {
    BOOL isExpanded = [self isSearchBarVisible];
    CGFloat constant = isExpanded ? kGTOItemsListSearchBarCollapsedVisibleHeight - self.searchBarContainerView.frame.size.height : 0;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.25;
        context.allowsImplicitAnimation = YES;
        self.searchBarContainerTopConstraint.constant = constant;
        [self.view layoutSubtreeIfNeeded];
    } completionHandler:^{
        self.searchField.enabled = !isExpanded;
        
        if (!isExpanded && [self.model hasItems]) {
            [self.searchField becomeFirstResponder];
        }
    }];
}

@end

#pragma mark GTOItemsListViewController(TableViewManagment) implementation

@implementation GTOItemsListViewController(TableViewManagment)

- (void)setupTableView:(NSTableView *)tableView {
    [tableView registerForDraggedTypes:@[kGTOItemsListRowDraggedType]];
    [tableView registerNib:GTOListTableCellView.nib forIdentifier:GTOListTableCellView.reuseIdentifier];
    tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyleGap;
    tableView.rowHeight = kGTOItemsListTableViewRowHeight;
    tableView.allowsEmptySelection = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)setupEmptyStateView:(GTOHintView *)emptyStateView {
    emptyStateView.stringValue = NSLocalizedString(@"itemsList.controller.emptySearchingResult", nil);
    emptyStateView.font = [NSFont systemFontOfSize:18.0];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.model numberOfItems];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return kGTOItemsListTableViewRowHeight;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    GTOListTableCellView *view = [tableView makeViewWithIdentifier:GTOListTableCellView.reuseIdentifier owner:tableView];
    [view setupWithItem:[self.model itemForRowAt:row] andIconsLoader:[self.model iconLoader]];
    return view;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView {
    return tableView.clickedRow >= 0 || tableView.clickedRow == -1;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tableView = notification.object;
    
    if (tableView.selectedRow >= 0) {
        [self.model selectItemAt:tableView.selectedRow];
        [tableView deselectAll:self];
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return dropOperation == NSTableViewDropAbove ? NSDragOperationMove : NSDragOperationNone;
}

- (id<NSPasteboardWriting>)tableView:(NSTableView *)tableView pasteboardWriterForRow:(NSInteger)row {
    NSPasteboardItem *item = [NSPasteboardItem new];
    [item setString:[NSString stringWithFormat:@"%ld", row] forType:kGTOItemsListRowDraggedType];
    return item;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pasteboard = [info draggingPasteboard];
    NSString *sourceRowString = [pasteboard stringForType:kGTOItemsListRowDraggedType];
    
    if (sourceRowString) {
        NSInteger source = [sourceRowString integerValue];
        NSInteger destination = (source < row) ? row - 1 : row;
        [tableView moveRowAtIndex:source toIndex:destination];
        [self.model setOrder:destination forItemAt:source];
        return YES;
    }
    return NO;
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {
    session.animatesToStartingPositionsOnCancelOrFail = NO;
}

- (void)tableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (operation == NSDragOperationNone && !NSPointInRect(screenPoint, tableView.window.frame)) {
        NSPasteboard *pasteboard = [session draggingPasteboard];
        NSString *rowString = [pasteboard stringForType:kGTOItemsListRowDraggedType];
        
        if (rowString) {
            NSInteger row = rowString.integerValue;
            [self.model removeItemAt:row];
            NSShowAnimationEffect(NSAnimationEffectPoof, screenPoint, NSZeroSize, nil, nil, nil);
        }
    }
}

@end

#pragma mark GTOItemsListViewController(DroppedDataHandling) implementation

@implementation GTOItemsListViewController(DroppedDataHandling)

- (void)setupDraggingDestinationView:(GTODraggingDestinationView *)draggingDestinationView {
    draggingDestinationView.delegate = self;
    [draggingDestinationView startDropHandling];
}

- (void)setupDropHintView:(GTOHintView *)dropHintView {
    dropHintView.stringValue = NSLocalizedString(@"itemsList.controller.dropHintText", @"");
    dropHintView.font = [NSFont systemFontOfSize:18.0];
}

- (NSArray<NSPasteboardType> *)draggedTypesForDraggingView:(GTODraggingDestinationView *)draggingDestinationView {
    return @[NSPasteboardTypeURL];
}

- (NSArray<Class> *)draggedObjectClassesForDraggingView:(GTODraggingDestinationView *)draggingDestinationView {
    return @[NSURL.class];
}

- (NSDragOperation)decidedOperationForDraggingView:(GTODraggingDestinationView *)draggingDestinationView {
    return NSDragOperationCopy;
}

- (BOOL)draggingDestinationView:(GTODraggingDestinationView *)draggingDestinationView didReceiveDataWithPasteboard:(NSPasteboard*)pasteboard atPoint:(NSPoint)point {
    GTODroppedItemsReader *reader = [GTODroppedItemsReader new];
    NSArray<id <GTOItemProtocol>> *droppedItems = [reader readItemsFrom:pasteboard];
    if (droppedItems.count > 0) {
        [self.model saveItems:droppedItems];
        return YES;
    }
    return NO;
}

- (void)didBeginDrag:(GTODraggingDestinationView *)draggingDestinationView {
    self.dropHintView.hidden = NO;
}

- (void)didEndDrag:(GTODraggingDestinationView *)draggingDestinationView {
    self.dropHintView.hidden = [self.model hasItems];
}

@end

#pragma mark GTOItemsListViewController(SearchFieldManagment) implementation

@implementation GTOItemsListViewController(SearchFieldManagment)

- (void)setupSearchField:(NSSearchField *)searchField {
    searchField.placeholderString = NSLocalizedString(@"itemsList.controller.searchPlaceholder", @"");
    searchField.focusRingType = NSFocusRingTypeExterior;
    searchField.delegate = self;
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    [self applySearch];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(applySearch) object:nil];
    [self performSelector:@selector(applySearch) withObject:nil afterDelay:kGTOItemsListFilterApplyingDelay];
}

- (void)applySearch {
    [self.model applyFilter:self.searchField.stringValue];
}

@end
