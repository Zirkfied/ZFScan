//
//  TableViewController.m
//  ZFScanCode
//
//  Created by apple on 2017/5/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "TableViewController.h"
#import "ScanViewController.h"
#import "CodeViewController.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * viewControllerArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = @[@"条形码/二维码扫描\n(ScanViewController)",
                        @"条形码/二维码生成(普通)\n(CodeViewController)",
                        @"二维码生成(中间带图标)\n(CodeViewController2)",
                        @"二维码识别(长按)\n(ReadCodeViewController)",
                        @"二维码识别(从相册获取)\n(ReadCodeViewController2)"];
    
    self.viewControllerArray = @[@"ScanViewController",
                                 @"CodeViewController",
                                 @"CodeViewController2",
                                 @"ReadCodeViewController",
                                 @"ReadCodeViewController2"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[NSClassFromString(self.viewControllerArray[indexPath.row]) alloc] init] animated:YES];
}

@end
