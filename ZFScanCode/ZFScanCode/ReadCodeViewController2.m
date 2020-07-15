//
//  ReadCodeViewController2.m
//  ZFScanCode
//
//  Created by apple on 2020/7/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ReadCodeViewController2.h"
#import "ZFConst.h"

@interface ReadCodeViewController2 ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 二维码内容Label */
@property(nonatomic, strong) UILabel * codeLabel;
/** 打开相册Button */
@property(nonatomic, strong) UIButton * button;

@end

@implementation ReadCodeViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZFWhite;
    
    //二维码内容Label
    CGFloat codeLabel_xPos = 0.f;
    CGFloat codeLabel_yPos = 150.f;
    CGFloat codeLabel_width = SCREEN_WIDTH;
    CGFloat codeLabel_height = 40.f;
    
    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(codeLabel_xPos, codeLabel_yPos, codeLabel_width, codeLabel_height)];
    self.codeLabel.textAlignment = NSTextAlignmentCenter;
    self.codeLabel.font = [UIFont systemFontOfSize:20.f];
    [self.view addSubview:self.codeLabel];
    
    //打开相册Button
    CGFloat button_xPos = 0.f;
    CGFloat button_yPos = 300.f;
    CGFloat button_width = SCREEN_WIDTH;
    CGFloat button_height = 40.f;
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(button_xPos, button_yPos, button_width, button_height);
    self.button.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [self.button setTitle:@"打开相册选择二维码图片" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}

- (void)clickAction:(UIButton *)sender{
    //调用相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//选中图片的回调
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //取出选中的图片
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    //核心就是这句，调用image的扩展方法
    NSString * code = [image readCode];
    self.codeLabel.text = code;
}

@end
