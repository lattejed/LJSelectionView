//
//  LJAppDelegate.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LJSelectionView;
@class LJSelectionViewController;

@interface LJAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet NSWindow *window;
@property (nonatomic, unsafe_unretained) IBOutlet LJSelectionView* selectionView;
@property (nonatomic, unsafe_unretained) IBOutlet LJSelectionViewController* selectionViewController;

- (IBAction)addView:(id)sender;
- (IBAction)removeView:(id)sender;

@end
