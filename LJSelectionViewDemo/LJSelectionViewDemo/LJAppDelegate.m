//
//  LJAppDelegate.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJAppDelegate.h"
#import "LJSelectionViewController.h"
#import "LJSelectionView.h"

@implementation LJAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    // Insert code here to initialize your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;
{
    return YES;
}

// Example actions
- (IBAction)addView:(id)sender;
{
    //LJSelectionViewItem* item = [[LJSelectionViewItem alloc] initWithFrame:NSMakeRect(100, 100, 100, 100)];
    //[_selectionView addSelectableSubview:item];
#if !__has_feature(objc_arc)
    //[item release];
#endif
}

- (IBAction)removeView:(id)sender;
{
    NSSet* selectedItems = _selectionViewController.selectedItems;
    //for (LJSelectionViewItem* item in selectedItems) {
    //    [item removeFromSuperview];
    //}
}

@end
