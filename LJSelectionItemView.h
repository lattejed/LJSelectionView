//
//  LJSelectionItemView.h
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/14/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

@interface LJSelectionItemView : NSView

@property (nonatomic, assign) BOOL showDashedLine;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineDashWidth;
@property (nonatomic, strong) NSColor* lineColor1;
@property (nonatomic, strong) NSColor* lineColor2;

@end
