//
//  ASImageSelectorVC.m
//  ASImagePickerExample
//
//  Created by Ardic Sobutay on 19/10/2016.
//  Copyright © 2016 Ardic Sobutay. All rights reserved.
//

#import "ASImageSelectorVC.h"
#import "ASRectView.h"
#import "ASRectUtils.h"

@interface ASImageSelectorVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGRect selectionRect;
@property (strong, nonatomic) ASRectView *asRectView;

typedef enum {
    none,
    drag,
    leftUp,
    leftDown,
    rightUp,
    rightDown
} ImageEditType;

@property (assign, nonatomic) float oldX, oldY, touchMargin;
@property (assign, nonatomic) CGPoint imageStartingPoint;
@property (assign, nonatomic) CGPoint imageMaxPoint;
@property (assign, nonatomic) ImageEditType editType;

@end

@implementation ASImageSelectorVC

- (instancetype)initWithImage:(UIImage *)image {
    self = [[ASImageSelectorVC alloc] initWithImage:image andRect:CGRectZero];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image andRect:(CGRect)rect {
    self = [[ASImageSelectorVC alloc] initWithNibName:@"ASImageSelectorVC" bundle:[NSBundle mainBundle]];
    _image = image;
    _selectionRect = rect;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_imageView setImage:_image];

    _asRectView = [[ASRectView alloc] initWithFrame:_imageView.frame];
    [self.imageView addSubview:_asRectView];
    [_asRectView setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (CGRectEqualToRect(_selectionRect, CGRectZero)) {
        _selectionRect = [ASRectUtils getFrameInImageView:_imageView];
    } else {
        CGRect imageRect = [ASRectUtils getFrameInImageView:_imageView];
        _selectionRect.origin.x += imageRect.origin.x;
        _selectionRect.origin.y += imageRect.origin.y;
        _selectionRect.size.width = (_selectionRect.size.width <= 150) ? 150 : _selectionRect.size.width;
        _selectionRect.size.height = (_selectionRect.size.height <= 150) ? 150 : _selectionRect.size.height;
    }
    [self showSelectionRect];
}

- (void)showSelectionRect {
    [_asRectView setSelectionRect:_selectionRect];
    [_asRectView setHidden:NO];
}

- (void)hideSelectionRect {
    [_asRectView setSelectionRect:CGRectZero];
    [_asRectView setHidden:YES];
}

- (IBAction)savePressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(asImageSelectorVC:selectionRect:)]) {
        
        CGRect imageRect = [ASRectUtils getFrameInImageView:_imageView];
        CGRect rectToSend = CGRectZero;
        rectToSend.origin.x = _selectionRect.origin.x - imageRect.origin.x;
        rectToSend.origin.y = _selectionRect.origin.y - imageRect.origin.y;
        rectToSend.size.width = _selectionRect.size.width;
        rectToSend.size.height = _selectionRect.size.height;
        
        [self.delegate asImageSelectorVC:self selectionRect:rectToSend];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dragSelection:(CGPoint)touchLocation {
    float candidateX = _selectionRect.origin.x + touchLocation.x - _oldX;
    float canadidateMaxX = CGRectGetMaxX(_selectionRect)  + touchLocation.x - _oldX;
    if (candidateX >= _imageStartingPoint.x && canadidateMaxX <= _imageMaxPoint.x) {
        _selectionRect.origin.x = candidateX;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float candidateY = _selectionRect.origin.y + touchLocation.y - _oldY;
    float canadidateMaxY = CGRectGetMaxY(_selectionRect)  + touchLocation.y - _oldY;
    if (candidateY >= _imageStartingPoint.y && canadidateMaxY <= _imageMaxPoint.y) {
        _selectionRect.origin.y = candidateY;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForLeftUp:(CGPoint)touchLocation {
    float minDimension = 150;
    
    float candidateX = _selectionRect.origin.x + touchLocation.x - _oldX;
    float candidateWidth = _selectionRect.size.width - (touchLocation.x - _oldX);
    if (candidateWidth > minDimension && candidateX >= _imageStartingPoint.x) {
        _selectionRect.origin.x = candidateX;
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float candidateY = _selectionRect.origin.y + touchLocation.y - _oldY;
    float candidateHeight = _selectionRect.size.height - (touchLocation.y - _oldY);
    if (candidateHeight > minDimension && candidateY >= _imageStartingPoint.y) {
        _selectionRect.origin.y = candidateY;
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
        _oldY = touchLocation.y;
    }
}

- (void)transformSelectionForLeftDown:(CGPoint)touchLocation {
    float minDimension = 150;
    
    float candidateX = _selectionRect.origin.x + touchLocation.x - _oldX;
    float candidateWidth = _selectionRect.size.width - (touchLocation.x - _oldX);
    if (candidateWidth > minDimension && candidateX >= _imageStartingPoint.x) {
        _selectionRect.origin.x = candidateX;
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float canadidateMaxY = CGRectGetMaxY(_selectionRect)  + touchLocation.y - _oldY;
    float candidateHeight = _selectionRect.size.height + (touchLocation.y - _oldY);
    if (candidateHeight > minDimension && canadidateMaxY <= _imageMaxPoint.y) {
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForRightUp:(CGPoint)touchLocation {
    float minDimension = 150;
    
    float canadidateMaxX = CGRectGetMaxX(_selectionRect)  + touchLocation.x - _oldX;
    float candidateWidth = _selectionRect.size.width + (touchLocation.x - _oldX);
    if (candidateWidth > minDimension && canadidateMaxX <= _imageMaxPoint.x) {
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float candidateY = _selectionRect.origin.y + touchLocation.y - _oldY;
    float candidateHeight = _selectionRect.size.height - (touchLocation.y - _oldY);
    if (candidateHeight > minDimension && candidateY >= _imageStartingPoint.y) {
        _selectionRect.origin.y = candidateY;
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForRightDown:(CGPoint)touchLocation {
    float minDimension = 150;
    
    float canadidateMaxX = CGRectGetMaxX(_selectionRect)  + touchLocation.x - _oldX;
    float candidateWidth = _selectionRect.size.width + (touchLocation.x - _oldX);
    if (candidateWidth > minDimension && canadidateMaxX <= _imageMaxPoint.x) {
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float canadidateMaxY = CGRectGetMaxY(_selectionRect)  + touchLocation.y - _oldY;
    float candidateHeight = _selectionRect.size.height + (touchLocation.y - _oldY);
    if (candidateHeight > minDimension && canadidateMaxY <= _imageMaxPoint.y) {
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];

    switch (_editType) {
        case drag: {
            [self dragSelection:touchLocation];
            _oldX = touchLocation.x;
            _oldY = touchLocation.y;
            break;
        }
        case leftUp: {
            [self transformSelectionForLeftUp:touchLocation];
            _oldX = touchLocation.x;
            _oldY = touchLocation.y;
            break;
        }
        case leftDown: {
            [self transformSelectionForLeftDown:touchLocation];
            _oldX = touchLocation.x;
            _oldY = touchLocation.y;
            break;
        }
        case rightUp: {
            [self transformSelectionForRightUp:touchLocation];
            _oldX = touchLocation.x;
            _oldY = touchLocation.y;
            break;
        }
        case rightDown: {
            [self transformSelectionForRightDown:touchLocation];
            _oldX = touchLocation.x;
            _oldY = touchLocation.y;
            break;
        }
        default:
            break;
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _editType = none;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    CGRect imageFullRect = [ASRectUtils getFrameInImageView:_imageView];
    _imageStartingPoint = CGPointMake(imageFullRect.origin.x, imageFullRect.origin.y);
    _imageMaxPoint = CGPointMake(CGRectGetMaxX(imageFullRect), CGRectGetMaxY(imageFullRect));
    
    _touchMargin = 25.0f+ 10;
    float borderStroke = 3.0f+ 20;
    
    if (CGRectContainsPoint([ASRectUtils leftUpCornerOfRect:_selectionRect withMargin:_touchMargin borderStroke:borderStroke], touchLocation)) {
        _editType = leftUp;
        _oldX = touchLocation.x;
        _oldY = touchLocation.y;
    } else if (CGRectContainsPoint([ASRectUtils leftDownCornerOfRect:_selectionRect withMargin:_touchMargin borderStroke:borderStroke], touchLocation)) {
        _editType = leftDown;
        _oldX = touchLocation.x;
        _oldY = touchLocation.y;
    } else if (CGRectContainsPoint([ASRectUtils rightUpCornerOfRect:_selectionRect withMargin:_touchMargin borderStroke:borderStroke], touchLocation)) {
        _editType = rightUp;
        _oldX = touchLocation.x;
        _oldY = touchLocation.y;
    } else if (CGRectContainsPoint([ASRectUtils rightDownCornerOfRect:_selectionRect withMargin:_touchMargin borderStroke:borderStroke], touchLocation)) {
        _editType = rightDown;
        _oldX = touchLocation.x;
        _oldY = touchLocation.y;
    } else if (CGRectContainsPoint([ASRectUtils innerRectOfRect:_selectionRect withMargin:5], touchLocation)) {
        _editType = drag;
        _oldX = touchLocation.x;
        _oldY = touchLocation.y;
    } else {
        _editType = none;
    }
}


@end
