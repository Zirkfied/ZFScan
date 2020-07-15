//
//  CodeViewController2.m
//  ZFScanCode
//
//  Created by apple on 2020/7/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import "CodeViewController2.h"
#import "ZFConst.h"

@interface CodeViewController2 ()<UITextFieldDelegate>

/** icon图标 */
@property (nonatomic, strong) UIImage * iconImage;
/** 二维码 */
@property (nonatomic, strong) UIImageView * QRCodeImageView;
/** 输入内容textField */
@property (nonatomic, strong) UITextField * textField;
/** 生成二维码button */
@property (nonatomic, strong) UIButton * QRCodeButton;

@end

@implementation CodeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZFWhite;
    
    //icon图标
    self.iconImage = [UIImage imageNamed:@"ShiBaInu"];
    
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
    CGFloat QRCodeButton_xPos = (SCREEN_WIDTH - QRCodeButton_width) * 0.5;
    CGFloat QRCodeButton_yPos = 480;
    
    self.QRCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QRCodeButton.frame = CGRectMake(QRCodeButton_xPos, QRCodeButton_yPos, QRCodeButton_width, QRCodeButton_height);
    [self.QRCodeButton setTitle:@"二维码" forState:UIControlStateNormal];
    [self.QRCodeButton addTarget:self action:@selector(QRCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QRCodeButton];
    
    //textField
    CGFloat textField_width = 250;
    CGFloat textField_height = 40;
    CGFloat textField_xPos = (SCREEN_WIDTH - textField_width) / 2;
    CGFloat textField_yPos = 350;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textField_xPos, textField_yPos, textField_width, textField_height)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.placeholder = @"请输入内容";
    self.textField.font = [UIFont systemFontOfSize:20.f];
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
        self.QRCodeImageView.image = [UIImage imageCodeString:self.textField.text size:self.QRCodeImageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternQRCode iconImage:self.iconImage iconImageSize:60.f];
        self.QRCodeImageView.hidden = NO;
    }
}

@end
