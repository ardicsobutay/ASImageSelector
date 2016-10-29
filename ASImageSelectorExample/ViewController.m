//
//  ViewController.m
//  ASImageSelectorExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import "ViewController.h"
#import <ASImageSelector/ASImageSelector.h>


@interface ViewController () <ASImageSelectorDelegate>

@property (nonatomic, strong) ASImageSelector *selector;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)openTouched:(UIButton *)sender {
    self.selector = [ASImageSelector new];
    self.selector.delegate = self;

    [self.selector presentImageSelectorWithImage:[UIImage imageNamed:@"clear"] onViewController:self];
   //[self.selector presentImageSelectorWithImage:[UIImage imageNamed:@"clear"] andOldSelectionRect:CGRectMake(0, 0, 200, 200) onViewController:self];
}

-(void)asImageSelector:(ASImageSelector *)asImageSelector didSelectedImage:(UIImage *)selectedImage withSelectionRect:(CGRect)selectionRect {
    NSLog(@"(%f,%f) <%f,%f>", selectionRect.origin.x, selectionRect.origin.y, selectionRect.size.width, selectionRect.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
