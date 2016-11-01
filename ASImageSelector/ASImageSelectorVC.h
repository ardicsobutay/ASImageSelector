//
//  ASImageSelectorVC.h
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Delegate Callback
@class ASImageSelectorVC;

@protocol ASImageSelectorVCDelegate <NSObject>

- (void)asImageSelectorVC:(ASImageSelectorVC *)asImageSelectorVC didSelectedRect:(CGRect)selectionRect;

@end


@interface ASImageSelectorVC : UIViewController


#pragma mark - Public Properties
@property (nonatomic, weak) id <ASImageSelectorVCDelegate> delegate;


#pragma mark - Init Methods
- (instancetype)initWithImage:(UIImage *)image;

- (instancetype)initWithImage:(UIImage *)image andRect:(CGRect)rect;

@end
