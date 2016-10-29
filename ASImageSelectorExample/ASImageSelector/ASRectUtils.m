//
//  ASRectUtils.m
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 20/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import "ASRectUtils.h"

@implementation ASRectUtils

+ (CGRect)leftUpCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke {
    CGPoint point = CGPointMake(rect.origin.x + (margin - borderStroke), rect.origin.y + (margin - borderStroke));
    return [self boundingBoxOfPoint:point withMargin:margin];
}

+ (CGRect)leftDownCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke {
    CGPoint point = CGPointMake(rect.origin.x + (margin - borderStroke), rect.origin.y + rect.size.height - (margin - borderStroke));
    return [self boundingBoxOfPoint:point withMargin:margin];
}

+ (CGRect)rightUpCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke {
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width - (margin - borderStroke), rect.origin.y  + (margin - borderStroke));
    return [self boundingBoxOfPoint:point withMargin:margin];
}

+ (CGRect)rightDownCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke {
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width - (margin - borderStroke), rect.origin.y + rect.size.height - (margin - borderStroke));
    return [self boundingBoxOfPoint:point withMargin:margin];
}

+ (CGRect)innerRectOfRect:(CGRect)rect withMargin:(CGFloat)margin {
    return CGRectMake(rect.origin.x + margin, rect.origin.y + margin, rect.size.width - (margin * 2), rect.size.height - (margin * 2));
}

+ (CGRect)getFrameInImageView:(UIImageView *)imageView {
    UIImage *image = imageView.image;
    float wi = image.size.width;
    float hi = image.size.height;
    
    float wv = imageView.frame.size.width;
    float hv = imageView.frame.size.height;
    
    float ri = hi / wi;
    float rv = hv / wv;
    
    CGFloat x, y, w, h;
    
    if (ri > rv) {
        h = hv;
        w = h / ri;
        x = (wv / 2) - (w / 2);
        y = 0;
    } else {
        w = wv;
        h = w * ri;
        x = 0;
        y = (hv / 2) - (h / 2);
    }
    
    return CGRectMake(x, y, w, h);
}

+ (CGRect)boundingBoxOfPoint:(CGPoint)point withMargin:(CGFloat)margin {
    return CGRectMake(point.x - margin, point.y - margin, margin * 2, margin * 2);
}
@end
