//
//  ZFScanViewController.m
//  ZFScan
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFMaskView.h"
#import <ImageIO/ImageIO.h>

@interface ZFScanViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
/** 遮罩层 */
@property (nonatomic, strong) ZFMaskView * maskView;
/** 取消按钮 */
@property (nonatomic, strong) UIButton * cancelButton;

@end

@implementation ZFScanViewController

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    
    return _metadataObjectTypes;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.maskView removeAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self capture];
    [self addUI];
}

/**
 *  添加遮罩层
 */
- (void)addUI{
    self.maskView = [[ZFMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.maskView];
    
    //取消按钮
    CGFloat cancel_width = 100;
    CGFloat cancel_height = 35;
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(0, 0, cancel_width, cancel_height);
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTintColor:ZFWhite];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.cancelButton];
    
    //横屏
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        
        self.cancelButton.center = CGPointMake(SCREEN_WIDTH - (self.view.center.x - SCREEN_HEIGHT * ZFScanRatio * 0.5) * 0.5, self.view.center.y);
    
    //竖屏
    }else{
        self.cancelButton.frame = CGRectMake((CGRectGetWidth(self.maskView.frame) - cancel_width) / 2, CGRectGetHeight(self.maskView.frame) - cancel_height - 30, cancel_width, cancel_height);
        
    }
}

/**
 *  扫描初始化
 */
- (void)capture{
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //创建视频输出流
    AVCaptureVideoDataOutput * videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    //设置代理在子线程里刷新
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [videoDataOutput setSampleBufferDelegate:self queue:queue];
    //设置像素格式
    videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self.session addInput:input];
    [self.session addOutput:metadataOutput];
    [self.session addOutput:videoDataOutput];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.previewLayer];
    
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
    
    //开始捕获
    [self.session startRunning];
    
    //先进行判断是否支持控制对焦
//    if (self.device.isFocusPointOfInterestSupported) {
//        NSError *error = nil;
//        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问
//        [self.device lockForConfiguration:&error];
//        [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
//        //操作完成后，记得进行unlock。
//        [self.device unlockForConfiguration];
//    }
    
    if (self.device.isExposurePointOfInterestSupported) {
        NSError *error = nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问
        [self.device lockForConfiguration:&error];
        [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        //操作完成后，记得进行unlock。
        [self.device unlockForConfiguration];
    }

    if (self.device.isAutoFocusRangeRestrictionSupported) {
        NSError *error = nil;
        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问
        [self.device lockForConfiguration:&error];
        [self.device setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
        //操作完成后，记得进行unlock。
        [self.device unlockForConfiguration];
    }    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        self.returnScanBarCodeValue(metadataObject.stringValue);
        
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if (brightnessValue < 3.3) {
        if (self.device.isExposurePointOfInterestSupported) {
            NSError *error = nil;
            //对cameraDevice进行操作前，需要先锁定，防止其他线程访问
            [self.device lockForConfiguration:&error];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
            //操作完成后，记得进行unlock。
            [self.device unlockForConfiguration];
        }
        
    }else if (brightnessValue >= 3.3){
        if (self.device.isExposurePointOfInterestSupported) {
            NSError *error = nil;
            //对cameraDevice进行操作前，需要先锁定，防止其他线程访问
            [self.device lockForConfiguration:&error];
            [self.device setExposureMode:AVCaptureExposureModeLocked];
            //操作完成后，记得进行unlock。
            [self.device unlockForConfiguration];
        }
    }
}

#pragma mark - 取消事件

/**
 * 取消事件
 */
- (void)cancelAction{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 横竖屏适配

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    self.maskView.frame = CGRectMake(0, 0, size.width, size.height);
    self.previewLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [self.maskView resetFrame];
    
    //横屏
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
 
      self.cancelButton.frame = CGRectMake((CGRectGetWidth(self.maskView.frame) - CGRectGetWidth(self.cancelButton.frame)) / 2, CGRectGetHeight(self.maskView.frame) - CGRectGetHeight(self.cancelButton.frame) - 30, CGRectGetWidth(self.cancelButton.frame), CGRectGetHeight(self.cancelButton.frame));
    
    //竖屏
    }else{
        self.cancelButton.center = CGPointMake(SCREEN_HEIGHT - (self.view.center.y - SCREEN_WIDTH * ZFScanRatio * 0.5) * 0.5, self.view.center.x);
    }
}

@end
