//
//  ViewController.m
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/4/20.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "ViewController.h"
#import "ScrollSelectPopView.h"
#import "RegularSelectPopView.h"

// 屏幕的宽度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
// 屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
// 系统状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height


@interface ViewController () <ScrollSelectPopViewDelegate, RegularSelectPopViewDelegate>

@property (nonatomic, strong) UILabel *displayLabel;    // 打印信息

@property (nonatomic, strong) RegularSelectPopView *regularSelectPopView_body;      // 选择部位的PopView
@property (nonatomic, strong) DataRegularSelect *regularData_body;                  // 选择部位的PopView里的显示数据

@property (nonatomic, strong) ScrollSelectPopView *scrollSelectPopView_motion;      // 选择动作的PopView
@property (nonatomic, strong) DataScrollSelect *selectData_motion;                  // 选择动作的PopView里的显示数据

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    
    [self configView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private method
-(void) configData
{
    [self configRegularPopView];
    
    [self configStripScrollPopView];
}

-(void) configRegularPopView
{
    _regularData_body = [[DataRegularSelect alloc] init];
    
    DataOneRegularSelectInfo *temp1 = [[DataOneRegularSelectInfo alloc] init];
    temp1.name = @"胸";
    temp1.decript = @"乳房是雌性哺乳动物孕育后代的重要器官。人类的乳房结构分为内、外部位。主要为乳腺和其他肌肉组织组成。对于人类的女性而言，如何养护乳房是首要问题，比如预防各种的乳房疾病、及时检查等都是重要环节。乳房还具有审美意义，人体艺术的形成基于该器官健康状况。乳房的主要成分是脂肪，另外是乳腺。女性胸部只是第二性征，并非生殖器官。";
    
    [_regularData_body.data addObject:temp1];
    
    DataOneRegularSelectInfo *temp2 = [[DataOneRegularSelectInfo alloc] init];
    temp2.name = @"肩";
    temp2.decript = @"肩膀是一个汉语词汇，读音为 jiānbǎng，指人的胳膊上部与躯干相连的部分，比喻勇于或能够承担的责任，亦有同名歌曲等。释义：1、指人的胳膊上部与躯干相连的部分。2、比喻勇于或能够承担的责任。";
    
    [_regularData_body.data addObject:temp2];
    
    DataOneRegularSelectInfo *temp3 = [[DataOneRegularSelectInfo alloc] init];
    temp3.name = @"背";
    temp3.decript = @"背，中国汉字，多音字：(1)bēi，用于“背负”“背债”“背包”。(2)bèi，用于“背风”“背约”“背道而驰”“背信弃义”。";
    
    [_regularData_body.data addObject:temp3];
    
    DataOneRegularSelectInfo *temp4 = [[DataOneRegularSelectInfo alloc] init];
    temp4.name = @"腿";
    temp4.decript = @"腿，tui，骽， 胫和股的总称。腿tuǐ 的基本字义：1.人和动物用来支持身体和行走的部分：大~，前~，后~。2.器物下部像腿一样起支撑作用的部分：桌子~，椅子~。3.指火腿：云~（云南火腿）。";
    
    [_regularData_body.data addObject:temp4];
    
    DataOneRegularSelectInfo *temp5 = [[DataOneRegularSelectInfo alloc] init];
    temp5.name = @"腰";
    temp5.decript = @"腰是一个汉字，读作yāo，本意是指东西的中段，中间，也特指身体胯上胁下的部分，或指所穿衣服在身体的腰部的部分。";
    
    [_regularData_body.data addObject:temp5];
    
    _regularData_body.selectedRowID = 0;
    _regularData_body.isShowNextBtn = YES;
    _regularData_body.isShowPriviouBtn = YES;
    _regularData_body.isShowConfirmBtn = YES;
    
    _regularSelectPopView_body = [RegularSelectPopView popviewWithRegularSelectData:_regularData_body];
    _regularSelectPopView_body.delegate = self;
}

-(void) configStripScrollPopView
{
    _selectData_motion = [[DataScrollSelect alloc] init];
    
    [_selectData_motion.arrData addObject:@"坐姿划船"];
    [_selectData_motion.arrData addObject:@"臀推(桥式提臀)"];
    [_selectData_motion.arrData addObject:@"腿举"];
    [_selectData_motion.arrData addObject:@"杠铃头上举"];
    [_selectData_motion.arrData addObject:@"引体向上"];
    [_selectData_motion.arrData addObject:@"坐姿高位下拉"];
    [_selectData_motion.arrData addObject:@"坐姿哑铃臂弯举"];
    [_selectData_motion.arrData addObject:@"坐姿双臂下压"];
    [_selectData_motion.arrData addObject:@"杠铃弯举"];
    [_selectData_motion.arrData addObject:@"仰卧杠铃屈臂伸"];
    [_selectData_motion.arrData addObject:@"俯身支撑臂屈伸"];
    [_selectData_motion.arrData addObject:@"仰卧起坐"];
    [_selectData_motion.arrData addObject:@"躺姿卷腹"];
    [_selectData_motion.arrData addObject:@"坐姿卷腹"];
    [_selectData_motion.arrData addObject:@"杠铃站姿挺身"];
    [_selectData_motion.arrData addObject:@"站姿抬腿"];
    [_selectData_motion.arrData addObject:@"俯卧挺身"];
    [_selectData_motion.arrData addObject:@"蝴蝶夹胸"];
    [_selectData_motion.arrData addObject:@"斜躺上推"];
    [_selectData_motion.arrData addObject:@"坐姿向前推胸"];
    [_selectData_motion.arrData addObject:@"弓步前拉夹胸"];
    [_selectData_motion.arrData addObject:@"平板哑铃卧推"];
    [_selectData_motion.arrData addObject:@"坐姿臂屈伸"];
    [_selectData_motion.arrData addObject:@"站姿双臂下摆"];
    [_selectData_motion.arrData addObject:@"T型杆划船"];
    [_selectData_motion.arrData addObject:@"单手哑铃划船"];
    [_selectData_motion.arrData addObject:@"杠铃划船"];
    [_selectData_motion.arrData addObject:@"坐姿向前推胸"];
    [_selectData_motion.arrData addObject:@"坐姿向前推胸"];
    [_selectData_motion.arrData addObject:@"坐姿向前推胸"];
    [_selectData_motion.arrData addObject:@"保加利亚深蹲"];
    [_selectData_motion.arrData addObject:@"站姿直腿上摆"];
    [_selectData_motion.arrData addObject:@"自由重量深蹲"];
    [_selectData_motion.arrData addObject:@"坐姿腿屈伸"];
    [_selectData_motion.arrData addObject:@"俯卧腿弯曲"];
    [_selectData_motion.arrData addObject:@"哈克深蹲"];
    [_selectData_motion.arrData addObject:@"臀推"];
    
    _selectData_motion.isShowPriviouBtn = YES;
    _selectData_motion.isShowNextBtn = YES;
    _selectData_motion.isShowConfirmBtn = YES;
    
    _scrollSelectPopView_motion = [ScrollSelectPopView popviewWithScrollSelectData:_selectData_motion];
    _scrollSelectPopView_motion.delegate = self;
}

-(void) configView
{
    _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kStatusBarHeight + 10, kScreenWidth - 20, kScreenHeight - 44.f - 10 - 44.f - 10 - 10 - kStatusBarHeight - 10)];
    [_displayLabel setNumberOfLines:0];
    [_displayLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_displayLabel setText:@"日志:"];
    [_displayLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_displayLabel];
    
    UIButton *RegularSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - 44.f - 10, kScreenWidth - 20, 44.f)];
    [RegularSelectBtn setTitle:@"RegularSelectPopView" forState:UIControlStateNormal];
    [RegularSelectBtn setBackgroundColor:[UIColor orangeColor]];
    [RegularSelectBtn.layer setCornerRadius:4.f];
    [RegularSelectBtn addTarget:self action:@selector(RegularSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegularSelectBtn];
    
    UIButton *stripScrollSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - 44.f - 10 - 44.f - 10, kScreenWidth - 20, 44.f)];
    [stripScrollSelectBtn setTitle:@"StripScrollSelectBtn" forState:UIControlStateNormal];
    [stripScrollSelectBtn setBackgroundColor:[UIColor orangeColor]];
    [stripScrollSelectBtn.layer setCornerRadius:4.f];
    [stripScrollSelectBtn addTarget:self action:@selector(StripScrollSelectBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stripScrollSelectBtn];
}

-(void) setLogText:(NSString *) text
{
    [_displayLabel setText:[NSString stringWithFormat:@"%@\n%@", _displayLabel.text, text]];
}

#pragma mark - Button respond
-(void) RegularSelectBtnClick: (UIButton *) sender
{
    [_regularSelectPopView_body showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) StripScrollSelectBtnBtnClick:(UIButton *) sender
{
    [_scrollSelectPopView_motion showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Protocol RegularSelectPopViewDelegate

- (void)clickRegularSelectPopViewBtn_next_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID
{
    NSLog(@"clickRegularSelectPopViewBtn_next");
    [self setLogText:@"clickRegularSelectPopViewBtn_next"];
}

- (void)clickRegularSelectPopViewBtn_previous_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID
{
    NSLog(@"clickRegularSelectPopViewBtn_previous");
    [self setLogText:@"clickRegularSelectPopViewBtn_previous"];
}

- (void)clickRegularSelectPopViewBtn_confirm_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID
{
    NSLog(@"clickRegularSelectPopViewBtn_confirm");
    [self setLogText:@"clickRegularSelectPopViewBtn_confirm"];
}

- (void)clickRegularSelectPopViewBtn_cancel_regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID
{
    NSLog(@"clickRegularSelectPopViewBtn_cancel");
    [self setLogText:@"clickRegularSelectPopViewBtn_cancel"];
}

// 选择的结果:selectedID 被选中的项的id
-(void) regularSelectPopView:(RegularSelectPopView *) popview selectedItemByID:(NSInteger) selectedID
{
    if(popview == _regularSelectPopView_body)
    {
        [self setLogText:[NSString stringWithFormat:@"regularSelectPopView selectedID is :%ld", (long)selectedID]];
        
//        NSLog(@"selectedItemByID : %lu, body name is :%@", (long)selectedID, _bodyArrayOri[selectedID].body_name);
//        [_regularSelectPopView_body dismiss];
//
//        // 根据选中的锻炼部位弹出对应的动作
//        // 动作数据
//        _motionArrayOri = [_dBUtilMotionAndBody getMotionByBodyID:[NSString stringWithFormat:@"%lu", (long)selectedID + 1]];
//        [_selectData_motion.arrData removeAllObjects];
//        [_motionArrayOri enumerateObjectsUsingBlock:^(DataSetMotion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [_selectData_motion.arrData addObject:obj.motion_name];
//            //  若之前选择的动作在此数组中，则找出其的index做为popview里的默认选中项
//            if(_dataOnceMotion.id_motion && (obj.id_motion == _dataOnceMotion.id_motion))
//            {
//                _selectData_motion.selectedRowID = idx;
//            }
//        }];
//
//        _selectData_motion.isShowPriviouBtn = YES;
//        _selectData_motion.isShowNextBtn = YES;
//
//        _scrollSelectPopView_motion = [ScrollSelectPopView popviewWithScrollSelectData:_selectData_motion];
//        _scrollSelectPopView_motion.delegate = self;
//
//        [_scrollSelectPopView_motion showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}

#pragma mark - Protocol ScrollSelectPopViewDelegate
- (void)clickScrollSelectPopViewBtn_next_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    if(popview == _scrollSelectPopView_motion)
    {
        //        NSLog(@"11111111111_scrollSelectPopView_motion");
        
        
        [self setLogText:@"clickScrollSelectPopViewBtn_next"];
        
    }
    
    NSLog(@"clickScrollSelectPopViewBtn_next");
}

- (void)clickScrollSelectPopViewBtn_previous_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    NSLog(@"clickScrollSelectPopViewBtn_previous");
    [self setLogText:@"clickScrollSelectPopViewBtn_previous"];
}

- (void)clickScrollSelectPopViewBtn_confirm_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    NSLog(@"clickScrollSelectPopViewBtn_confirm");
    [self setLogText:@"clickScrollSelectPopViewBtn_confirm"];
}

- (void)clickScrollSelectPopViewBtn_cancel_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    NSLog(@"clickScrollSelectPopViewBtn_cancel");
    [self setLogText:@"clickScrollSelectPopViewBtn_cancel"];
    if(popview == _scrollSelectPopView_motion)
    {
//        NSLog(@"groupIndex: %ld, itemIndex :%ld", (long)groupIndex, (long)itemIndex);
//        NSString *tempstr = _motionArrayOri[itemIndex].motion_name;
//        NSLog(@"motion name is :%@", tempstr);
//        [_dataOnceMotion setId_motion:_motionArrayOri[itemIndex].id_motion];
//        [_motionLabelContent setText:tempstr];
    }
}

// 选择的结果:groupIndex 组id，itemIndex 实体内容id
-(void) scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex
{
    //    NSLog(@"groupIndex: %ld, itemIndex :%ld, value is :%@", (long)groupIndex, (long)itemIndex, (NSString *)_selectData[groupIndex].arrData[itemIndex]);
    
    if(popview == _scrollSelectPopView_motion)
    {
        [self setLogText:[NSString stringWithFormat:@"scrollSelectPopView itemIndex is :%ld", (long)itemIndex]];
//        NSLog(@"groupIndex: %ld, itemIndex :%ld", (long)groupIndex, (long)itemIndex);
//        NSString *tempstr = _motionArrayOri[itemIndex].motion_name;
//        NSLog(@"motion name is :%@", tempstr);
//        [_dataOnceMotion setId_motion:_motionArrayOri[itemIndex].id_motion];
//        [_motionLabelContent setText:tempstr];
    }
}


@end
