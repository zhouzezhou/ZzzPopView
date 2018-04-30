//
//  RegularSelectPopView.h
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/27.
//  Copyright © 2018年 zhouzezhou. All rights reserved.


// 固定的选择PopView
// 可用于以下场景：动作分类选择、重量单位选择
#import <UIKit/UIKit.h>
#import "DataRegularSelect.h"

@class RegularSelectPopView;

// 代理方法
@protocol RegularSelectPopViewDelegate <NSObject>

@optional
/** 点击确认按钮代理方法 */
// 点击了下一步的按钮
- (void)clickRegularSelectPopViewBtn_next_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID;
// 点击了上一步的按钮
- (void)clickRegularSelectPopViewBtn_previous_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID;
// 点击了确认按钮
- (void)clickRegularSelectPopViewBtn_confirm_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID;
// 点击了取消按钮
- (void)clickRegularSelectPopViewBtn_cancel_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID;

// 选择的结果:selectedID 被选中的项的id
-(void) regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID;
@end

@interface RegularSelectPopView : UIView

@property (nonatomic, weak) id<RegularSelectPopViewDelegate> delegate;

// 初始化View
+(RegularSelectPopView *) popviewWithRegularSelectData:(DataRegularSelect *) data;

// 展示在哪个视图上
- (void)showInView:(UIView *)view;

- (void)dismiss;

@end
