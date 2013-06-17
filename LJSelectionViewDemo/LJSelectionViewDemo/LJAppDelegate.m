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
    int originX = arc4random() % (int)(_selectionView.frame.size.width  - 200);
    int originY = arc4random() % (int)(_selectionView.frame.size.height - 200);
    [self addViewWithFrame:NSMakeRect(originX, originY, 200, 200)];
}

- (void)addViewWithFrame:(NSRect)frame;
{
    NSImageView* item = [[NSImageView alloc] initWithFrame:frame];
    item.image = [NSImage imageNamed:@"Lenna.png"];
    [_selectionView addSelectableSubview:item];
#if !__has_feature(objc_arc)
    [item release];
#endif
}

- (IBAction)removeView:(id)sender;
{
    NSSet* selectedItems = _selectionViewController.selectedItems;
    for (NSView* item in selectedItems) {
        [item removeFromSuperview];
    }
}

@end
