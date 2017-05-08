//
//  ZFMaskView.h
//  ScanBarCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFMaskView : UIView

#pragma mark - readonly(只读)

@property (nonatomic, assign, readonly) CGFloat scanBezierStartXPos;

#pragma mark - public method

/**
 *  重设UI的frame
 */
- (void)resetFrame;

/**
 *  移除动画
 */
- (void)removeAnimation;

@end
