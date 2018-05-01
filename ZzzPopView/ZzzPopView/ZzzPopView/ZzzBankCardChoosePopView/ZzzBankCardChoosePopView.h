//
//  ZzzBankCardChoosePopView.h
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/5/1.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBankCardInfo.h"

@class ZzzBankCardChoosePopView;
// 代理方法
@protocol ZzzBankCardChoosePopViewDelegate <NSObject>

@optional
/** 点击确认按钮代理方法 */
- (void) zzzBankCardChoosePopViewClickConfirmBtn;
- (void) zzzBankCardChoosePopViewClickCancelBtn;

-(void) zzzBankCardChoosePopViewSelectedBankCard:(NSInteger) index;

@end


// 银行卡选择PopView
@interface ZzzBankCardChoosePopView : UIView

@property (nonatomic, weak) id<ZzzBankCardChoosePopViewDelegate> delegate;

// 初始化View
+(ZzzBankCardChoosePopView *) popviewWithCardBankData:(NSMutableArray<DataBankCardInfo *> *) data;

// 展示在哪个视图上
- (void)showInView:(UIView *)view andShowModeUpDown:(BOOL) isUpDown;

@end
