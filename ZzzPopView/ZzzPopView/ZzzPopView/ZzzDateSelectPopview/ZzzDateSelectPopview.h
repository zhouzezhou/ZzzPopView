//
//  ZzzDateSelectPopview.h
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/5/14.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

// 查询条件PopView
#import <UIKit/UIKit.h>

@class ZzzDateSelectPopview;
// 代理方法
@protocol ZzzDateSelectPopviewDelegate <NSObject>

@optional
-(void) ZzzDateSelectPopviewDelegateClickConfirmBtnWithStartDate:(NSString *) startDate AndEndDate:(NSString *) endDate;          // 确认按钮
-(void) ZzzDateSelectPopviewClickCancelBtn;           // 返回按钮

@end

@interface ZzzDateSelectPopview : UIView

@property (nonatomic, strong) id<ZzzDateSelectPopviewDelegate> delegate;

// 初始化View
+(ZzzDateSelectPopview *) messagePopviewWithBtnTitle:(NSString *) btnTitle popViewTitle:(NSString *) popviewTitle popVuewDescrption:(NSString *) desc;

// 展示在哪个视图上
- (void)showInView:(UIView *)view andShowModeUpDown:(BOOL) isUpDown;


@end
