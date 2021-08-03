//
//  GYStickerView.m
//  GYStickerView
//
//  Created by 黄国裕 on 17/1/23.
//  Copyright © 2017年 黄国裕. All rights reserved.
//

#import "GYStickerView.h"
#import "UIImage+Rotate.h"

@interface GYStickerView()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isHiddenRemoveCtrl;

@end

@implementation GYStickerView

#define CTRL_RADIUS 14 //控制图的半径

- (void)changeContentView:(UIView *)contentView {
    self.contentView = contentView;
    _border.path = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    _border.frame = self.contentView.frame;
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super init];
    if (self) {
        self.contentView = contentView;
        self.minScale = 0.5;
        self.maxScale = 2;
//        self.reversalCtrl;
        
        
        [self showRemoveCtrl:YES];
        self.ctrlType = GYStickerViewCtrlTypeGesture;//默认为手势模式
        self.originalPoint = CGPointMake(0.5, 0.5);  //默认参考点为中心点
        self.scaleFit = YES;
//        [self addGestureRecognizer:self.panGesture];//添加拖动手势，所有模式通用
        [self dottedLineboradView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPickerView:)];
        [self addGestureRecognizer:singleTap];
        
    }
    return self;
}

- (void)showReversalCtrl:(BOOL)b {

//    if (!b) {
//        [_reversalCtrl removeFromSuperview];
//    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self];
    
    [self showCtrls];
}

- (void)tappedPickerView:(UIGestureRecognizer *)tip {
    
    if (self.isSelect) {
        if (_editTextBlock) {
            __weak __typeof__(self) __weakSelf = self;
            self.editTextBlock(__weakSelf.tag);
        }
        
        if (_editBlock) {
            self.editBlock(_fontIndex, _fontName, _colorIndex, _colorName, _textStickerAlpha, _textStrokeWidth, _textStrokeColorName, _textStrokeColorIndex, _underscore, _textAlignment, _spacing, _contentAlpha, _contentColorName, _contentColorIndex);
        }
    } else {
        [self showCtrls];
    }
}

- (void)dottedLineboradView {
    self.boradView = [[UIView alloc] init];
    self.boradView.backgroundColor = [UIColor redColor];
    [self insertSubview:_boradView atIndex:1];
}

- (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    //    if ([cString hasPrefix:@"0X"])
    //        cString = [cString substringFromIndex:2];
    //    if ([cString hasPrefix:@"#"])
    //        cString = [cString substringFromIndex:1];
    //    if ([cString length] != 6)
    //        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


#pragma mark - setter & getter 方法


/* setter */

- (void)setContentView:(UIView *)contentView {
    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
        self.transform = CGAffineTransformIdentity;
    }
    _contentView = contentView;
    self.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width + CTRL_RADIUS * 2, contentView.frame.size.height + CTRL_RADIUS * 2);
    _contentView.frame = CGRectMake(CTRL_RADIUS, CTRL_RADIUS, _contentView.frame.size.width, _contentView.frame.size.height);
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self insertSubview:_contentView atIndex:0];
}

- (void)setCtrlType:(GYStickerViewCtrlType)ctrlType {
    _ctrlType = ctrlType;
    switch (_ctrlType) {
        case GYStickerViewCtrlTypeGesture:
//            if (![self.gestureRecognizers containsObject:self.pinchGesture]) {
//                [self addGestureRecognizer:self.pinchGesture];
//            }
            if (![self.gestureRecognizers containsObject:self.rotateGesture]) {
                [self addGestureRecognizer:self.rotateGesture];
            }
            self.transformCtrl.hidden = YES;
            self.rotateCtrl.hidden = YES;
            self.resizeCtrl.hidden = YES;
            break;

        case GYStickerViewCtrlTypeOne:
//            if ([self.gestureRecognizers containsObject:self.pinchGesture]) {
//                [self removeGestureRecognizer:self.pinchGesture];
//            }
            if ([self.gestureRecognizers containsObject:self.rotateGesture]) {
                [self removeGestureRecognizer:self.rotateGesture];
            }
            self.transformCtrl.hidden = NO;
            self.rotateCtrl.hidden = YES;
            self.resizeCtrl.hidden = YES;
            break;

        case GYStickerViewCtrlTypeTwo:
//            if ([self.gestureRecognizers containsObject:self.pinchGesture]) {
//                [self removeGestureRecognizer:self.pinchGesture];
//            }
            if ([self.gestureRecognizers containsObject:self.rotateGesture]) {
                [self removeGestureRecognizer:self.rotateGesture];
            }
            self.transformCtrl.hidden = YES;
            self.rotateCtrl.hidden = NO;
            self.resizeCtrl.hidden = NO;
            break;

        default:
            break;
    }
}

- (void)setOriginalPoint:(CGPoint)originalPoint {
//    if (self.ctrlType == GYStickerViewCtrlTypeGesture) {
//        _originalPoint = CGPointMake(0.5, 0.5);
//        return;
//    }
    _originalPoint = originalPoint;
    [self updateCtrlPoint];
}


/* getter */

- (UIImageView *)transformCtrl {
    if (!_transformCtrl) {
//        CGRect frame = CGRectMake(self.bounds.size.width - CTRL_RADIUS * 2,
//                                  self.bounds.size.height - CTRL_RADIUS * 2,
//                                  CTRL_RADIUS * 2,
//                                  CTRL_RADIUS * 2);
//        _transformCtrl = [[UIImageView alloc] initWithFrame:frame];
//        _transformCtrl.backgroundColor = [UIColor redColor];
//        _transformCtrl.userInteractionEnabled = YES;
//        _transformCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        [self addSubview:_transformCtrl];
//
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(transformCtrlPan:)];
//        [_transformCtrl addGestureRecognizer:panGesture];
    }
    return _transformCtrl;
}

- (UIImageView *)rotateCtrl {
    if (!_rotateCtrl) {
        CGRect frame = CGRectMake(self.bounds.size.width - (CTRL_RADIUS * 2),
                                  0,
                                  CTRL_RADIUS * 2,
                                  CTRL_RADIUS * 2);
        _rotateCtrl = [[UIImageView alloc] initWithFrame:frame];
        _rotateCtrl.backgroundColor = [UIColor purpleColor];
        _rotateCtrl.userInteractionEnabled = YES;
        _rotateCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_rotateCtrl];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateCtrlPan:)];
        [_rotateCtrl addGestureRecognizer:panGesture];
    }
    return _rotateCtrl;
}

- (UIImageView *)resizeCtrl {
    if (!_resizeCtrl) {
//        CGRect frame = CGRectMake(self.bounds.size.width - CTRL_RADIUS,
//                                  self.bounds.size.height - CTRL_RADIUS,
//                                  CTRL_RADIUS * 2,
//                                  CTRL_RADIUS * 2);
//        _resizeCtrl = [[UIImageView alloc] initWithFrame:frame];
//        _resizeCtrl.backgroundColor = [UIColor brownColor];
//        _resizeCtrl.userInteractionEnabled = YES;
//        _resizeCtrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        [self addSubview:_resizeCtrl];
//
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeCtrlPan:)];
//        [_resizeCtrl addGestureRecognizer:panGesture];
    }
    return _resizeCtrl;
}

// //MARK: 翻转图片
//- (UIImageView *)reversalCtrl {
//    if (!_reversalCtrl) {
//        CGRect frame = CGRectMake(self.bounds.size.width - CTRL_RADIUS * 2,
//                                  0,
//                                  CTRL_RADIUS * 2,
//                                  CTRL_RADIUS * 2);
//        _reversalCtrl = [[UIImageView alloc] initWithFrame:frame];
//        _reversalCtrl.backgroundColor = [UIColor clearColor];
//        _reversalCtrl.userInteractionEnabled = YES;
//        _reversalCtrl.image = [UIImage imageNamed:@"flip_ic"];
//        [self addSubview:_reversalCtrl];
//
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reversalCtrlTap:)];
//        [_reversalCtrl addGestureRecognizer:tapGesture];
//
//    }
//
//    return _reversalCtrl;
//}
//
//- (void)reversalCtrlTap:(UITapGestureRecognizer *)gesture {
//    UIImageView *imageView = (UIImageView *)self.contentView;
//    imageView.image = [imageView.image flipHorizontal];
//}

- (UIImageView *)removeCtrl {
    if (!_removeCtrl) {
        CGRect frame = CGRectMake(0,
                                 0,
                                 CTRL_RADIUS * 2,
                                 CTRL_RADIUS * 2);
        _removeCtrl = [[UIImageView alloc] initWithFrame:frame];
        _removeCtrl.backgroundColor = [UIColor blackColor];
        _removeCtrl.userInteractionEnabled = YES;
        [self addSubview:_removeCtrl];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCtrlTap:)];
        [_removeCtrl addGestureRecognizer:tapGesture];
    }
    return _removeCtrl;
}

- (CGPoint)getRealOriginalPoint {
    return CGPointMake(self.bounds.size.width * self.originalPoint.x,
                       self.bounds.size.height * self.originalPoint.y);
}

- (CGFloat)initialAngle {
    if (self.ctrlType == GYStickerViewCtrlTypeOne) {
        _initialAngle = atan2(-(self.transformCtrl.center.y - [self getRealOriginalPoint].y),
                                  self.transformCtrl.center.x - [self getRealOriginalPoint].x);
    }
    if (self.ctrlType == GYStickerViewCtrlTypeTwo) {
        _initialAngle = atan2(-(self.rotateCtrl.center.y - [self getRealOriginalPoint].y),
                                  self.rotateCtrl.center.x - [self getRealOriginalPoint].x);
    }
    return _initialAngle;
}

//- (UIPinchGestureRecognizer *)pinchGesture {
//    if (!_pinchGesture) {
//        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
//        _pinchGesture.delegate = self;
//    }
//    return _pinchGesture;
//}

- (UIRotationGestureRecognizer *)rotateGesture {
    if (!_rotateGesture) {
        _rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
        _rotateGesture.delegate = self;
    }
    return _rotateGesture;
}

//- (UIPanGestureRecognizer *)panGesture {
//    if (!_panGesture) {
//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//        _panGesture.delegate = self;
//        _panGesture.minimumNumberOfTouches = 1;
//        _panGesture.maximumNumberOfTouches = 2;
//    }
//    return _panGesture;
//}


#pragma mark - 手势响应事件 --- 无控制图

- (void)rotate:(UIRotationGestureRecognizer *)gesture {
    NSUInteger touchCount = gesture.numberOfTouches;
    if (touchCount <= 1) {
        return;
    }

    CGPoint p1 = [gesture locationOfTouch: 0 inView:self];
    CGPoint p2 = [gesture locationOfTouch: 1 inView:self];
    CGPoint newCenter = CGPointMake((p1.x+p2.x)/2,(p1.y+p2.y)/2);
    self.originalPoint = CGPointMake(newCenter.x/self.bounds.size.width, newCenter.y/self.bounds.size.height);

    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;

    self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
    gesture.rotation = 0;

    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));

//    self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
//    gesture.rotation = 0;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {


    NSUInteger touchCount = gesture.numberOfTouches;
    if (touchCount <= 1) {
        return;
    }

    CGPoint p1 = [gesture locationOfTouch: 0 inView:self];
    CGPoint p2 = [gesture locationOfTouch: 1 inView:self];
    CGPoint newCenter = CGPointMake((p1.x+p2.x)/2,(p1.y+p2.y)/2);
    self.originalPoint = CGPointMake(newCenter.x/self.bounds.size.width, newCenter.y/self.bounds.size.height);


    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;


    CGFloat scale = gesture.scale;
    if (self.scaleMode == GYStickerViewScaleModeBounds) {
        self.bounds = CGRectMake(self.bounds.origin.x,
                                 self.bounds.origin.y,
                                 self.bounds.size.width * scale,
                                 self.bounds.size.height * scale);
        self.contentView.maskView.frame = self.contentView.bounds;

        NSLog(@"count:%lu",(unsigned long)self.contentView.subviews.count);
        if (self.contentView.subviews.count >= 1) {
            UIView *view = self.contentView.subviews.firstObject;
            CGPoint center = view.center;
            view.bounds = CGRectMake(view.bounds.origin.x,
                                     view.bounds.origin.y,
                                     view.bounds.size.width * scale,
                                     view.bounds.size.height * scale);
            view.center = CGPointMake(center.x * scale, center.y * scale);
        }

    } else {
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
        self.scaleValue = scale;
        [self fitCtrlScaleX:scale scaleY:scale];
    }

    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));


//    CGFloat scale = gesture.scale;
//    if (self.scaleMode == GYStickerViewScaleModeBounds) {
//        self.bounds = CGRectMake(self.bounds.origin.x,
//                                 self.bounds.origin.y,
//                                 self.bounds.size.width * scale,
//                                 self.bounds.size.height * scale);
//    } else {
//        self.transform = CGAffineTransformScale(self.transform, scale, scale);
//        [self fitCtrlScaleX:scale scaleY:scale];
//    }
    gesture.scale = 1;
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
//    CGPoint pt = [gesture translationInView:self.superview];
//    CGPoint newCenter = CGPointMake(gesture.view.center.x + pt.x,
//                                    gesture.view.center.y + pt.y);//    限制屏幕范围：
//    newCenter.y = MAX(gesture.view.frame.size.height / 2, newCenter.y);
//    newCenter.y = MIN(self.superview.frame.size.height - gesture.view.frame.size.height / 2, newCenter.y);
//    newCenter.x = MAX(gesture.view.frame.size.width / 2, newCenter.x);
//    newCenter.x = MIN(self.superview.frame.size.width - gesture.view.frame.size.width / 2, newCenter.x);
//    gesture.view.center = newCenter;
////    self.center = CGPointMake(self.center.x + pt.x , self.center.y + pt.y);
//    [gesture setTranslation:CGPointMake(0, 0) inView:self.superview];
//
////    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
////        __weak typeof(self) __weakMe = self;
////        [__weakMe mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.centerX.mas_equalTo(__weakMe.mas_centerX).offset(0);
////            make.centerY.mas_equalTo(__weakMe.mas_centerY).offset(0);
////        }];
////    }
    
    CGPoint pt = [gesture translationInView:self.superview];
    self.center = CGPointMake(self.center.x + pt.x , self.center.y + pt.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:self.superview];
}


#pragma mark - 手势响应事件 --- 一个控制图

- (void)transformCtrlPan:(UIPanGestureRecognizer *)gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = [self convertPoint:self.transformCtrl.center toView:self.superview];
        return;
    }

    CGPoint ctrlPoint = [gesture locationInView:self.superview];

    // scale
    [self scaleFitWithCtrlPoint:ctrlPoint];

    // rotate
    [self rotateAroundOPointWithCtrlPoint:ctrlPoint];

    self.lastCtrlPoint = ctrlPoint;
}


#pragma mark - 手势响应事件 --- 两个控制图

- (void)rotateCtrlPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = [self convertPoint:self.rotateCtrl.center toView:self.superview];
        return;
    }
    
    CGPoint ctrlPoint = [gesture locationInView:self.superview];
    [self rotateAroundOPointWithCtrlPoint:ctrlPoint];

    self.lastCtrlPoint = ctrlPoint;
}

- (void)resizeCtrlPan:(UIPanGestureRecognizer *)gesture {
    //等比缩放
    if (self.isScaleFit) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            self.lastCtrlPoint = [self convertPoint:self.resizeCtrl.center toView:self.superview];
            return;
        }

        CGPoint ctrlPoint = [gesture locationInView:self.superview];
        [self scaleFitWithCtrlPoint:ctrlPoint];

        self.lastCtrlPoint = ctrlPoint;
        return;
    }

    //自由缩放 ScaleModeBounds

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = self.resizeCtrl.center;
        return;
    }

    CGPoint ctrlPoint = [gesture locationInView:self];
    [self scaleFreeByChangeBoundsWithCtrlPoint:ctrlPoint ctrlCenter:self.resizeCtrl.center];

    self.lastCtrlPoint = ctrlPoint;
    return;


    //自由缩放 ScaleModeTransform
    /*if (gesture.state == UIGestureRecognizerStateBegan) {
        self.lastCtrlPoint = [self convertPoint:self.resizeCtrl.center toView:self.superview];
        return;
    }

    CGPoint ctrlPoint = [gesture locationInView:self.superview];
    [self scaleFreeByChangeTransformWithCtrlPoint:ctrlPoint ctrlCenter:self.resizeCtrl.center];

    self.lastCtrlPoint = ctrlPoint;*/
}


#pragma mark - 旋转 --- 实现

- (void)rotateAroundOPointWithCtrlPoint:(CGPoint)ctrlPoint {

    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x - (self.center.x - oPoint.x),
                              self.center.y - (self.center.y - oPoint.y));


    float angle = atan2(self.center.y - ctrlPoint.y, ctrlPoint.x - self.center.x);
    float lastAngle = atan2(self.center.y - self.lastCtrlPoint.y, self.lastCtrlPoint.x - self.center.x);
    angle = - angle + lastAngle;
    self.transform = CGAffineTransformRotate(self.transform, angle);


    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));

}


#pragma mark - 缩放 --- 实现

/* 等比缩放 */
- (void)scaleFitWithCtrlPoint:(CGPoint)ctrlPoint {
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;


    CGFloat preDistance = [self distanceWithStartPoint:self.center endPoint:self.lastCtrlPoint];
    CGFloat newDistance = [self distanceWithStartPoint:self.center endPoint:ctrlPoint];
    CGFloat scale = newDistance / preDistance;
    CGFloat currentScale = [[self.layer valueForKeyPath:@"transform.scale"] floatValue];
    
    scale = MIN(scale, self.maxScale / currentScale);
    scale = MAX(scale, self.minScale / currentScale);
    if (self.scaleMode == GYStickerViewScaleModeBounds) {
        self.bounds = CGRectMake(self.bounds.origin.x,
                                 self.bounds.origin.y,
                                 self.bounds.size.width * scale,
                                 self.bounds.size.height * scale);
        [self updateCtrlPoint];
    } else {
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
        self.scaleValue = scale;
        [self fitCtrlScaleX:scale scaleY:scale];
    }



    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
}

/* 自由缩放 ScaleModeBounds */
- (void)scaleFreeByChangeBoundsWithCtrlPoint:(CGPoint)ctrlPoint ctrlCenter:(CGPoint)ctrlCenter {
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;


    CGFloat cX = ctrlPoint.x - self.lastCtrlPoint.x;
    CGFloat cY = ctrlPoint.y - self.lastCtrlPoint.y;

    if ([self getRealOriginalPoint].y == ctrlCenter.y) {
        cY = 0;
    }
    if ([self getRealOriginalPoint].x == ctrlCenter.x) {
        cX = 0;
    }

    CGFloat width = self.bounds.size.width + cX;
    CGFloat height = self.bounds.size.height + cY;
    if (width > 0 && height > 0) {
        self.bounds = CGRectMake(self.bounds.origin.x,
                                 self.bounds.origin.y,
                                 self.bounds.size.width + cX,
                                 self.bounds.size.height + cY);
        [self updateCtrlPoint];
    }


    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
}

/* 自由缩放 ScaleModeTransform */
/*- (void)scaleFreeByChangeTransformWithCtrlPoint:(CGPoint)ctrlPoint ctrlCenter:(CGPoint)ctrlCenter {
    CGPoint oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = oPoint;


    CGFloat cX = ctrlPoint.x - self.lastCtrlPoint.x;
    CGFloat cY = ctrlPoint.y - self.lastCtrlPoint.y;
    CGFloat preDistanceX = self.lastCtrlPoint.x - self.center.x;
    CGFloat preDistanceY = self.lastCtrlPoint.y - self.center.y;
    CGFloat scaleX = cX / preDistanceX + 1;
    CGFloat scaleY = cY / preDistanceY + 1;

    self.transform = CGAffineTransformScale(self.transform, scaleX, scaleY);
    [self fitCtrlScaleX:scaleX scaleY:scaleY];


    oPoint = [self convertPoint:[self getRealOriginalPoint] toView:self.superview];
    self.center = CGPointMake(self.center.x + (self.center.x - oPoint.x),
                              self.center.y + (self.center.y - oPoint.y));
}*/

/* 控制图保持大小不变 */
- (void)fitCtrlScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
//    self.reversalCtrl.transform = CGAffineTransformScale(self.reversalCtrl.transform, 1/scaleX, 1/scaleY);
    self.removeCtrl.transform = CGAffineTransformScale(self.removeCtrl.transform, 1/scaleX, 1/scaleY);
    self.transformCtrl.transform = CGAffineTransformScale(self.transformCtrl.transform, 1/scaleX, 1/scaleY);
    self.resizeCtrl.transform = CGAffineTransformScale(self.resizeCtrl.transform, 1/scaleX, 1/scaleY);
    self.rotateCtrl.transform = CGAffineTransformScale(self.rotateCtrl.transform, 1/scaleX, 1/scaleY);
    self.oCtrlPointView.transform = CGAffineTransformScale(self.oCtrlPointView.transform, 1/scaleX, 1/scaleY);
}

- (void)fitCtrlScale {
    
    if (self.scaleValue != 0) {
        self.removeCtrl.transform = CGAffineTransformScale(self.removeCtrl.transform, 1/self.scaleValue, 1/self.scaleValue);
        self.transformCtrl.transform = CGAffineTransformScale(self.transformCtrl.transform, 1/self.scaleValue, 1/self.scaleValue);
        self.resizeCtrl.transform = CGAffineTransformScale(self.resizeCtrl.transform, 1/self.scaleValue, 1/self.scaleValue);
        self.rotateCtrl.transform = CGAffineTransformScale(self.rotateCtrl.transform, 1/self.scaleValue, 1/self.scaleValue);
        self.oCtrlPointView.transform = CGAffineTransformScale(self.oCtrlPointView.transform, 1/self.scaleValue, 1/self.scaleValue);
    }
}

#pragma mark - 移除StickerView

- (void)removeCtrlTap:(UITapGestureRecognizer *)gesture {
//    [self removeFromSuperview];
    __weak __typeof__(self) __weakSelf = self;
    if (_removeEventBlock) {
        _removeEventBlock(__weakSelf.tag);
    }
}


#pragma mark - UIGestureRecognizerDelegate

/* 同时触发多个手势 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/* 控制手势是否触发 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer.view == self) {
        CGPoint p = [touch locationInView:self];
        if (CGRectContainsPoint(self.transformCtrl.frame, p) ||
            CGRectContainsPoint(self.rotateCtrl.frame, p) ||
            CGRectContainsPoint(self.resizeCtrl.frame, p)) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - 重写hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        int count = (int)self.subviews.count;
        for (int i = count - 1; i >= 0; i--) {
            UIView *subView = self.subviews[i];
            CGPoint p = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, p)) {
                if (subView.isHidden) {
                    continue;
                }
                return subView;
            }
        }
    }
    return view;
}

#pragma mark - Actions

- (void)showOriginalPoint:(BOOL)b {
    if (self.ctrlType == GYStickerViewCtrlTypeGesture) {
        return;
    }
    if (!self.oCtrlPointView && b) {
        self.oCtrlPointView = [[UIView alloc] initWithFrame:CGRectMake([self getRealOriginalPoint].x - 4, [self getRealOriginalPoint].y - 4, 8, 8)];
        self.oCtrlPointView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.oCtrlPointView];
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.oCtrlPointView.bounds];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor redColor].CGColor;
        layer.path = path.CGPath;
        [self.oCtrlPointView.layer addSublayer:layer];
        self.oCtrlPointView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    self.oCtrlPointView.hidden = !b;
}

- (void)updateCtrlPoint {
    if (self.oCtrlPointView) {
        self.oCtrlPointView.frame = CGRectMake([self getRealOriginalPoint].x - 4, [self getRealOriginalPoint].y - 4, 8, 8);
    }
}

- (void)showRemoveCtrl:(BOOL)b {
    self.removeCtrl.hidden = !b;
    self.isHiddenRemoveCtrl = !b;
}

/* 计算两点间距 */
- (CGFloat)distanceWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    CGFloat x = start.x - end.x;
    CGFloat y = start.y - end.y;
    return sqrt(x * x + y * y);
}


#pragma mark - 设置控制图图片

- (void)setTransformCtrlImage:(UIImage *)image {
    self.transformCtrl.backgroundColor = [UIColor clearColor];
    self.transformCtrl.image = image;
}

- (void)setResizeCtrlImage:(UIImage *)resizeImage rotateCtrlImage:(UIImage *)rotateImage {
    self.resizeCtrl.backgroundColor = [UIColor clearColor];
    self.rotateCtrl.backgroundColor = [UIColor clearColor];
    self.resizeCtrl.image = resizeImage;
    self.rotateCtrl.image = rotateImage;
}

- (void)rotateCtrlImage:(UIImage *)rotateImage {
    self.rotateCtrl.backgroundColor = [UIColor clearColor];
    self.rotateCtrl.image = rotateImage;
}


- (void)setRemoveCtrlImage:(UIImage *)image {
    self.removeCtrl.backgroundColor = [UIColor clearColor];
    self.removeCtrl.image = image;
}

- (void)hiddenCtrls {
    self.rotateCtrl.hidden = YES;
//    self.removeCtrl.hidden = YES;
//    self.transformCtrl.hidden = YES;
//    self.border.hidden = YES;
//    self.isSelect = NO;
//    self.reversalCtrl.hidden = YES;
}

- (void)showCtrls {
    self.rotateCtrl.hidden = NO;
//    self.removeCtrl.hidden = self.isHiddenRemoveCtrl;
//    self.transformCtrl.hidden = NO;
//    self.border.hidden = NO;
//    self.isSelect = YES;
//    self.reversalCtrl.hidden = NO;
}

@end
