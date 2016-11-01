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

#pragma mark - Private Properties
// UI Related Propertioes
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) ASRectView *asRectView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect selectionRect;

// Touch Event Properties
typedef enum {
    none,
    drag,
    leftUp,
    leftDown,
    rightUp,
    rightDown
} ImageEditType;

@property (nonatomic, assign) ImageEditType editType;
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGPoint oldTouchPoint;
@property (nonatomic, assign) CGPoint imageStartingPoint;
@property (nonatomic, assign) CGPoint imageMaxPoint;
@property (nonatomic, assign) float selectionBoxMinLimit;

@end


@implementation ASImageSelectorVC

#pragma mark - Init Methods
- (instancetype)initWithImage:(UIImage *)image {
    self = [[ASImageSelectorVC alloc] initWithImage:image andRect:CGRectZero];
    return self;
}

- (instancetype)initWithImage:(UIImage *)image andRect:(CGRect)rect {
    self = [[ASImageSelectorVC alloc] initWithNibName:@"ASImageSelectorVC" bundle:[NSBundle bundleForClass:[ASImageSelectorVC class]]];
    _image = image;
    _selectionRect = rect;
    _selectionBoxMinLimit = 150.0;
    return self;
}


#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imageView setImage:_image];

    _asRectView = [[ASRectView alloc] initWithFrame:_imageView.frame];
    _asRectView.cornerSize = 25.0;
    _asRectView.borderStroke = 3.0;
    _asRectView.touchMargin = 35.0;
    _asRectView.borderTouchMargin = 23.0;
    _asRectView.setTouchAreasHidden = NO;
    [_asRectView setHidden:YES];
    
    [_imageView addSubview:_asRectView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _imageRect = [ASRectUtils getFrameInImageView:_imageView];
    _imageStartingPoint = CGPointMake(_imageRect.origin.x, _imageRect.origin.y);
    _imageMaxPoint = CGPointMake(CGRectGetMaxX(_imageRect), CGRectGetMaxY(_imageRect));
    
    [self setImageSelectionRect];
    [self showSelectionRect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SelectionRect UI Methods
- (void)setImageSelectionRect {
    if (CGRectEqualToRect(_selectionRect, CGRectZero)) {
        _selectionRect = _imageRect;
    } else {
        _selectionRect = [self scaleSelectionRectToScreenRect:_selectionRect];
    }
}

- (void)showSelectionRect {
    [_asRectView setSelectionRect:_selectionRect];
    [_asRectView setHidden:NO];
}

- (void)hideSelectionRect {
    [_asRectView setSelectionRect:CGRectZero];
    [_asRectView setHidden:YES];
}

- (CGRect)scaleSelectionRectToScreenRect:(CGRect)selectionRect {
    CGRect screenRect = CGRectZero;
    
    float currentImageScale = _imageView.image.size.height/_imageRect.size.height;
    
    screenRect.origin.x = _imageRect.origin.x + (selectionRect.origin.x)/currentImageScale;
    screenRect.origin.y = _imageRect.origin.y + (selectionRect.origin.y)/currentImageScale;
    screenRect.size.width = (selectionRect.size.width <= _selectionBoxMinLimit) ? _selectionBoxMinLimit : selectionRect.size.width/currentImageScale;
    screenRect.size.height = (selectionRect.size.height <= _selectionBoxMinLimit) ? _selectionBoxMinLimit : selectionRect.size.height/currentImageScale;
    
    return screenRect;
}

- (CGRect)scaleSelectionRectToImageRect:(CGRect)selectionRect {
    CGRect imageRect = CGRectZero;
    
    float currentImageScale = _imageView.image.size.height/_imageRect.size.height;
    
    if (!CGRectEqualToRect(selectionRect, CGRectZero)) {
        imageRect.origin.x = (selectionRect.origin.x - _imageRect.origin.x) * currentImageScale;
        imageRect.origin.y = (selectionRect.origin.y - _imageRect.origin.y) * currentImageScale;
        imageRect.size.width = selectionRect.size.width * currentImageScale;
        imageRect.size.height = selectionRect.size.height * currentImageScale;
    }
    
    return imageRect;
}


#pragma mark - UI Actions
- (IBAction)savePressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(asImageSelectorVC:didSelectedRect:)]) {
        CGRect rectToSend = [self scaleSelectionRectToImageRect:_selectionRect];
        [self.delegate asImageSelectorVC:self didSelectedRect:rectToSend];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Drawing Methods
- (BOOL)isNextXInsideImageBounds:(float)nextX {
    if (nextX < _imageStartingPoint.x || CGRectGetMaxX(_selectionRect) - _selectionRect.origin.x + nextX  > _imageMaxPoint.x) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isNextYInsideImageBounds:(float)nextY {
    if (nextY < _imageStartingPoint.y || CGRectGetMaxY(_selectionRect) - _selectionRect.origin.y + nextY  > _imageMaxPoint.y) {
        return NO;
    } else {
        return YES;
    }
}

- (void)dragSelection:(CGPoint)touchLocation {
    float candidateX = _selectionRect.origin.x + touchLocation.x - _oldTouchPoint.x;
    if ([self isNextXInsideImageBounds:candidateX]) {
        _selectionRect.origin.x = candidateX;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float candidateY = _selectionRect.origin.y + touchLocation.y - _oldTouchPoint.y;
    if ([self isNextYInsideImageBounds:candidateY]) {
        _selectionRect.origin.y = candidateY;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForLeftUp:(CGPoint)touchLocation {
    float candidateX = _selectionRect.origin.x + touchLocation.x - _oldTouchPoint.x;
    float candidateWidth = _selectionRect.size.width - (touchLocation.x - _oldTouchPoint.x);
    if (candidateWidth >= _selectionBoxMinLimit && candidateX >= _imageStartingPoint.x) {
        _selectionRect.origin.x = candidateX;
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float candidateY = _selectionRect.origin.y + touchLocation.y - _oldTouchPoint.y;
    float candidateHeight = _selectionRect.size.height - (touchLocation.y - _oldTouchPoint.y);
    if (candidateHeight > _selectionBoxMinLimit && candidateY >= _imageStartingPoint.y) {
        _selectionRect.origin.y = candidateY;
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForLeftDown:(CGPoint)touchLocation {
    float candidateX = _selectionRect.origin.x + touchLocation.x - _oldTouchPoint.x;
    float candidateWidth = _selectionRect.size.width - (touchLocation.x - _oldTouchPoint.x);
    if (candidateWidth >= _selectionBoxMinLimit && candidateX >= _imageStartingPoint.x) {
        _selectionRect.origin.x = candidateX;
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float canadidateMaxY = CGRectGetMaxY(_selectionRect)  + touchLocation.y - _oldTouchPoint.y;
    float candidateHeight = _selectionRect.size.height + (touchLocation.y - _oldTouchPoint.y);
    if (candidateHeight >= _selectionBoxMinLimit && canadidateMaxY <= _imageMaxPoint.y) {
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForRightUp:(CGPoint)touchLocation {
    float canadidateMaxX = CGRectGetMaxX(_selectionRect)  + touchLocation.x - _oldTouchPoint.x;
    float candidateWidth = _selectionRect.size.width + (touchLocation.x - _oldTouchPoint.x);
    if (candidateWidth >= _selectionBoxMinLimit && canadidateMaxX <= _imageMaxPoint.x) {
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float candidateY = _selectionRect.origin.y + touchLocation.y - _oldTouchPoint.y;
    float candidateHeight = _selectionRect.size.height - (touchLocation.y - _oldTouchPoint.y);
    if (candidateHeight >= _selectionBoxMinLimit && candidateY >= _imageStartingPoint.y) {
        _selectionRect.origin.y = candidateY;
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}

- (void)transformSelectionForRightDown:(CGPoint)touchLocation {
    float canadidateMaxX = CGRectGetMaxX(_selectionRect)  + touchLocation.x - _oldTouchPoint.x;
    float candidateWidth = _selectionRect.size.width + (touchLocation.x - _oldTouchPoint.x);
    if (candidateWidth >= _selectionBoxMinLimit && canadidateMaxX <= _imageMaxPoint.x) {
        _selectionRect.size.width = candidateWidth;
        [_asRectView setSelectionRect:_selectionRect];
    }
    
    float canadidateMaxY = CGRectGetMaxY(_selectionRect)  + touchLocation.y - _oldTouchPoint.y;
    float candidateHeight = _selectionRect.size.height + (touchLocation.y - _oldTouchPoint.y);
    if (candidateHeight >= _selectionBoxMinLimit && canadidateMaxY <= _imageMaxPoint.y) {
        _selectionRect.size.height = candidateHeight;
        [_asRectView setSelectionRect:_selectionRect];
    }
}


#pragma mark - Touch Methods
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    touchLocation.x = roundf(touchLocation.x);
    touchLocation.y = roundf(touchLocation.y);

    switch (_editType) {
        case drag: {
            [self dragSelection:touchLocation];
            _oldTouchPoint = touchLocation;
            break;
        }
        case leftUp: {
            [self transformSelectionForLeftUp:touchLocation];
            _oldTouchPoint = touchLocation;
            break;
        }
        case leftDown: {
            [self transformSelectionForLeftDown:touchLocation];
            _oldTouchPoint = touchLocation;
            break;
        }
        case rightUp: {
            [self transformSelectionForRightUp:touchLocation];
            _oldTouchPoint = touchLocation;
            break;
        }
        case rightDown: {
            [self transformSelectionForRightDown:touchLocation];
            _oldTouchPoint = touchLocation;
            break;
        }
        default:
            break;
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _editType = none;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    touchLocation.x = roundf(touchLocation.x);
    touchLocation.y = roundf(touchLocation.y);
    
    if (CGRectContainsPoint([ASRectUtils leftUpCornerOfRect:_selectionRect withMargin:_asRectView.touchMargin borderStroke:_asRectView.borderTouchMargin], touchLocation)) {
        _editType = leftUp;
        _oldTouchPoint = touchLocation;
    } else if (CGRectContainsPoint([ASRectUtils leftDownCornerOfRect:_selectionRect withMargin:_asRectView.touchMargin borderStroke:_asRectView.borderTouchMargin], touchLocation)) {
        _editType = leftDown;
        _oldTouchPoint = touchLocation;
    } else if (CGRectContainsPoint([ASRectUtils rightUpCornerOfRect:_selectionRect withMargin:_asRectView.touchMargin borderStroke:_asRectView.borderTouchMargin], touchLocation)) {
        _editType = rightUp;
        _oldTouchPoint = touchLocation;
    } else if (CGRectContainsPoint([ASRectUtils rightDownCornerOfRect:_selectionRect withMargin:_asRectView.touchMargin borderStroke:_asRectView.borderTouchMargin], touchLocation)) {
        _editType = rightDown;
        _oldTouchPoint = touchLocation;
    } else if (CGRectContainsPoint(_selectionRect, touchLocation)) {
        _editType = drag;
        _oldTouchPoint = touchLocation;
    } else {
        _editType = none;
    }
}


@end
