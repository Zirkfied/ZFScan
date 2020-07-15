# ZFScan
A simple scan QRCode / BarCode library for iOS - 二维码/条形码 扫描，生成，识别

此框架适用于 >= iOS 8，已支持横竖屏适配，用法简单，喜欢的欢迎star一个，有任何建议或问题可以加QQ群交流：451169423

## 扫描
### 用法
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
#### 普通生成:
        第一步(step 1)
        将项目里ZFScan整个文件夹拖进新项目
        
        第二步(step 2)
        #import "ZFConst.h"
        
        第三步(step 3)
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
        //条形码：kCodePatternBarCode 二维码：kCodePatternQRCode
        imageView.image = [UIImage imageCodeString:@"iOS开发" size:imageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternQRCode iconImage:nil iconImageSize:0.f];
        [self.view addSubview:imageView];
        
#### 中间带图标生成:
        UIImage * iconImage = [UIImage imageNamed:@"ShiBaInu"];
        imageView.image = [UIImage imageCodeString:@"iOS开发" size:imageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternQRCode iconImage:iconImage iconImageSize:60.f];
        
        
### 效果展示

![](https://github.com/Zirkfied/Library/blob/master/ShiBaInuQRCode.png)
        
## 识别
### 用法
#### 长按识别
        遵循ZFCodeImageViewDelegate协议
        
        NSString * QRCodeString = @"我是二维码";
        
        UIImageView * QRCodeImageView = [[ZFCodeImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        QRCodeImageView.image = [UIImage imageCodeString:QRCodeString size:QRCodeImageView.frame.size.width color:ZFSkyBlue pattern:kCodePatternQRCode iconImage:nil iconImageSize:0.f];
        QRCodeImageView.delegate = self;
        [self.view addSubview:QRCodeImageView];
        
        并且实现协议方法：- (void)longPressGestureRecognizerInImageView:(ZFCodeImageView *)imageView code:(NSString *)code，此时这个code就是
        二维码的内容
        
#### 从相册获取识别
        //从相册拿到选中的image，然后调用
        NSString * code = [image readCode];
        NSLog(@"%@", code);
 
       
### 更新日志
        2020.07.15 ①新增二维码生成(中间带图标)，具体用法查看Demo中的CodeViewController2.m文件
                   ②新增二维码识别(长按)，具体用法查看Demo中的ReadCodeViewController.m文件
                   ③新增二维码识别(从相册获取)，具体用法查看Demo中的ReadCodeViewController2.m文件
                   ④优化部分方法和属性的命名
                   ⑤苹果原生API不支持条形码识别，所以暂时只有二维码识别功能
                  
        

## 本人其他开源框架
#### [ZFChart - 一款简单好用的图表库，目前有柱状，线状，饼图，波浪，雷达，圆环图类型](https://github.com/Zirkfied/ZFChart)
#### [ZFScan - 仿微信 二维码/条形码 扫描](https://github.com/Zirkfied/ZFScan)
#### [ZFDropDown - 简单大气的下拉列表框](https://github.com/Zirkfied/ZFDropDown)
