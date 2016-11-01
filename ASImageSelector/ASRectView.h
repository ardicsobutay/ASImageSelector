//
//  ASRectView.h
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASRectView : UIView

@property (nonatomic, assign) CGFloat touchMargin;
@property (nonatomic, assign) CGFloat borderTouchMargin;
@property (nonatomic, assign) CGFloat borderStroke;
@property (nonatomic, assign) CGFloat cornerSize;
@property (nonatomic, assign) BOOL setTouchAreasHidden;

- (void)setSelectionRect:(CGRect)rect;

@end
