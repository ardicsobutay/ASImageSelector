//
//  ASImageSelector.m
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import "ASImageSelector.h"
#import "ASImageSelectorVC.h"

@interface ASImageSelector () <ASImageSelectorVCDelegate>

@property (nonatomic, strong) ASImageSelectorVC *asImageSelectorVC;
@property (nonatomic, strong) UIImage *editorImage;

@end

@implementation ASImageSelector

- (void)presentImageSelectorWithImage:(UIImage *)image andOldSelectionRect:(CGRect)rect onViewController:(UIViewController *)viewController {
    _editorImage = image;
    _asImageSelectorVC = [[ASImageSelectorVC alloc] initWithImage:image andRect:rect];
    _asImageSelectorVC.delegate = self;
    [viewController presentViewController:self.asImageSelectorVC animated:YES completion:nil];

}

- (void)presentImageSelectorWithImage:(UIImage *)image onViewController:(UIViewController *)viewController {
    _editorImage = image;
    _asImageSelectorVC = [[ASImageSelectorVC alloc] initWithImage:image];
    _asImageSelectorVC.delegate = self;
    [viewController presentViewController:self.asImageSelectorVC animated:YES completion:nil];

}

- (void)asImageSelectorVC:(ASImageSelectorVC *)asImageSelectorVC selectionRect:(CGRect)selectionRect {
    if ([self.delegate respondsToSelector:@selector(asImageSelector:didSelectedImage:withSelectionRect:)]) {
        [self.delegate asImageSelector:self didSelectedImage:_editorImage withSelectionRect:selectionRect];
    }
}

@end
