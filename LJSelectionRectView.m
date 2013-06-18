//
//  LJSelectionRectView.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/11/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionRectView.h"

@implementation LJSelectionRectView

- (void)dealloc;
{
    self.lineColor1 = nil;
    self.lineColor2 = nil;
    self.fillColor = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(NSRect)frameRect;
{
    if (self = [super initWithFrame:frameRect]) {
        _showFill = YES;
        _showDashedLine = YES;
        _lineWidth = 2.0f;
        _lineDashWidth = 12.0f;
        self.lineColor1 = [NSColor blackColor];
        self.lineColor2 = [NSColor whiteColor];
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
