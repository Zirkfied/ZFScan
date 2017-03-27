# ZFScan
A simple scan QRCode / BarCode library for iOS - 仿微信 二维码/条形码 扫描

此框架适用于 >= iOS 8，用法简单，喜欢的欢迎star一个，有任何建议或问题可以加QQ群交流：451169423

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
    
        [self.navigationController pushViewController:vc animated:YES];
        

### 界面效果

![](https://github.com/Zirkfied/Library/blob/master/scan.png)


## 本人其他开源框架
#### [ZFChart - 一款简单好用的图表库，目前有柱状，线状，饼图，波浪，雷达，圆环图类型](https://github.com/Zirkfied/ZFChart)
#### [ZFScan - 仿微信 二维码/条形码 扫描](https://github.com/Zirkfied/ZFScan)
#### [ZFDropDown - 简单大气的下拉列表框](https://github.com/Zirkfied/ZFDropDown)
