//
//  ReadCodeViewController.m
//  ZFScanCode
//
//  Created by apple on 2020/7/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ReadCodeViewController.h"
#import "ZFConst.h"

@interface ReadCodeViewController ()<ZFCodeImageViewDelegate>

/** 二维码ImageView */
@property (nonatomic, strong) ZFCodeImageView * QRCodeImageView;
/** 提示Label */
@property (nonatomic, strong) UILabel * hintLabel;
/** 显示内容Label */
@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation ReadCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZFWhite;

    //二维码内容
    NSString * QRCodeString = @"我是二维码";
    
    //二维码
    CGFloat QRCode_width = 200;
    CGFloat QRCode_height = 200;
    CGFloat QRCode_xPos = (SCREEN_WIDTH - QRCode_width) / 2;
    CGFloat QRCode_yPos = 100;
    
    self.QRCodeImageView = [[ZFCodeImageView alloc] initWithFrame:CGRectMake(QRCode_xPos, QRCode_yPos, QRCode_width, QRCode_height)];
    self.QRCodeImageView.image = [UIImage imageCodeString:QRCodeString size:self.QRCodeImageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternQRCode iconImage:nil iconImageSize:0.f];
    self.QRCodeImageView.delegate = self;
    [self.view addSubview:self.QRCodeImageView];
    
    //提示Label
    CGFloat hintLabel_xPos = 0.f;
    CGFloat hintLabel_yPos = CGRectGetMaxY(self.QRCodeImageView.frame) + 50.f;
    CGFloat hintLabel_width = SCREEN_WIDTH;
    CGFloat hintLabel_height = 35.f;
    
    self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(hintLabel_xPos, hintLabel_yPos, hintLabel_width, hintLabel_height)];
    self.hintLabel.text = @"长按二维码识别";
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.textColor = ZFGray;
    [self.view addSubview:self.hintLabel];
    
    //显示内容Label
    CGFloat contentLabel_xPos = 0.f;
    CGFloat contentLabel_yPos = CGRectGetMaxY(self.hintLabel.frame) + 50.f;
    CGFloat contentLabel_width = SCREEN_WIDTH;
    CGFloat contentLabel_height = 40.f;
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel_xPos, contentLabel_yPos, contentLabel_width, contentLabel_height)];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:20.f];
    [self.view addSubview:self.contentLabel];
}

#pragma mark - ZFCodeImageViewDelegate

- (void)longPressGestureRecognizerInImageView:(ZFCodeImageView *)imageView code:(NSString *)code{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * readAction = [UIAlertAction actionWithTitle:@"识别条形码/二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.contentLabel.text = code;
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:readAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
