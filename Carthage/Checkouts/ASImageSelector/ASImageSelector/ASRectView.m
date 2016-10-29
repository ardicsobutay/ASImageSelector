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
    CGRect leftUp = [ASRectUtils leftUpCornerOfRect:_selectionRect withMargin:25 borderStroke:3];
    CGRect leftDown = [ASRectUtils leftDownCornerOfRect:_selectionRect withMargin:25 borderStroke:3];
    CGRect rightUp = [ASRectUtils rightUpCornerOfRect:_selectionRect withMargin:25 borderStroke:3];
    CGRect rightDown = [ASRectUtils rightDownCornerOfRect:_selectionRect withMargin:25 borderStroke:3];
    UIRectFill(leftUp);
    UIRectFill(leftDown);
    UIRectFill(rightUp);
    UIRectFill(rightDown);
    
    [[UIColor clearColor] setFill];
    UIRectFill(_selectionRect);
    
    //[self drawTouchAreas];
}

- (void)drawTouchAreas {
    float touchMargin = 25.0f+ 10;
    float borderStroke = 3.0f+ 20;
    
    [[UIColor redColor] setStroke];
    CGRect middle = [ASRectUtils innerRectOfRect:_selectionRect withMargin:5];
    CGRect leftUp = [ASRectUtils leftUpCornerOfRect:_selectionRect withMargin:touchMargin borderStroke:borderStroke];
    CGRect leftDown = [ASRectUtils leftDownCornerOfRect:_selectionRect withMargin:touchMargin borderStroke:borderStroke];
    CGRect rightUp = [ASRectUtils rightUpCornerOfRect:_selectionRect withMargin:touchMargin borderStroke:borderStroke];
    CGRect rightDown = [ASRectUtils rightDownCornerOfRect:_selectionRect withMargin:touchMargin borderStroke:borderStroke];
    
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
