//
//  ASRectUtils.h
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 20/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASRectUtils : NSObject

+ (CGRect)leftUpCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke;
+ (CGRect)leftDownCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke;
+ (CGRect)rightUpCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke;
+ (CGRect)rightDownCornerOfRect:(CGRect)rect withMargin:(CGFloat)margin borderStroke:(CGFloat)borderStroke;
+ (CGRect)innerRectOfRect:(CGRect)rect withMargin:(CGFloat)margin;
+ (CGRect)getFrameInImageView:(UIImageView *)imageView;

@end
