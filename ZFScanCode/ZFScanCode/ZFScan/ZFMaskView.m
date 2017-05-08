//
//  ZFMaskView.m
//  ScanBarCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFMaskView.h"
#import "ZFConst.h"

@interface ZFMaskView()

@property (nonatomic, strong) UIImageView * scanLineImg;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UILabel * hintLabel;
@property (nonatomic, strong) UIImageView * topLeftImg;
@property (nonatomic, strong) UIImageView * topRightImg;
@property (nonatomic, strong) UIImageView * bottomLeftImg;
@property (nonatomic, strong) UIImageView * bottomRightImg;

@property (nonatomic, strong) UIBezierPath * bezier;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;

/** 第一次旋转 */
@property (nonatomic, assign) CGFloat isFirstTransition;

@end

@implementation ZFMaskView

- (void)commonInit{
    _isFirstTransition = YES;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self addUI];
    }
    
    return self;
}

/**
 *  添加UI
 */
- (void)addUI{
    //遮罩层
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    self.maskView.layer.mask = [self maskLayer];
    [self addSubview:self.maskView];
    
    //提示框
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.text = @"将 二维码/条形码 放入框内中央，即可自动扫描";
    self.hintLabel.textColor = ZFFicelle;
    self.hintLabel.numberOfLines = 0;
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.hintLabel];
    
    //边框
    UIImage * topLeft = [UIImage imageNamed:@"ScanQR1"];
    UIImage * topRight = [UIImage imageNamed:@"ScanQR2"];
    UIImage * bottomLeft = [UIImage imageNamed:@"ScanQR3"];
    UIImage * bottomRight = [UIImage imageNamed:@"ScanQR4"];
    
    //左上
    self.topLeftImg = [[UIImageView alloc] init];
    self.topLeftImg.image = topLeft;
    [self addSubview:self.topLeftImg];
    
    //右上
    self.topRightImg = [[UIImageView alloc] init];
    self.topRightImg.image = topRight;
    [self addSubview:self.topRightImg];
    
    //左下
    self.bottomLeftImg = [[UIImageView alloc] init];
    self.bottomLeftImg.image = bottomLeft;
    [self addSubview:self.bottomLeftImg];
    
    //右下
    self.bottomRightImg = [[UIImageView alloc] init];
    self.bottomRightImg.image = bottomRight;
    [self addSubview:self.bottomRightImg];
    
    //扫描线
    UIImage * scanLine = [UIImage imageNamed:@"QRCodeScanLine"];
    self.scanLineImg = [[UIImageView alloc] init];
    self.scanLineImg.image = scanLine;
    self.scanLineImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.scanLineImg];
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
    
    //设置frame
    //横屏
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        
        //提示框
        self.hintLabel.frame = CGRectMake(0, 0, self.frame.size.height * ZFScanRatio, 60);
        self.hintLabel.center = CGPointMake(self.maskView.center.x, self.maskView.center.y + (self.frame.size.height * ZFScanRatio) * 0.5 + 25);
        //左上
        self.topLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.topLeftImg.image.size.width, self.topLeftImg.image.size.height);
        //右上
        self.topRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.topRightImg.image.size.width + self.frame.size.height * ZFScanRatio, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.topRightImg.image.size.width, self.topRightImg.image.size.height);
        //左下
        self.bottomLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.bottomLeftImg.image.size.height + self.frame.size.height * ZFScanRatio, self.bottomLeftImg.image.size.width, self.bottomLeftImg.image.size.height);
        //右下
        self.bottomRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.bottomRightImg.image.size.width + self.frame.size.height * ZFScanRatio, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.bottomRightImg.image.size.width + self.frame.size.height * ZFScanRatio, self.bottomRightImg.image.size.width, self.bottomRightImg.image.size.height);
        //扫描线
        self.scanLineImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.frame.size.height * ZFScanRatio, scanLine.size.height);
        
    //竖屏
    }else{
        //提示框
        self.hintLabel.frame = CGRectMake(0, 0, self.frame.size.width * ZFScanRatio, 60);
        self.hintLabel.center = CGPointMake(self.maskView.center.x, 120);
        
        //左上
        self.topLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, topLeft.size.width, topLeft.size.height);
        //右上
        self.topRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5 - topRight.size.width + self.frame.size.width * ZFScanRatio, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, topRight.size.width, topRight.size.height);
        //左下
        self.bottomLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5 - bottomLeft.size.height + self.frame.size.width * ZFScanRatio, bottomLeft.size.width, bottomLeft.size.height);
        //右下
        self.bottomRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5 - bottomRight.size.width + self.frame.size.width * ZFScanRatio, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5 - bottomRight.size.width + self.frame.size.width * ZFScanRatio, bottomRight.size.width, bottomRight.size.height);
        //扫描线
        self.scanLineImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, scanLine.size.height);
    }
}

/**
 *  动画
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    
    //第一次旋转
    if (_isFirstTransition) {
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y - self.frame.size.height * ZFScanRatio * 0.5 + self.scanLineImg.image.size.height * 0.5))];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y + self.frame.size.height * ZFScanRatio * 0.5 - self.scanLineImg.image.size.height * 0.5))];
            
        //竖屏
        }else{
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y - self.frame.size.width * ZFScanRatio * 0.5 + self.scanLineImg.image.size.height * 0.5))];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.width * ZFScanRatio * 0.5 - self.scanLineImg.image.size.height * 0.5)];
        }
        
        _isFirstTransition = NO;
        
        //非第一次旋转
    }else{
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.scanLineImg.frame.origin.y + self.frame.size.width * ZFScanRatio - self.scanLineImg.frame.size.height * 0.5)];
            
            
            //竖屏
        }else{
            
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.scanLineImg.frame.origin.y + self.frame.size.height * ZFScanRatio - self.scanLineImg.frame.size.height * 0.5)];
        }
    }
    
    return animation;
}

/**
 *  遮罩层bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)maskPath{
    self.bezier = nil;
    self.bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    //第一次旋转
    if (_isFirstTransition) {
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.frame.size.height * ZFScanRatio, self.frame.size.height * ZFScanRatio)] bezierPathByReversingPath]];
            
            //竖屏
        }else{
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, self.frame.size.width * ZFScanRatio)] bezierPathByReversingPath]];
        }
    
    //非第一次旋转
    }else{
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, self.frame.size.width * ZFScanRatio)] bezierPathByReversingPath]];
            
            //竖屏
        }else{
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.frame.size.height * ZFScanRatio, self.frame.size.height * ZFScanRatio)] bezierPathByReversingPath]];
        }
    }
    
    return self.bezier;
}

/**
 *  遮罩层ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)maskLayer{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [self maskPath].CGPath;
    
    return self.shapeLayer;
}

#pragma mark - public method

/**
 *  重设UI的frame
 */
- (void)resetFrame{
    self.maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.maskView.layer.mask = [self maskLayer];
    
    //横屏(转前是横屏，转后才是竖屏)
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        
        self.hintLabel.frame = CGRectMake(0, 0, self.frame.size.width * ZFScanRatio, 60);
        self.hintLabel.center = CGPointMake(self.maskView.center.x, 120);
        
        self.topLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.topLeftImg.image.size.width, self.topLeftImg.image.size.height);
        
        self.topRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5 - self.topRightImg.image.size.width + self.frame.size.width * ZFScanRatio, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.topRightImg.image.size.width, self.topRightImg.image.size.height);
        
        self.bottomLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5 - self.bottomLeftImg.image.size.height + self.frame.size.width * ZFScanRatio, self.bottomLeftImg.image.size.width, self.bottomLeftImg.image.size.height);
        
        self.bottomRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5 - self.bottomRightImg.image.size.width + self.frame.size.width * ZFScanRatio, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5 - self.bottomRightImg.image.size.width + self.frame.size.width * ZFScanRatio, self.bottomRightImg.image.size.width, self.bottomRightImg.image.size.height);
        
        self.scanLineImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, self.scanLineImg.image.size.height);
        [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
        
    //竖屏(转前是竖屏，转后才是横屏)
    }else{
        self.hintLabel.frame = CGRectMake(0, 0, self.frame.size.height * ZFScanRatio, 60);
        self.hintLabel.center = CGPointMake(self.maskView.center.x, self.maskView.center.y + (self.frame.size.height * ZFScanRatio) * 0.5 + 25);
        
        self.topLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.topLeftImg.image.size.width, self.topLeftImg.image.size.height);
        
        self.topRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.topRightImg.image.size.width + self.frame.size.height * ZFScanRatio, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.topRightImg.image.size.width, self.topRightImg.image.size.height);
        
        self.bottomLeftImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.bottomLeftImg.image.size.height + self.frame.size.height * ZFScanRatio, self.bottomLeftImg.image.size.width, self.bottomLeftImg.image.size.height);
        
        self.bottomRightImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.bottomRightImg.image.size.width + self.frame.size.height * ZFScanRatio, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5 - self.bottomRightImg.image.size.width + self.frame.size.height * ZFScanRatio, self.bottomRightImg.image.size.width, self.bottomRightImg.image.size.height);

        self.scanLineImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.frame.size.height * ZFScanRatio, self.scanLineImg.image.size.height);
        [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
    }
}

/**
 *  移除动画
 */
- (void)removeAnimation{
    [self.scanLineImg.layer removeAllAnimations];
}

#pragma mark - 重写setter, getter方法

- (CGFloat)scanBezierStartXPos{
    return (self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5;
}

@end
