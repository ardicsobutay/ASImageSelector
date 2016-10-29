//
//  ASImageSelector.h
//  ASImageSelector
//
//  Created by Ardic Sobutay on 29/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ASImageSelector/ASRectUtils.h>

//! Project version number for ASImageSelector.
FOUNDATION_EXPORT double ASImageSelectorVersionNumber;

//! Project version string for ASImageSelector.
FOUNDATION_EXPORT const unsigned char ASImageSelectorVersionString[];

@class ASImageSelector;
@protocol ASImageSelectorDelegate <NSObject>

- (void)asImageSelector:(ASImageSelector *)asImageSelector didSelectedImage:(UIImage *)selectedImage withSelectionRect:(CGRect)selectionRect;

@end


@interface ASImageSelector: NSObject

@property (nonatomic, weak) id <ASImageSelectorDelegate> delegate;

- (void)presentImageSelectorWithImage:(UIImage *)image andOldSelectionRect:(CGRect)rect onViewController:(UIViewController *)viewController;
- (void)presentImageSelectorWithImage:(UIImage *)image onViewController:(UIViewController *)viewController;
@end
