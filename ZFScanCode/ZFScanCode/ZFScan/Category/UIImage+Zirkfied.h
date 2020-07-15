//
//  UIImage+Zirkfied.h
//  ZFCodeDemo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kCodePatternBarCode = 0,//条形码，一维码
    kCodePatternQRCode = 1//二维码
}kCodePattern;

@interface UIImage (Zirkfied)

/**
 *  生成二维码
 *
 *  @param string           二维码字符串
 *  @param size             图片宽度 height = width
 *  @param color            二维码颜色
 *  @param pattern          code类型
 *  @param iconImage        中间图标image，如果不需要，则填nil
 *  @param iconImageSize    中间图标图片宽度 height = width，无图片时则默认为0.f
 *
 *  @return self
 */
+ (instancetype)imageCodeString:(NSString *)string size:(CGFloat)size color:(UIColor *)color pattern:(kCodePattern)pattern iconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize;

/**
 *  读取二维码内容
 *
 *  @return 返回内容
 */
- (NSString *)readCode;

@end
