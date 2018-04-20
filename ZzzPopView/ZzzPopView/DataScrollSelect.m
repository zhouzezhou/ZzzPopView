//
//  DataScrollSelect.m
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/24.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "DataScrollSelect.h"

@implementation DataScrollSelect

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        self.arrData = [NSMutableArray array];
        self.selectedRowID = 0;
        self.isShowNextBtn = YES;
        self.isShowPriviouBtn = YES;        
        self.isShowConfirmBtn = NO;
    }
    return self;
}

@end
