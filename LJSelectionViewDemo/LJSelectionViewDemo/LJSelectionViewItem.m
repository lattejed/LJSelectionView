//
//  LJSelectionViewItem.m
//  LJSelectionViewDemo
//
//  Created by Matthew Smith on 6/14/13.
//  Copyright (c) 2013 lattejed.com. All rights reserved.
//

#import "LJSelectionViewItem.h"

@implementation LJSelectionViewItem

/*
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
*/

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor blackColor] setStroke];
    [[NSBezierPath bezierPathWithRect:self.bounds] stroke];
}

@end
