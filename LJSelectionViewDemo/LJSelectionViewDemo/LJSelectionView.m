//
//  LJSelectionView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionView.h"

@implementation LJSelectionView

/*
- (void)dealloc;
{
#if __has_feature(objc_arc)
    //
#else
    [super dealloc];
#endif
}
*/

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [self initWithFrame:frameRect]) {

    }
    return self;
}

#pragma mark - Selection rect view and subview handling

- (void)addSelectionRectView:(LJSelectionRectView *)aSelectionRectView;
{
    if ([[self subviews] containsObject:_selectionRectView]) {
        [_selectionRectView removeFromSuperview];
    }
    self.selectionRectView = aSelectionRectView;
    [super addSubview:(NSView *)_selectionRectView positioned:NSWindowAbove relativeTo:nil];
}

- (void)addSubViewRelativeToOverlay:(NSView *)view;
{
    if (!_selectionRectView) {
        NSString* res = @"An instance of LJSelectionRectView needs to be added to LJSelectionView before other subviews are added.";
        NSException* exception = [NSException exceptionWithName:@"NoSelectionRectViewException"
                                                         reason:res
                                                       userInfo:nil];
        @throw exception;
    }
    [super addSubview:view positioned:NSWindowBelow relativeTo:(NSView *)_selectionRectView];
}

- (void)addSubview:(NSView *)aView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView;
{
    NSString* res = @"Only add subviews to this view with the addSubViewRelativeToOverlay: method.";
    NSException* exception = [NSException exceptionWithName:@"WrongMethodException"
                                                     reason:res
                                                   userInfo:nil];
    @throw exception;
}

- (void)addSubview:(NSView *)aView;
{
    NSString* res = @"Only add subviews to this view with the addSubViewRelativeToOverlay: method.";
    NSException* exception = [NSException exceptionWithName:@"WrongMethodException"
                                                     reason:res
                                                   userInfo:nil];
    @throw exception;
}

- (NSArray *)subviews;
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
        [_delegate selectionView:self didDoubleClickatPoint:point];
    }
    else {
        [_delegate selectionView:self didSingleClickAtPoint:point];
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
