//
//  LJSelectionRectView.h
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionItemView.h"

@interface LJSelectionRectView : NSView

@property (nonatomic, assign) BOOL showDashedLine;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineDashWidth;
@property (nonatomic, strong) NSColor* lineColor1;
@property (nonatomic, strong) NSColor* lineColor2;
@property (nonatomic, assign) BOOL showFill;
@property (nonatomic, strong) NSColor* fillColor;

@end
