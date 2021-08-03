#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYStickerViewScaleMode) {
    GYStickerViewScaleModeBounds,    //通过改变self.bounds达到缩放效果
    GYStickerViewScaleModeTransform  //通过改变self.transform达到缩放效果
};

typedef NS_ENUM(NSInteger, GYStickerViewCtrlType) {
    GYStickerViewCtrlTypeGesture,    //手势,无控制图，双指控制旋转和缩放
    GYStickerViewCtrlTypeOne,        //一个控制图，同时控制旋转和缩放,
    GYStickerViewCtrlTypeTwo         //两个控制图，一个控制旋转，一个控制缩放
};

typedef void(^RemoveStickerEvent)(NSInteger viewTag);
typedef void(^TapEdit)(int fontIndex, NSString *fontName, int colorIndex, NSString *colorName, float textStickerAlpha, float textStrokeWidth, NSString *textStrokeColorName, int textStrokeColorIndex, BOOL underscore, int textAlignment, int spacing, float contentAlpha, NSString *contentColorName, int contentColorIndex);
typedef void(^FlowerEdit)(NSInteger viewTag);
typedef void(^TapTwoEdit)(NSInteger tag);

@interface GYStickerView : UIView
/**
 CtrlTypeOne
 变换控制图
 */
@property (strong, nonatomic) UIImageView *transformCtrl;//同时控制旋转和缩放，右下角

/**
 CtrlTypeTwo
 变换控制图
 */
@property (strong, nonatomic) UIImageView *rotateCtrl;//控制旋转，右上角
@property (strong, nonatomic) UIImageView *resizeCtrl;//控制缩放，右下角

/**
 反转图片
 */
@property (strong, nonatomic) UIImageView *reversalCtrl;

/**
 移除StickerView
 */
@property (strong, nonatomic) UIImageView *removeCtrl;

/**
 参考点视图
 */
@property (strong, nonatomic) UIView *oCtrlPointView;

/**
 旋转的初始水平角度
 */
@property (nonatomic) CGFloat initialAngle;


/**
 记录上一个控制点
 */
@property (nonatomic) CGPoint lastCtrlPoint;


/**
 self的手势
 */
@property (nonatomic) UIPinchGestureRecognizer *pinchGesture;     //捏合手势
@property (nonatomic) UIRotationGestureRecognizer *rotateGesture; //旋转手势
@property (nonatomic) UIPanGestureRecognizer *panGesture;         //拖动手势

///最大缩放比例,默认为2
@property (nonatomic, assign) CGFloat maxScale;
///最小缩放比例,默认为1
@property (nonatomic, assign) CGFloat minScale;
    
@property (nonatomic, strong) CAShapeLayer *border;

@property (nonatomic, assign) int fontIndex;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) int colorIndex;
@property (nonatomic, copy) NSString *colorName;

@property (nonatomic, assign) float textStickerAlpha;

@property (nonatomic, assign) float textStrokeWidth;
@property (nonatomic, copy) NSString *textStrokeColorName;
@property (nonatomic, assign) int textStrokeColorIndex;

@property (nonatomic, assign) BOOL underscore;
@property (nonatomic, assign) int textAlignment;
@property (nonatomic, assign) int spacing;

@property (nonatomic, assign) float contentAlpha;
@property (nonatomic, copy) NSString *contentColorName;
@property (nonatomic, assign) int contentColorIndex;

@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) UIView *boradView;
    
- (void)changeContentView:(UIView *)contentView;

@property (nonatomic, assign) BOOL isFlowersSticker;
@property (nonatomic, assign) BOOL isGifSticker;
@property (nonatomic, copy) NSString *gifName;
    
/**
 是否需要点击
 */
@property (nonatomic, assign) BOOL isEdit;

/**
 移除sticker事件
 */
@property (nonatomic, copy) RemoveStickerEvent removeEventBlock;

/**
 * 单击 调用编辑
 */
@property (nonatomic, copy) TapEdit editBlock;
@property (nonatomic, copy) TapTwoEdit editTextBlock;

/**
 需要添加到StickerView的内容，如:UIView, UITextView, UIImageView等
 */
@property (strong, nonatomic) UIView *contentView;



/**
 参考点(比例)，不设置默认为中心点 CGPoint(0.5, 0.5)
 范围：x: 0 --- 1
      y: 0 --- 1

 提示：可以超出范围，设置参考点在self外面
 */
@property (nonatomic) CGPoint originalPoint;


/**
 等比缩放 : YES
 自由缩放 : NO

 注意：1、仅适用于CtrlTypeTwo的缩放，默认YES.  其他CtrlType也属于等比缩放
      2、与ScaleModeTransform不兼容，待完善
 */
@property (nonatomic, getter=isScaleFit) BOOL scaleFit;


@property (nonatomic) GYStickerViewScaleMode scaleMode;
@property (nonatomic) GYStickerViewCtrlType ctrlType;
@property (nonatomic, assign) double scaleValue;


/**
 初始化StickerView
 */
- (instancetype)initWithContentView:(UIView *)contentView;

/**
 显示参考点，默认不显示

 注意：CtrlTypeGesture 仅支持中心点，该方法无效
 */
- (void)showOriginalPoint:(BOOL)b;

/**
 显示左上角移除按钮，默认显示
 */
- (void)showRemoveCtrl:(BOOL)b;

/**
 显示右上角翻转图片
 */
- (void)showReversalCtrl:(BOOL)b;


/**
 设置控制图片
 */
- (void)setTransformCtrlImage:(UIImage *)image;// CtrlTypeOne
- (void)rotateCtrlImage:(UIImage *)rotateImage;
- (void)setResizeCtrlImage:(UIImage *)resizeImage rotateCtrlImage:(UIImage *)rotateImage;//CtrlTypeTwo
- (void)setRemoveCtrlImage:(UIImage *)image;

- (void)hiddenCtrls;
- (void)showCtrls;
- (void)fitCtrlScale;

@end
