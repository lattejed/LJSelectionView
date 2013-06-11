//
//  LJSelectionViewController.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionViewController.h"

@implementation LJSelectionViewController

#pragma mark - Selection management

- (void)addViewToSelection:(NSView *)aView append:(BOOL)append;
{
    [[_undoManager prepareWithInvocationTarget:self] setSelectedSubviews:_selectedSubviews];
    if (append) {
        [_undoManager setActionName:NSLocalizedString(@"Add To Selection", @"")];
        self.selectedSubviews = [_selectedSubviews arrayByAddingObject:aView];
    }
    else {
        [_undoManager setActionName:NSLocalizedString(@"Select", @"")];
        self.selectedSubviews = [NSArray arrayWithObject:aView];
    }
}

- (void)clearSelection;
{
    [[_undoManager prepareWithInvocationTarget:self] setSelectedSubviews:_selectedSubviews];
    [_undoManager setActionName:NSLocalizedString(@"Clear Selection", @"")];
    self.selectedSubviews = nil;
}

#pragma mark - LJSelectionViewDelegate

- (void)selectionView:(LJSelectionView *)aSelectionView didSingleClickAtPoint:(NSPoint)point;
{
    for (NSView* views in [_selectionView subviews]) {
        
    }
}

- (void)selectionView:(LJSelectionView *)aSelectionView didDoubleClickatPoint:(NSPoint)point;
{

}

- (BOOL)selectionView:(LJSelectionView *)aSelectionView shouldDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;
{

    return NO;
}

- (void)selectionView:(LJSelectionView *)aSelectionView didFinishDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;
{

}

@end
