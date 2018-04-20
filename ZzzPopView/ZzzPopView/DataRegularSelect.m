//
//  DataRegularSelect.m
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/27.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "DataRegularSelect.h"

@implementation DataRegularSelect

-(instancetype) init
{
    self = [super init];
    if(self)
    {
        self.data = [NSMutableArray array];
        self.selectedRowID = 0;
        self.isShowNextBtn = NO;
        self.isShowPriviouBtn = NO;
        self.isShowConfirmBtn = NO;
    }
    return self;
}

@end
