//
//  LJSelectionView.h
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LJSelectionView;

@protocol LJSelectionViewDelegate <NSObject>
@required
- (void)selectionView:(LJSelectionView *)aSelectionView didSingleClickAtPoint:(NSPoint)point;
- (void)selectionView:(LJSelectionView *)aSelectionView didDoubleClickatPoint:(NSPoint)point;
- (BOOL)selectionView:(LJSelectionView *)aSelectionView shouldDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;
- (void)selectionView:(LJSelectionView *)aSelectionView shouldFinishDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;

@optional
//
@end

@interface LJSelectionView : NSView

@property (nonatomic, unsafe_unretained) id<LJSelectionViewDelegate> delegate;

@end
