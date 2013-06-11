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

@interface LJSelectionViewController : NSObject <LJSelectionViewDelegate>

@property (nonatomic, assign) BOOL shouldManageSelectionUndo;
@property (nonatomic, unsafe_unretained) NSUndoManager* undoManager;
@property (nonatomic, assign) kSelectionBehavior selectionBehavior;

@end
