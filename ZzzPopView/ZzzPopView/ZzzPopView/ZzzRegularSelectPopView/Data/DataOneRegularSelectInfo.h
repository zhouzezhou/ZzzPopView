//
//  DataOneRegularSelectInfo.h
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/27.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataOneRegularSelectInfo : NSObject

@property (nonatomic, strong) NSString *name;               // 名称
@property (nonatomic, strong) NSString *decript;            // 详细描述
@property (nonatomic, strong) NSString *imgNamed;           // 图片
@property (nonatomic, strong) NSString *url;                // url

@property (nonatomic, strong) NSString *id_main;           // 主键ID
@property (nonatomic, strong) NSString *id_main_parent;    // 父部位ID

@end
