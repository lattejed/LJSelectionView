//
//  LJSelectionView.h
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LJSelectionView;
@class LJSelectionRectView;

@protocol LJSelectionViewDelegate <NSObject>
@required
- (void)selectionView:(LJSelectionView *)aSelectionView didSingleClickAtPoint:(NSPoint)point flags:(NSUInteger)flags;
- (BOOL)selectionView:(LJSelectionView *)aSelectionView shouldDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;
- (void)selectionView:(LJSelectionView *)aSelectionView didFinishDragFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 delta:(NSPoint)delta flags:(NSUInteger)flags;

@optional
- (void)selectionView:(LJSelectionView *)aSelectionView didDoubleClickatPoint:(NSPoint)point flags:(NSUInteger)flags;
@end

@interface LJSelectionView : NSView

@property (nonatomic, unsafe_unretained) id<LJSelectionViewDelegate> delegate;
@property (nonatomic, assign) BOOL canDragOutsideBounds;
@property (nonatomic, strong) LJSelectionRectView* selectionRectView;

- (void)addSelectionRectView:(LJSelectionRectView *)aSelectionRectView;
- (void)addSubViewRelativeToOverlay:(NSView *)aView;

@end
