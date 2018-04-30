//
//  Zzz6NumberInputPopView.h
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/4/30.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Zzz6NumberInputPopView;
// 代理方法
@protocol Zzz6NumberInputPopViewDelegate <NSObject>

@optional
-(void) Zzz6NumberInputPopViewClickConfirmBtnWithMSG:(NSString *) msg;          // 确定按钮
-(void) Zzz6NumberInputPopViewClickCancelBtn;           // 返回按钮

@end


@interface Zzz6NumberInputPopView : UIView

@property (nonatomic, weak) id<Zzz6NumberInputPopViewDelegate> delegate;

/* 初始化View
 * @param btnTitle:底部确认按钮里的文字
 * @param popviewTitle:popview的标题文字
 * @param desc:副标题文字
 * @param hintText:提示信息
 * @param isSecret:是否为安全输入模式，YES输入的字符显示为星号（*），NO输入什么就显示什么
 */
+(Zzz6NumberInputPopView *) messagePopviewWithBtnTitle:(NSString *) btnTitle popViewTitle:(NSString *) popviewTitle popVuewDescrption:(NSString *) desc hintText:(NSString *)hintText isSecureTextEntry:(BOOL) isSecret;

// 展示在哪个视图上
- (void)showInView:(UIView *)view andShowModeUpDown:(BOOL) isUpDown;

@end
