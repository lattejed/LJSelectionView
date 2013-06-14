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
    if (self = [super initWithFrame:frameRect]) {
        _showFill = YES;
        self.fillColor = [NSColor colorWithCalibratedWhite:1.0f alpha:0.25f];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect;
{
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:NSInsetRect(self.bounds, self.lineWidth/2.0f, self.lineWidth/2.0f)];
    
    if (_showFill) {
        [self.fillColor setFill];
        [path fill];
    }
    
    [self.lineColor1 setStroke];
    [path setLineWidth:self.lineWidth];
    [path stroke];
    
    if (self.showDashedLine) {
        [self.lineColor2 setStroke];
        CGFloat ldw = self.lineDashWidth;
        [path setLineDash:&ldw count:1 phase:1.0f];
        [path stroke];
    }
}

@end
