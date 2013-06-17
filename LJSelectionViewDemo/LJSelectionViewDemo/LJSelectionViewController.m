//
//  LJSelectionViewController.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#if __has_feature(objc_arc)
    #define SAFE_ARC_AUTORELEASE(__X__) (__X__)
    #define SAFE_ARC_SUPER_DEALLOC()
#else
    #define SAFE_ARC_AUTORELEASE(__X__) ([(__X__) autorelease])
    #define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#endif

#import "LJSelectionViewController.h"

@interface LJSelectionViewController ()

- (void)addViewsToSelection:(NSSet *)views append:(BOOL)append;
- (void)clearSelection;
- (void)pruneSelectionIfNecesary;
- (NSView *)viewForPoint:(NSPoint)point;
- (NSSet *)viewsInRect:(NSRect)rect;
- (NSRect)rectForPoint:(NSPoint)p1 andPoint:(NSPoint)p2;

@end

@implementation LJSelectionViewController

- (void)dealloc;
{
    self.selectionView = nil;
    self.selectedItems = nil;
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)init;
{
    self = [super init];
    if (self) {
        _selectionBehavior = kSelectionBehaviorPartial;
        _dragType = kDragTypeNone;
        _selectionRect = NSZeroRect;
    }
    return self;
}

#pragma mark - Selection management

- (void)addViewsToSelection:(NSSet *)views append:(BOOL)append;
{
    /* 
     * The selection behavior here is the same as Adobe Illustrator.
     * If we are not appending, the passed in selection always replaces the current selection.
     * If we are appending, the passed in selection *toggles* against the current selection,
     * i.e., if we click (or draw a selection over) a currently selected item, that item is removed
     * from the current selection and vice versa.
     */
    if (![_selectedItems isEqualToSet:views]) {
        [[_undoManager prepareWithInvocationTarget:self] setSelectedItems:_selectedItems];
    }
    if (append) {
        [_undoManager setActionName:NSLocalizedString(@"Add To Selection", @"")];
        if (!_selectedItems) {
            self.selectedItems = [NSSet set];
        }
        NSMutableSet* selection = SAFE_ARC_AUTORELEASE([_selectedItems mutableCopy]);
        NSMutableSet* intersect = SAFE_ARC_AUTORELEASE([_selectedItems mutableCopy]);
        [intersect intersectSet:views];
        [selection unionSet:views];
        [selection minusSet:intersect];
        self.selectedItems = SAFE_ARC_AUTORELEASE([selection copy]);
    }
    else {
        [_undoManager setActionName:NSLocalizedString(@"Select", @"")];
        self.selectedItems = SAFE_ARC_AUTORELEASE([views copy]);
    }
}

- (void)clearSelection;
{
    if (_selectedItems && [_selectedItems count] > 0) {
        [[_undoManager prepareWithInvocationTarget:self] setSelectedItems:_selectedItems];
        [_undoManager setActionName:NSLocalizedString(@"Clear Selection", @"")];
    }
    self.selectedItems = nil;
}

- (void)pruneSelectionIfNecesary;
{
    NSMutableSet* intersection = SAFE_ARC_AUTORELEASE([_selectedItems mutableCopy]);
    NSSet* views = [NSSet setWithArray:[_selectionView selectableSubviews]];
    [intersection intersectSet:views];
    self.selectedItems = SAFE_ARC_AUTORELEASE([intersection copy]);
}

#pragma mark - LJSelectionViewDelegate

- (void)selectionView:(LJSelectionView *)aSelectionView didSingleClickAtPoint:(NSPoint)point flags:(NSUInteger)flags;
{
    NSView* view = [self viewForPoint:point];
    NSSet* selection = view ? [NSSet setWithObject:view] : [NSSet set];
    [self addViewsToSelection:selection append:flags & NSShiftKeyMask ? YES : NO];
    [_selectionView setNeedsDisplay:YES];
}

- (void)selectionView:(LJSelectionView *)aSelectionView didDoubleClickatPoint:(NSPoint)point flags:(NSUInteger)flags;
{
    /* 
     * Optional protocol method to handle double click in the view
     * Note: the message selectionView:didSingleClickAtPoint:flags: will also be sent before this message is.
     * The selectionView:didSingleClickAtPoint:flags: message will be sent two times: Once for each click of the double click.
     */
}

- (BOOL)selectionView:(LJSelectionView *)aSelectionView shouldDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;
{
    if (_dragType == kDragTypeNone) {
        
        // If you want other drag options besides selection in your view, you can select drag types here.
        _dragType = kDragTypeSelect;
    }
    
    switch (_dragType) {
        case kDragTypeSelect:
            _selectionRect = [self rectForPoint:p1 andPoint:p2];
            break;
        default:
            break;
    }
    
    [_selectionView setNeedsDisplay:YES];
    
    // Returning NO in this method prevents the drag from continuing.
    return YES;
}

- (void)selectionView:(LJSelectionView *)aSelectionView didFinishDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;
{
    if (_dragType == kDragTypeSelect) {
        NSSet* selection = [self viewsInRect:[self rectForPoint:p1 andPoint:p2]];
        [self addViewsToSelection:selection append:flags & NSShiftKeyMask ? YES : NO];
        _selectionRect = NSZeroRect;
    }
    _dragType = kDragTypeNone;
    [_selectionView setNeedsDisplay:YES];
}

- (void)selectionViewDidUpdateSubviews;
{
    [self pruneSelectionIfNecesary];
    [_selectionView setNeedsDisplay:YES];
}

- (NSRect)selectionViewRectForSelection;
{
    return _selectionRect;
}

- (NSSet *)selectionViewSelectedItems;
{
    return _selectedItems;
}

#pragma mark - Private methods

- (NSView *)viewForPoint:(NSPoint)point;
{
    for (NSView* view in [[_selectionView selectableSubviews] reverseObjectEnumerator]) {
        if (NSPointInRect(point, [view frame])) {
            return view;
        }
    }
    return nil;
}

- (NSSet *)viewsInRect:(NSRect)rect;
{
    /*
     * If we've set kSelectionBehaviorPartial a view will be selected if any of it is under the selection rect.
     * If we've set kSelectionBehaviorFull a view will be selected if all of it is under the selection rect.
     */
    NSSet* views = [NSSet set];
    for (NSView* view in [_selectionView selectableSubviews]) {
        if ( (_selectionBehavior == kSelectionBehaviorPartial   && NSIntersectsRect(rect, view.frame)) ||
             (_selectionBehavior == kSelectionBehaviorFull      && NSContainsRect(rect, view.frame))) {
            views = [views setByAddingObject:view];
        }
    }
    return views;
}

- (NSRect)rectForPoint:(NSPoint)p1 andPoint:(NSPoint)p2;
{
    NSPoint origin;
    NSPoint otherPoint;
    origin.x        = MIN(p1.x, p2.x);
    origin.y        = MIN(p1.y, p2.y);
    otherPoint.x    = MAX(p1.x, p2.x);
    otherPoint.y    = MAX(p1.y, p2.y);
    return NSMakeRect(origin.x, origin.y, otherPoint.x-origin.x, otherPoint.y-origin.y);
}

@end
