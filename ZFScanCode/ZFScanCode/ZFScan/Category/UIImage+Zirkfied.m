//
//  UIImage+Zirkfied.m
//  ZFCodeDemo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIImage+Zirkfied.h"
#import "UIColor+Zirkfied.h"

@implementation UIImage (Zirkfied)

#pragma mark - 初始化

+ (instancetype)imageCodeString:(NSString *)string size:(CGFloat)size color:(UIColor *)color pattern:(kCodePattern)pattern iconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize{
    return [[self alloc] initWithString:string size:size color:color pattern:pattern iconImage:iconImage iconImageSize:iconImageSize];
}

#pragma mark - 读取二维码内容

- (NSString *)readCode{
    //image转成data
    NSData * imageData = UIImagePNGRepresentation(self);
    
    //直接开始识别图片,获取图片特征
    CIImage * ciImage = [[CIImage alloc] initWithData:imageData];
    //创建一个探测器
    CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    NSArray * features = [detector featuresInImage:ciImage];
    CIQRCodeFeature * codeFeature = (CIQRCodeFeature *)features.firstObject;
    return codeFeature.messageString;
}

#pragma mark - 私有方法

- (instancetype)initWithString:(NSString *)string size:(CGFloat)size color:(UIColor *)color pattern:(kCodePattern)pattern iconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize{
    self = [super init];
    if (self) {
        CIImage * ciimage = [self createOutputImageForString:string pattern:pattern];
        UIImage * qrcode = [self creatNonInterpolatedUIImageForCIImage:ciimage size:size];
        UIImage * resultImage = [self imageBlackToTransparent:qrcode withRed:color.red andGreen:color.green andBlue:color.blue];
        self = iconImage == nil ? resultImage : [self addIconImage:iconImage iconImageSize:iconImageSize resultImage:resultImage];
    }
    return self;
}

- (CIImage *)createOutputImageForString:(NSString *)string pattern:(kCodePattern)pattern{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //创建filter
    CIFilter * filter = nil;
    if (pattern == kCodePatternBarCode) {
        filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    }else if (pattern == kCodePatternQRCode){
        filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    }
    
    // 设置内容和纠错级别
    [filter setValue:data forKey:@"inputMessage"];
    
    if (pattern == kCodePatternQRCode) {
        [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    }

    // 返回CIImage
    return filter.outputImage;
}

- (UIImage *)creatNonInterpolatedUIImageForCIImage:(CIImage *)image size:(CGFloat)size{
    //照片范围
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    //创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 二维码颜色填充并转为透明背景

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark - 二维码中间添加icon图片

- (UIImage *)addIconImage:(UIImage *)iconImage iconImageSize:(CGFloat)iconImageSize resultImage:(UIImage *)resultImage{
    // 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(resultImage.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [resultImage drawInRect:CGRectMake(0, 0, resultImage.size.width, resultImage.size.height)];
    // 再把小图片画上去
    CGFloat iconImage_width = iconImageSize;
    CGFloat iconImage_height = iconImage_width;
    CGFloat iconImage_xPos = (resultImage.size.width - iconImage_width) * 0.5;
    CGFloat iconImage_yPos = (resultImage.size.height - iconImage_height) * 0.5;
    [iconImage drawInRect:CGRectMake(iconImage_xPos, iconImage_yPos, iconImage_width, iconImage_height)];
    
    // 获取当前画得的这张图片
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    //返回二维码图像
    return qrImage;
}

@end
