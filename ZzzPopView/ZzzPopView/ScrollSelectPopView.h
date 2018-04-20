//
//  ScrollSelectPopView.h
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/24.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

// 滑动选择PopView
// 可用于以下场景：动作选择、重复次数选择、重量选择、休息时间选择
#import <UIKit/UIKit.h>
#import "DataScrollSelect.h"

@class ScrollSelectPopView;

// 代理方法
@protocol ScrollSelectPopViewDelegate <NSObject>

@optional
/** 点击确认按钮代理方法 */
// 点击了下一步的按钮
- (void)clickScrollSelectPopViewBtn_next_scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex;
// 点击了上一步的按钮
- (void)clickScrollSelectPopViewBtn_previous_scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex;
// 点击了确认按钮
- (void)clickScrollSelectPopViewBtn_confirm_scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex;
// 点击了取消按钮
- (void)clickScrollSelectPopViewBtn_cancel_scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex;

// 选择的结果:groupIndex 组id，itemIndex 实体内容id
-(void) scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex;
// 滑动经过的内容:groupIndex 组id，itemIndex 实体内容id
-(void) scrollSelectPopView:(ScrollSelectPopView *) popview scrolledItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex;
@end

// 滑动选择PopView类
@interface ScrollSelectPopView : UIView

@property (nonatomic, strong) id<ScrollSelectPopViewDelegate> delegate;

// 初始化View
+(ScrollSelectPopView *) popviewWithScrollSelectData:(DataScrollSelect *) data;

// 选中某行
-(void) selectRow:(NSUInteger)selectedRowID;

// 展示在哪个视图上
- (void)showInView:(UIView *)view;

- (void)dismiss;

@end



