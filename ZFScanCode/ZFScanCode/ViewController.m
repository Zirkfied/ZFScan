//
//  ViewController.m
//  ZFScanCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ZFScanViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton * scanButton;//扫描按钮
@property (nonatomic, strong) UILabel * resultLabel;//显示扫描结果

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //扫描按钮
    self.scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.scanButton.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT - 100, 100, 30);
    [self.scanButton setTitle:@"扫描" forState:UIControlStateNormal];
    [self.scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scanButton];
    
    //显示扫描结果
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 100)];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.numberOfLines = 0;
    [self.view addSubview:self.resultLabel];
}

/**
 *  扫描事件
 */
- (void)scanAction:(UIButton *)sender{
    ZFScanViewController * vc = [[ZFScanViewController alloc] init];
    vc.returnScanBarCodeValue = ^(NSString * barCodeString){
        self.resultLabel.text = [NSString stringWithFormat:@"扫描结果:\n%@",barCodeString];
        NSLog(@"扫描结果的字符串======%@",barCodeString);
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 横竖屏适配

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    self.scanButton.frame = CGRectMake((SCREEN_HEIGHT - 100) / 2, SCREEN_WIDTH - 100, 100, 30);
    
    //横屏(转前是横屏，转后是竖屏)
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        
        self.resultLabel.frame = CGRectMake(0, 200, SCREEN_HEIGHT, 100);
        
    //竖屏(转前是竖屏，转后是横屏)
    }else{
        self.resultLabel.frame = CGRectMake(0, 80, SCREEN_HEIGHT, 100);
        
    }
}

@end
