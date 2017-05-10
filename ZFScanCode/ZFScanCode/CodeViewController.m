//
//  CodeViewController.m
//  ZFScanCode
//
//  Created by apple on 2017/5/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CodeViewController.h"
#import "ZFConst.h"

@interface CodeViewController ()<UITextFieldDelegate>

/** 条形码 */
@property (nonatomic, strong) UIImageView * barCodeImageView;
/** 二维码 */
@property (nonatomic, strong) UIImageView * QRCodeImageView;
/** 输入内容textField */
@property (nonatomic, strong) UITextField * textField;
/** 生成条形码button */
@property (nonatomic, strong) UIButton * barCodeButton;
/** 生成二维码button */
@property (nonatomic, strong) UIButton * QRCodeButton;

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZFWhite;
    
    //二维码
    CGFloat QRCode_width = 200;
    CGFloat QRCode_height = 200;
    CGFloat QRCode_xPos = (SCREEN_WIDTH - QRCode_width) / 2;
    CGFloat QRCode_yPos = 100;
    
    self.QRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QRCode_xPos, QRCode_yPos, QRCode_width, QRCode_height)];
    [self.view addSubview:self.QRCodeImageView];
    
    //生成二维码button
    CGFloat QRCodeButton_width = 60;
    CGFloat QRCodeButton_height = 30;
    CGFloat QRCodeButton_xPos = 100;
    CGFloat QRCodeButton_yPos = 480;
    
    self.QRCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QRCodeButton.frame = CGRectMake(QRCodeButton_xPos, QRCodeButton_yPos, QRCodeButton_width, QRCodeButton_height);
    [self.QRCodeButton setTitle:@"二维码" forState:UIControlStateNormal];
    [self.QRCodeButton addTarget:self action:@selector(QRCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QRCodeButton];
    
    //条形码
    CGFloat barCode_width = 300;
    CGFloat barCode_height = 120;
    CGFloat barCode_xPos = (SCREEN_WIDTH - barCode_width) / 2;
    CGFloat barCode_yPos = 200 - barCode_height / 2.f;
    
    self.barCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(barCode_xPos, barCode_yPos, barCode_width, barCode_height)];
    [self.view addSubview:self.barCodeImageView];
    
    //生成条形码button
    CGFloat barCodeButton_width = 60;
    CGFloat barCodeButton_height = 30;
    CGFloat barCodeButton_xPos = SCREEN_WIDTH - barCodeButton_width - 100;
    CGFloat barCodeButton_yPos = 480;
    
    self.barCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.barCodeButton.frame = CGRectMake(barCodeButton_xPos, barCodeButton_yPos, barCodeButton_width, barCodeButton_height);
    [self.barCodeButton setTitle:@"条形码" forState:UIControlStateNormal];
    [self.barCodeButton addTarget:self action:@selector(barCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.barCodeButton];
    
    //textField
    CGFloat textField_width = 250;
    CGFloat textField_height = 30;
    CGFloat textField_xPos = (SCREEN_WIDTH - textField_width) / 2;
    CGFloat textField_yPos = 350;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textField_xPos, textField_yPos, textField_width, textField_height)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.placeholder = @"请输入内容";
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    //手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 收起键盘

- (void)closeKeyBoard{
    [self.textField endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeKeyBoard];
    
    return YES;
}

#pragma mark - 生成二维码

- (void)QRCodeAction{
    if (self.textField.text.length != 0) {
        self.barCodeImageView.hidden = YES;
        self.QRCodeImageView.image = [UIImage imageForCodeString:self.textField.text size:self.QRCodeImageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternForQRCode];
        self.QRCodeImageView.hidden = NO;
    }
}

#pragma mark - 生成条形码

- (void)barCodeAction{
    if (self.textField.text.length != 0) {
        self.QRCodeImageView.hidden = YES;
        self.barCodeImageView.image = [UIImage imageForCodeString:self.textField.text size:self.barCodeImageView.frame.size.width color:ZFRed pattern:kCodePatternForBarCode];
        self.barCodeImageView.hidden = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
