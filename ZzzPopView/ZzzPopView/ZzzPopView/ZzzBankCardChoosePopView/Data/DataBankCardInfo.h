//
//  DataBankCardInfo.h
//  freeman
//
//  Created by zhouzezhou on 2017/12/13.
//  Copyright © 2017年 中付上海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBankCardInfo : NSObject

// 绑卡界面
@property(nonatomic, copy) NSString *cardType;           // 卡类型，0借记卡，1信用卡
@property(nonatomic, copy) NSString *bankCardNumber;     // 银行卡号
@property(nonatomic, copy) NSString *IDNumber;           // 身份证号码
@property(nonatomic, copy) NSString *cardHostName;       // 真实姓名
@property(nonatomic, copy) NSString *cardSecurity;       // 卡安全码
@property(nonatomic, copy) NSString *cardExpired;        // 卡有效期
@property(nonatomic, copy) NSString *phoneNumber;        // 银行预留手机号码
@property(nonatomic, copy) NSString *MSG;                // 验证码


@property (nonatomic, copy) NSString *province;    // 省份
@property (nonatomic, copy) NSString *city;        // 城市
@property (nonatomic, copy) NSString *district;    // 区域

// 选择卡界面
@property (nonatomic, strong) NSString *logoNamed;      // 银行logo的图片名称
@property (nonatomic, strong) NSString *bankName;       // 银行名称
//@property (nonatomic, strong) NSString *bankCardStr;    // 显示的银行卡信息（银行 + 类型 + 卡号）
@property (nonatomic, strong) NSString *cardID;         // 银行卡ID（用于交易）

@property (nonatomic, strong) NSString *cardLastNumber; // 卡号后几位

@property (nonatomic, assign) BOOL isSelected;          // 当前是否被选中
@property (nonatomic, assign) NSInteger usedCount;      // 当前卡使用次数

@end
