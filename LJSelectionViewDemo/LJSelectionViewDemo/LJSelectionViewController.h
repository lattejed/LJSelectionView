//
//  LJSelectionViewController.h
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJSelectionView.h"

typedef enum {
    kSelectionBehaviorFull,
    kSelectionBehaviorPartial
} kSelectionBehavior;

typedef enum {
    kDragTypeNone,
    kDragTypeSelect
} kDragType;

@class LJSelectionView;

@interface LJSelectionViewController : NSObject <LJSelectionViewDelegate>

@property (nonatomic, strong) IBOutlet LJSelectionView* selectionView;
@property (nonatomic, assign) BOOL shouldManageSelectionUndo;
@property (nonatomic, strong) NSUndoManager* undoManager;
@property (nonatomic, assign) kSelectionBehavior selectionBehavior;
@property (nonatomic, assign) kDragType dragType;
@property (nonatomic, strong) NSSet* selectedItems;
@property (nonatomic, assign) NSRect selectionRect;

@end
