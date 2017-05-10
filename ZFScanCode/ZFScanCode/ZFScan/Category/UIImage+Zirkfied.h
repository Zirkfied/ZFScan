//
//  UIImage+Zirkfied.h
//  ZFCodeDemo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kCodePatternForBarCode = 0,//条形码，一维码
    kCodePatternForQRCode = 1//二维码
}kCodePattern;

@interface UIImage (Zirkfied)

/**
 *  生成二维码
 *
 *  @param string  二维码字符串
 *  @param size    图片宽度 height = width
 *  @param color   二维码颜色
 *  @param pattern code类型
 *
 *  @return self
 */
+ (instancetype)imageForCodeString:(NSString *)string size:(CGFloat)size color:(UIColor *)color pattern:(kCodePattern)pattern;

@end
