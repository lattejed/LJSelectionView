//
//  LJSelectionViewDemoTests.h
//  LJSelectionViewDemoTests
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class LJAppDelegate;
@class LJSelectionViewController;
@class LJSelectionView;

@interface LJSelectionViewDemoTests : SenTestCase {
    NSApplication* _app;
    LJAppDelegate* _appDelegate;
    LJSelectionViewController* _selectionViewController;
    LJSelectionView* _selectionView;
    NSArray* _selectableViews;
}

@end
