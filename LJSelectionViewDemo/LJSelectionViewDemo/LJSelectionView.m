//
//  LJSelectionView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionView.h"
#import "LJSelectionRectView.h"

@interface LJSelectionView ()

- (void)drawSelectionRect;
- (void)drawItemHighlights;

@end

@implementation LJSelectionView

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [super initWithFrame:frameRect]) {
        _canDragOutsideBounds = YES;
        _drawsItemHighlights = YES;
        
        _showDashedLine = YES;
        _lineWidth = 2.0f;
        _lineDashWidth = 12.0f;
        self.lineColor1 = [NSColor blackColor];
        self.lineColor2 = [NSColor whiteColor];
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
    if (_drawsItemHighlights) {
        [self drawItemHighlights];
    }
    [self drawSelectionRect];
}

#pragma mark - Selection rect view and subview handling

- (void)drawSelectionRect;
{
    NSRect rect = [_delegate selectionViewRectForSelection];
    [_selectionRectView setFrame:rect];
}

- (void)drawItemHighlights;
{
    if ([_delegate respondsToSelector:@selector(selectionViewSelectedItems)]) {
        NSSet* selectedItems = [_delegate selectionViewSelectedItems];
        for (NSView* item in selectedItems) {
            NSBezierPath* path = [NSBezierPath bezierPathWithRect:NSInsetRect(item.frame, -_lineWidth/2.0f, -_lineWidth/2.0f)];
            
            [_lineColor1 setStroke];
            [path setLineWidth:_lineWidth];
            [path stroke];
            
            if (_showDashedLine) {
                [_lineColor2 setStroke];
                [path setLineDash:&_lineDashWidth count:1 phase:1.0f];
                [path stroke];
            }
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
    NSMutableArray* array = [_subviews mutableCopy];
    if (_selectionRectView) {
        [array removeObject:_selectionRectView];
    }
    return [array copy];
}

#pragma mark - Mouse events

- (void)mouseUp:(NSEvent *)theEvent;
{
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if([theEvent clickCount] == 2) {
        if ([_delegate respondsToSelector:@selector(selectionView:didDoubleClickatPoint:flags:)]) {
            [_delegate selectionView:self didDoubleClickatPoint:point flags:[theEvent modifierFlags]];
        }
    }
    else {
        [_delegate selectionView:self didSingleClickAtPoint:point flags:[theEvent modifierFlags]];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
    NSPoint mouseStart = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint mouseCurrentLoc = mouseStart;
    NSPoint mouseLastLoc = mouseStart;
    NSPoint delta = NSZeroPoint;
    
    while (YES) {
        theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask];
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
    }
}

@end
