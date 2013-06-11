//
//  LJSelectionView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionView.h"

@implementation LJSelectionView

- (void)dealloc;
{
#if __has_feature(objc_arc)
    //
#else
    [super dealloc];
#endif
}

- (BOOL)acceptsFirstResponder; // TODO: test that we really need this? does it work properly?
{
    return YES;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    /*
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if ([_delegate respondsToSelector:@selector(boardViewSingleClick:atPoint:)]) {
        [_delegate boardViewSingleClick:self atPoint:point];
    }
    if([theEvent clickCount] == 2) {
        if ([_delegate respondsToSelector:@selector(boardViewDoubleClick:atPoint:)]) {
            [_delegate boardViewDoubleClick:self atPoint:point];
        }
    }
     */
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
    /*
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
            if ([_delegate respondsToSelector:@selector(boardViewDidFinishDrag:fromPoint:toPoint:delta:flags:)]) {
                [_delegate boardViewDidFinishDrag:self fromPoint:mouseStart toPoint:mouseCurrentLoc delta:delta flags:[theEvent modifierFlags]];
            }
            break;
        }
        else {
            if ([_delegate respondsToSelector:@selector(boardViewShouldDrag:fromPoint:toPoint:delta:flags:)]) {
                if ([self mouse:mouseCurrentLoc inRect:[self bounds]]) {
                    if (![_delegate boardViewShouldDrag:self fromPoint:mouseStart toPoint:mouseCurrentLoc delta:delta flags:[theEvent modifierFlags]]) {
                        break;
                    }
                }
            }
            else {
                break;
            }
        }
    }
     */
}

@end
