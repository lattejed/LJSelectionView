//
//  LJSelectionRectView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionRectView.h"

@implementation LJSelectionRectView

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [self initWithFrame:frameRect]) {
        _showFill = NO;
        _showDashedLine = NO;
        _lineWidth = 2.0f;
        _lineDashWidth = 12.0f;
        self.lineColor1 = [NSColor blackColor];
        self.lineColor2 = [NSColor whiteColor];
        self.fillColor = [NSColor colorWithCalibratedWhite:0.5f alpha:0.5f];
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
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:self.bounds];
    
    if (_showFill) {
        [_fillColor setFill];
        [path fill];
    }
    
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
