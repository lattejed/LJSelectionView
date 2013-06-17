//
//  LJSelectionView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionView.h"
#import "LJSelectionItemView.h"
#import "LJSelectionRectView.h"

#if __has_feature(objc_arc)
    #define SAFE_ARC_AUTORELEASE(__X__) (__X__)
    #define SAFE_ARC_SUPER_DEALLOC()
#else
    #define SAFE_ARC_AUTORELEASE(__X__) ([(__X__) autorelease])
    #define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#endif

static NSString* const kSubviewsKeypath = @"subviews";

@interface LJSelectionView ()

- (void)drawSelectionRect;
- (void)drawItemHighlights;
- (void)removeHighlightViews;
- (NSArray *)highlightViews;

@end

@implementation LJSelectionView

- (void)dealloc;
{
    [self removeObserver:self forKeyPath:kSubviewsKeypath];
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [super initWithFrame:frameRect]) {
        _canDragOutsideBounds = YES;
        _drawsItemHighlights = YES;
        [self addObserver:self forKeyPath:kSubviewsKeypath options:0 context:NULL];
    }
    return self;
}

- (void)awakeFromNib;
{
    [super awakeFromNib];
    if (_selectionRectView) {
        [_selectionRectView setFrame:NSZeroRect];
    }
}

- (void)drawRect:(NSRect)dirtyRect;
{
    [super drawRect:dirtyRect];
    [self removeHighlightViews];
    [self drawItemHighlights];
    [self drawSelectionRect];
}

#pragma mark - Subview and selection handling

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if ([keyPath isEqual:@"subviews"]) {
        [_delegate selectionViewDidUpdateSubviews];
    }
}

- (void)drawSelectionRect;
{
    NSRect rect = [_delegate selectionViewRectForSelection];
    [_selectionRectView setFrame:rect];
}

- (void)drawItemHighlights;
{
    if (_drawsItemHighlights && [_delegate respondsToSelector:@selector(selectionViewSelectedItems)]) {
        NSSet* selectedItems = [_delegate selectionViewSelectedItems];
        for (NSView* item in selectedItems) {
            LJSelectionItemView* selectionItemView = SAFE_ARC_AUTORELEASE([_selectionItemViewPrototype copy]);
            [selectionItemView setFrame:item.frame];
            [super addSubview:selectionItemView positioned:NSWindowAbove relativeTo:item];
        }
    }
}

- (void)addSelectableSubview:(NSView *)aView;
{
    if (!_selectionRectView) {
        NSString* res = @"An instance of LJSelectionRectView needs to be added to LJSelectionView before other subviews are added.";
        NSException* exception = [NSException exceptionWithName:@"NoSelectionRectViewException"
                                                         reason:res
                                                       userInfo:nil];
        @throw exception;
    }
    [super addSubview:aView positioned:NSWindowBelow relativeTo:(NSView *)_selectionRectView];
}

- (void)addSelectionRectView:(LJSelectionRectView *)aView;
{
    if ([[self subviews] containsObject:_selectionRectView]) {
        [_selectionRectView removeFromSuperview];
    }
    [super addSubview:(NSView *)_selectionRectView positioned:NSWindowAbove relativeTo:nil];
    self.selectionRectView = (LJSelectionRectView *)aView;
    [_selectionRectView setFrame:NSZeroRect];
}

- (NSArray *)selectableSubviews;
{
    NSMutableArray* array = SAFE_ARC_AUTORELEASE([_subviews mutableCopy]);
    for (NSView* view in _subviews) {
        if ([view isMemberOfClass:[LJSelectionItemView class]] ||
            [view isMemberOfClass:[LJSelectionRectView class]]) {
            [array removeObject:view];
        }
    }
    return SAFE_ARC_AUTORELEASE([array copy]);
}

- (NSArray *)highlightViews;
{
    NSMutableArray* array = SAFE_ARC_AUTORELEASE([_subviews mutableCopy]);
    for (NSView* view in _subviews) {
        if (![view isMemberOfClass:[LJSelectionItemView class]]) {
            [array removeObject:view];
        }
    }
    return SAFE_ARC_AUTORELEASE([array copy]);
}

- (void)removeHighlightViews;
{
    NSMutableArray* array = SAFE_ARC_AUTORELEASE([_subviews mutableCopy]);
    [array removeObjectsInArray:[self highlightViews]];
    self.subviews = SAFE_ARC_AUTORELEASE([array copy]);
}

#pragma mark - Mouse events

- (void)mouseUp:(NSEvent *)theEvent;
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [_delegate selectionView:self didSingleClickAtPoint:point flags:[theEvent modifierFlags]];
    if([theEvent clickCount] == 2) {
        if ([_delegate respondsToSelector:@selector(selectionView:didDoubleClickatPoint:flags:)]) {
            [_delegate selectionView:self didDoubleClickatPoint:point flags:[theEvent modifierFlags]];
        }
    }
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
    NSPoint mouseStart = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint mouseCurrentLoc = mouseStart;
    NSPoint mouseLastLoc = mouseStart;
    NSPoint delta = NSZeroPoint;
    
    while (YES) {
        mouseCurrentLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        delta = NSMakePoint((mouseCurrentLoc.x-mouseLastLoc.x), (mouseCurrentLoc.y-mouseLastLoc.y));
        mouseLastLoc = mouseCurrentLoc;
        if ([theEvent type] == NSLeftMouseUp) {
            [_delegate selectionView:self didFinishDragFromPoint:mouseStart toPoint:mouseCurrentLoc delta:delta flags:[theEvent modifierFlags]];
            break;
        }
        else {
            if (!_canDragOutsideBounds && ![self mouse:mouseCurrentLoc inRect:[self bounds]]) {
                continue;
            }
            if (![_delegate selectionView:self shouldDragFromPoint:mouseStart toPoint:mouseCurrentLoc delta:delta flags:[theEvent modifierFlags]]) {
                break;
            }
        }
        theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask];
    }
}

@end
