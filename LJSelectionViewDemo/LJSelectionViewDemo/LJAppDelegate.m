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

#if __has_feature(objc_arc)
    #define SAFE_ARC_AUTORELEASE(__X__) (__X__)
    #define SAFE_ARC_SUPER_DEALLOC()
#else
    #define SAFE_ARC_AUTORELEASE(__X__) ([(__X__) autorelease])
    #define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#endif

@implementation LJAppDelegate

- (void)dealloc;
{
    _window.delegate = nil;
    self.undoManager = nil;
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
{
    self.undoManager = SAFE_ARC_AUTORELEASE([[NSUndoManager alloc] init]);
    _selectionViewController.undoManager = _undoManager;
    _window.delegate = self;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;
{
    return YES;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)aWindow;
{
    return _undoManager;
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
    NSImageView* item = SAFE_ARC_AUTORELEASE([[NSImageView alloc] initWithFrame:frame]);
    item.image = [NSImage imageNamed:@"Lenna.png"];
    [_selectionView addSelectableSubview:item];
}

- (IBAction)removeView:(id)sender;
{
    NSSet* selectedItems = _selectionViewController.selectedItems;
    for (NSView* item in selectedItems) {
        [item removeFromSuperview];
    }
}

@end
