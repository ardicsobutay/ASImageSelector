//
//  ASRectView.m
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import "ASRectView.h"
#import "ASRectUtils.h"

@interface ASRectView ()

@property (nonatomic, assign) CGRect selectionRect;

@end


@implementation ASRectView

- (void)setSelectionRect:(CGRect)rect {
    _selectionRect = rect;

    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Start by filling the area with the blue color
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] setFill];
    UIRectFill(rect);

    [[UIColor colorWithRed:0.95 green:0.55 blue:0.0 alpha:0.7] setFill];
    CGRect leftUp = [ASRectUtils leftUpCornerOfRect:_selectionRect withMargin:self.cornerSize borderStroke:self.borderStroke];
    CGRect leftDown = [ASRectUtils leftDownCornerOfRect:_selectionRect withMargin:self.cornerSize borderStroke:self.borderStroke];
    CGRect rightUp = [ASRectUtils rightUpCornerOfRect:_selectionRect withMargin:self.cornerSize borderStroke:self.borderStroke];
    CGRect rightDown = [ASRectUtils rightDownCornerOfRect:_selectionRect withMargin:self.cornerSize borderStroke:self.borderStroke];
    UIRectFill(leftUp);
    UIRectFill(leftDown);
    UIRectFill(rightUp);
    UIRectFill(rightDown);
    
    [[UIColor clearColor] setFill];
    UIRectFill(_selectionRect);
    
    if (!self.setTouchAreasHidden) {
        [self drawTouchAreas];
    }
}

- (void)drawTouchAreas {
    
    [[UIColor redColor] setStroke];
    CGRect middle = _selectionRect;
    CGRect leftUp = [ASRectUtils leftUpCornerOfRect:_selectionRect withMargin:self.touchMargin borderStroke:self.borderTouchMargin];
    CGRect leftDown = [ASRectUtils leftDownCornerOfRect:_selectionRect withMargin:self.touchMargin borderStroke:self.borderTouchMargin];
    CGRect rightUp = [ASRectUtils rightUpCornerOfRect:_selectionRect withMargin:self.touchMargin borderStroke:self.borderTouchMargin];
    CGRect rightDown = [ASRectUtils rightDownCornerOfRect:_selectionRect withMargin:self.touchMargin borderStroke:self.borderTouchMargin];
    
    UIBezierPath *touchMiddle = [UIBezierPath bezierPathWithRect:middle];
    UIBezierPath *touchLeftUp = [UIBezierPath bezierPathWithRect:leftUp];
    UIBezierPath *touchLeftDown = [UIBezierPath bezierPathWithRect:leftDown];
    UIBezierPath *touchRightUp = [UIBezierPath bezierPathWithRect:rightUp];
    UIBezierPath *touchRightDown = [UIBezierPath bezierPathWithRect:rightDown];
    
    [touchMiddle setLineWidth:1];
    [touchLeftUp setLineWidth:1];
    [touchLeftDown setLineWidth:1];
    [touchRightUp setLineWidth:1];
    [touchRightDown setLineWidth:1];
    
    [touchMiddle stroke];
    [touchLeftUp stroke];
    [touchLeftDown stroke];
    [touchRightUp stroke];
    [touchRightDown stroke];
}

@end
