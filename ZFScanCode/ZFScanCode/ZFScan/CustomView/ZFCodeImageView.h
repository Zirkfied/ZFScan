//
//  ZFCodeImageView.h
//  ZFScanCode
//
//  Created by apple on 2020/7/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class ZFCodeImageView;

@protocol ZFCodeImageViewDelegate <NSObject>

/**
 *  长按条形码/二维码Action
 *
 *  @param imageView 当前imageView
 *  @param code 条形码/二维码内容
 */
- (void)longPressGestureRecognizerInImageView:(nullable ZFCodeImageView *)imageView code:(nullable NSString *)code;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZFCodeImageView : UIImageView

@property (nonatomic, weak) id<ZFCodeImageViewDelegate> delegate;

@property (nonatomic, assign) BOOL canLongPress;

@end

NS_ASSUME_NONNULL_END
