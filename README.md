# ZFScan
A simple scan QRCode / BarCode library for iOS - 二维码/条形码 扫描和生成

此框架适用于 >= iOS 8，已支持横竖屏适配，用法简单，喜欢的欢迎star一个，有任何建议或问题可以加QQ群交流：451169423

## 扫描
### 用法:
        第一步(step 1)
        将项目里ZFScan整个文件夹拖进新项目
        
        第二步(step 2)
        #import "ZFScanViewController.h"
        
        第三步(step 3)
        ZFScanViewController * vc = [[ZFScanViewController alloc] init];
        vc.returnScanBarCodeValue = ^(NSString * barCodeString){
            //扫描完成后，在此进行后续操作
            NSLog(@"扫描结果======%@",barCodeString);
        };
    
        [self presentViewController:vc animated:YES completion:nil];
        

### 界面效果

![](https://github.com/Zirkfied/Library/blob/master/scan.png)

## 生成
### 用法
        第一步(step 1)
        将项目里ZFScan整个文件夹拖进新项目
        
        第二步(step 2)
        #import "ZFConst.h"
        
        第三步(step 3)
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
        //条形码：kCodePatternForBarCode 二维码：kCodePatternForQRCode
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
        imageView.image = [UIImage imageForCodeString:@"iOS开发" size:imageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternForQRCode];
        [self.view addSubview:imageView];

## 本人其他开源框架
#### [ZFChart - 一款简单好用的图表库，目前有柱状，线状，饼图，波浪，雷达，圆环图类型](https://github.com/Zirkfied/ZFChart)
#### [ZFScan - 仿微信 二维码/条形码 扫描](https://github.com/Zirkfied/ZFScan)
#### [ZFDropDown - 简单大气的下拉列表框](https://github.com/Zirkfied/ZFDropDown)
