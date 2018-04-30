//
//  DataScrollSelect.h
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/24.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataScrollSelect : NSObject

@property (nonatomic, strong) NSMutableArray<NSString *> *arrData;             // 数据
@property (nonatomic, strong) NSString *name;               // 组名称
@property (nonatomic, assign) NSInteger selectedRowID;      // 默认选中项对应的行ID
@property (nonatomic, assign) BOOL isShowPriviouBtn;        // 是否显示「上一个」的按钮
@property (nonatomic, assign) BOOL isShowNextBtn;           // 是否显示「下一个」的按钮
@property (nonatomic, assign) BOOL isShowConfirmBtn;        // 是否显示「完成」的按钮

@end
