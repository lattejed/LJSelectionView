//
//  LJSelectionItemView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/14/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionItemView.h"

@implementation LJSelectionItemView

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [super initWithFrame:frameRect]) {
        _showDashedLine = YES;
        _lineWidth = 2.0f;
        _lineDashWidth = 12.0f;
        self.lineColor1 = [NSColor blackColor];
        self.lineColor2 = [NSColor whiteColor];
    }
    return self;
}

- (NSView *)hitTest:(NSPoint)aPoint;
{
    /*
     Ignore mouse events completely
     */
    return nil;
}

- (void)drawRect:(NSRect)dirtyRect;
{
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:NSInsetRect(self.bounds, _lineWidth/2.0f, _lineWidth/2.0f)];
    
    [_lineColor1 setStroke];
    [path setLineWidth:_lineWidth];
    [path stroke];
    
    if (_showDashedLine) {
        [_lineColor2 setStroke];
        [path setLineDash:&_lineDashWidth count:1 phase:1.0f];
        [path stroke];
    }
}

@end
