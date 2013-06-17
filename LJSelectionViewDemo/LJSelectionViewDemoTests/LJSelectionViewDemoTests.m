//
//  LJSelectionViewDemoTests.m
//  LJSelectionViewDemoTests
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionViewDemoTests.h"
#import "LJAppDelegate.h"
#import "LJSelectionViewController.h"
#import "LJSelectionView.h"
#import "LJSelectionItemView.h"

@interface LJSelectionViewController ()

- (void)pruneSelectionIfNecesary;

@end

@interface LJSelectionView ()

- (void)drawItemHighlights;
- (void)removeHighlightViews;
- (NSArray *)highlightViews;

@end

@implementation LJSelectionViewDemoTests

- (void)setUp
{
    [super setUp];
    
    _app = [NSApplication sharedApplication];
    _appDelegate = (LJAppDelegate *)[_app delegate];
    _selectionViewController = _appDelegate.selectionViewController;
    _selectionView = _appDelegate.selectionView;
    
    _selectionViewController.selectionBehavior = kSelectionBehaviorPartial;
    _selectionView.drawsItemHighlights = YES;
    
    [_appDelegate addViewWithFrame:NSMakeRect(0,  0,  500,500)];
    [_appDelegate addViewWithFrame:NSMakeRect(500,0,  500,500)];
    [_appDelegate addViewWithFrame:NSMakeRect(0,  500,500,500)];
    
    _selectableViews = [[_selectionView selectableSubviews] copy];
}

- (void)tearDown
{
    [_selectableViews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_selectionViewController setSelectedItems:[NSSet set]];
    [_selectionView removeHighlightViews];
    
    _app = nil;
    _appDelegate = nil;
    _selectionViewController = nil;
    _selectionView = nil;
    [super tearDown];
}

- (void)testSelectionViewAndController
{
    STAssertNotNil(_selectionViewController, @"_selectionViewController is nil.");
    STAssertNotNil(_selectionView, @"_selectionView is nil.");
    STAssertNotNil(_selectionView.selectionRectView, @"_selectionView.selectionRectView is nil.");
}

- (void)testSelectionViewSubviews
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
}

- (void)testClickSelectionItemSingle
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Select one
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testClickSelectionItemMultiple
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Select two
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 750) flags:NSShiftKeyMask];

    STAssertEquals([_selectionViewController selectedItems].count, 2UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testClickSelectionItemToggle
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Select two
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 750) flags:NSShiftKeyMask];
    
    STAssertEquals([_selectionViewController selectedItems].count, 2UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Deselect one
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 750) flags:NSShiftKeyMask];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Deselect one
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:NSShiftKeyMask];
    
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testDragSelectionItemSingle
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Drag select one
    [_selectionViewController selectionView:_selectionView
                        shouldDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(250, 250)
                                      delta:NSZeroPoint
                                      flags:0];
    [_selectionViewController selectionView:_selectionView
                     didFinishDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(251, 251)
                                      delta:NSMakePoint(1, 1)
                                      flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testDragSelectionItemMultiple
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Drag select two
    [_selectionViewController selectionView:_selectionView
                        shouldDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(250, 250)
                                      delta:NSZeroPoint
                                      flags:0];
    [_selectionViewController selectionView:_selectionView
                     didFinishDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(251, 750)
                                      delta:NSMakePoint(1, 500)
                                      flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 2UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testDragSelectionItemToggle
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Drag select two
    [_selectionViewController selectionView:_selectionView
                        shouldDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(250, 250)
                                      delta:NSZeroPoint
                                      flags:0];
    [_selectionViewController selectionView:_selectionView
                     didFinishDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(251, 750)
                                      delta:NSMakePoint(1, 500)
                                      flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 2UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Drag deselect one
    [_selectionViewController selectionView:_selectionView
                        shouldDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(250, 250)
                                      delta:NSZeroPoint
                                      flags:NSShiftKeyMask];
    [_selectionViewController selectionView:_selectionView
                     didFinishDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(251, 251)
                                      delta:NSMakePoint(1, 1)
                                      flags:NSShiftKeyMask];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testPruneSelection
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Select three
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 750) flags:NSShiftKeyMask];
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(750, 250) flags:NSShiftKeyMask];
    
    STAssertEquals([_selectionViewController selectedItems].count, 3UL, @"SelectionViewController has the wrong number of selected items.");
    
    [_selectableViews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_selectionViewController pruneSelectionIfNecesary];

    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testSelectionBehaviorFull
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");

    // Add a view in the middle
    [_appDelegate addViewWithFrame:NSMakeRect(300, 300, 300, 300)];
    _selectableViews = [[_selectionView selectableSubviews] copy];
    
    // Drag deselect all
    [_selectionViewController selectionView:_selectionView
                        shouldDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(250, 250)
                                      delta:NSZeroPoint
                                      flags:0];
    [_selectionViewController selectionView:_selectionView
                     didFinishDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(750, 750)
                                      delta:NSMakePoint(500, 500)
                                      flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 4UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Ignore partial selection
    _selectionViewController.selectionBehavior = kSelectionBehaviorFull;
    
    // Drag deselect all
    [_selectionViewController selectionView:_selectionView
                        shouldDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(250, 250)
                                      delta:NSZeroPoint
                                      flags:0];
    [_selectionViewController selectionView:_selectionView
                     didFinishDragFromPoint:NSMakePoint(250, 250)
                                    toPoint:NSMakePoint(750, 750)
                                      delta:NSMakePoint(500, 500)
                                      flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
}

- (void)testDeselect
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Select one
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
    
    // Select none
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(750, 750) flags:0];
    
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");    
}

- (void)testDrawsItemHighlights
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    STAssertEquals([_selectionView highlightViews].count, 0UL, @"SelectionView has the wrong number of highlight views.");

    // Select one
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    [_selectionView removeHighlightViews];
    [_selectionView drawItemHighlights];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
    STAssertEquals([_selectionView highlightViews].count, 1UL, @"SelectionView has the wrong number of highlight views.");
    
    // Select one more
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 750) flags:NSShiftKeyMask];
    [_selectionView removeHighlightViews];
    [_selectionView drawItemHighlights];

    STAssertEquals([_selectionViewController selectedItems].count, 2UL, @"SelectionViewController has the wrong number of selected items.");
    STAssertEquals([_selectionView highlightViews].count, 2UL, @"SelectionView has the wrong number of highlight views.");
    
    // Select none
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(750, 750) flags:0];
    [_selectionView removeHighlightViews];
    [_selectionView drawItemHighlights];
    
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    STAssertEquals([_selectionView highlightViews].count, 0UL, @"SelectionView has the wrong number of highlight views.");
}

- (void)testDoesntDrawItemHighlights
{
    STAssertEquals([_selectionView selectableSubviews].count, 3UL, @"SelectionView has the wrong number of subviews.");
    STAssertEquals([_selectionViewController selectedItems].count, 0UL, @"SelectionViewController has the wrong number of selected items.");
    STAssertEquals([_selectionView highlightViews].count, 0UL, @"SelectionView has the wrong number of highlight views.");
    STAssertTrue(_selectionView.drawsItemHighlights, @"SelectionView should draw highlight views.");
    
    _selectionView.drawsItemHighlights = NO;
    
    STAssertFalse(_selectionView.drawsItemHighlights, @"SelectionView shouldn't draw highlight views.");

    // Select one
    [_selectionViewController selectionView:_selectionView didSingleClickAtPoint:NSMakePoint(250, 250) flags:0];
    [_selectionView removeHighlightViews];
    [_selectionView drawItemHighlights];
    
    STAssertEquals([_selectionViewController selectedItems].count, 1UL, @"SelectionViewController has the wrong number of selected items.");
    STAssertEquals([_selectionView highlightViews].count, 0UL, @"SelectionView has the wrong number of highlight views.");
}

@end
