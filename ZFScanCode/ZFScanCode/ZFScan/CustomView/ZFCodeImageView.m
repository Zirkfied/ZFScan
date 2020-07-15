//
//  ZFCodeImageView.m
//  ZFScanCode
//
//  Created by apple on 2020/7/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ZFCodeImageView.h"

@interface ZFCodeImageView()

/** 长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGestureRecognizer;

@end

@implementation ZFCodeImageView

- (void)commonInit{
    self.canLongPress = YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

/**
 *  长按Action
 */
- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state != UIGestureRecognizerStateBegan) {
        //长按手势只会响应一次
        return;
    }
    
    UIImageView * imageView = (UIImageView *)sender.view;
    
    //创建上下文
    CIContext * context = [[CIContext alloc] init];
    //创建一个探测器
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    //直接开始识别图片,获取图片特征
    CIImage * ciImage = [[CIImage alloc] initWithImage:imageView.image];
    NSArray * features = [detector featuresInImage:ciImage];
    CIQRCodeFeature * codeFeature = (CIQRCodeFeature *)features.firstObject;

    NSLog(@"当前内容：%@", codeFeature.messageString);
    
    if ([self.delegate respondsToSelector:@selector(longPressGestureRecognizerInImageView:code:)]) {
        [self.delegate longPressGestureRecognizerInImageView:self code:codeFeature.messageString];
    }
}


#pragma mark - 懒加载

- (void)setCanLongPress:(BOOL)canLongPress{
    self.userInteractionEnabled = canLongPress;
    
    if (self.userInteractionEnabled == YES) {
        //长按手势
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}

@end
