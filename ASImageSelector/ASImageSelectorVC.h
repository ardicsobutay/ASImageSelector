//
//  ASImageSelectorVC.h
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASImageSelectorVC;
@protocol ASImageSelectorVCDelegate <NSObject>

- (void)asImageSelectorVC:(ASImageSelectorVC *)asImageSelectorVC selectionRect:(CGRect)selectionRect;

@end


@interface ASImageSelectorVC : UIViewController

@property (nonatomic, weak) id <ASImageSelectorVCDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image andRect:(CGRect)rect;

@end
