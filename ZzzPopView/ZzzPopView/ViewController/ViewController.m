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
#import "Zzz6NumberInputPopView.h"
#import "ZzzBankCardChoosePopView.h"

// 屏幕的宽度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
// 屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
// 系统状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height


@interface ViewController () <ScrollSelectPopViewDelegate, RegularSelectPopViewDelegate, Zzz6NumberInputPopViewDelegate, ZzzBankCardChoosePopViewDelegate>

@property (nonatomic, strong) UILabel *displayLabel;    // 打印信息

@property (nonatomic, strong) RegularSelectPopView *regularSelectPopView_body;      // 选择部位的PopView
@property (nonatomic, strong) DataRegularSelect *regularData_body;                  // 选择部位的PopView里的显示数据

@property (nonatomic, strong) ScrollSelectPopView *scrollSelectPopView_motion;      // 选择动作的PopView
@property (nonatomic, strong) DataScrollSelect *selectData_motion;                  // 选择动作的PopView里的显示数据

@property (nonatomic, strong) NSMutableArray<DataBankCardInfo *> *cardInfoArr;       // 银行卡信息数组
@property (nonatomic, strong) ZzzBankCardChoosePopView *zzzBankCardChoosePopView;    // 银行卡选择Popview
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
    
    [self configBankCardPopView];
    
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
    
    _scrollSelectPopView_motion = [ScrollSelectPopView popviewWithScrollSelectData:_selectData_motion];
    _scrollSelectPopView_motion.delegate = self;
}

-(void) configBankCardPopView
{
    // 随便弄点测试数据
    self.cardInfoArr = [NSMutableArray array];
    
    DataBankCardInfo *card1 = [[DataBankCardInfo alloc] init];
    card1.logoNamed = @"AppIcon";
    card1.isSelected = NO;
    card1.bankCardNumber = @"612345678901234000";
    card1.bankName = @"中国工商银行";
    [self.cardInfoArr addObject:card1];
    
    DataBankCardInfo *card2 = [[DataBankCardInfo alloc] init];
    card2.logoNamed = @"AppIcon";
    card2.isSelected = NO;
    card2.bankCardNumber = @"612345678901234123";
    card2.bankName = @"中国建设银行";
    [self.cardInfoArr addObject:card2];
    
    DataBankCardInfo *card3 = [[DataBankCardInfo alloc] init];
    card3.logoNamed = @"AppIcon";
    card3.isSelected = YES;
    card3.bankCardNumber = @"612345678901234456";
    card3.bankName = @"中国人民银行";
    [self.cardInfoArr addObject:card3];
    
    DataBankCardInfo *card4 = [[DataBankCardInfo alloc] init];
    card4.logoNamed = @"AppIcon";
    card4.isSelected = NO;
    card4.bankCardNumber = @"612345678901234789";
    card4.bankName = @"中国农业银行";
    [self.cardInfoArr addObject:card4];
    
    DataBankCardInfo *card5 = [[DataBankCardInfo alloc] init];
    card5.logoNamed = @"AppIcon";
    card5.isSelected = NO;
    card5.bankCardNumber = @"612345678901234111";
    card5.bankName = @"中国邮政储蓄银行";
    [self.cardInfoArr addObject:card5];
    
    DataBankCardInfo *card6 = [[DataBankCardInfo alloc] init];
    card6.logoNamed = @"AppIcon";
    card6.isSelected = NO;
    card6.bankCardNumber = @"612345678901234222";
    card6.bankName = @"中国光大银行";
    [self.cardInfoArr addObject:card6];
    
    self.zzzBankCardChoosePopView = [ZzzBankCardChoosePopView popviewWithCardBankData:self.cardInfoArr];
    self.zzzBankCardChoosePopView.delegate = self;
}

-(void) configView
{
    _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kStatusBarHeight + 10, kScreenWidth - 20, kScreenHeight - ((44.f + 10) * 5)  - 10 - kStatusBarHeight - 10)];
    [_displayLabel setNumberOfLines:0];
    [_displayLabel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_displayLabel setText:@"日志:"];
    [_displayLabel setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_displayLabel];
    
    UIButton *RegularSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - 44.f - 10, kScreenWidth - 20, 44.f)];
    [RegularSelectBtn setTitle:@"纵向长条pickerview的" forState:UIControlStateNormal];
    [RegularSelectBtn setBackgroundColor:[UIColor orangeColor]];
    [RegularSelectBtn.layer setCornerRadius:4.f];
    [RegularSelectBtn addTarget:self action:@selector(RegularSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegularSelectBtn];
    
    UIButton *stripScrollSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - (44.f + 10) * 2, kScreenWidth - 20, 44.f)];
    [stripScrollSelectBtn setTitle:@"纵向TableView的Popview" forState:UIControlStateNormal];
    [stripScrollSelectBtn setBackgroundColor:[UIColor orangeColor]];
    [stripScrollSelectBtn.layer setCornerRadius:4.f];
    [stripScrollSelectBtn addTarget:self action:@selector(StripScrollSelectBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stripScrollSelectBtn];
    
    UIButton *zzz6NumberInputPopViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - (44.f + 10) * 3, kScreenWidth - 20, 44.f)];
    [zzz6NumberInputPopViewBtn setTitle:@"6位数输入Popview" forState:UIControlStateNormal];
    [zzz6NumberInputPopViewBtn setBackgroundColor:[UIColor orangeColor]];
    [zzz6NumberInputPopViewBtn.layer setCornerRadius:4.f];
    [zzz6NumberInputPopViewBtn addTarget:self action:@selector(Zzz6NumberInputPopViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zzz6NumberInputPopViewBtn];
    
    UIButton *ZzzBankCardChoosePopViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - (44.f + 10) * 4, kScreenWidth - 20, 44.f)];
    [ZzzBankCardChoosePopViewBtn setTitle:@"银行卡选择Popview" forState:UIControlStateNormal];
    [ZzzBankCardChoosePopViewBtn setBackgroundColor:[UIColor orangeColor]];
    [ZzzBankCardChoosePopViewBtn.layer setCornerRadius:4.f];
    [ZzzBankCardChoosePopViewBtn addTarget:self action:@selector(ZzzBankCardChoosePopViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ZzzBankCardChoosePopViewBtn];
    
    UIButton *ZzzDateSelectPopviewBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight - (44.f + 10) * 5, kScreenWidth - 20, 44.f)];
    [ZzzDateSelectPopviewBtn setTitle:@"起始和终止日期选择Popview" forState:UIControlStateNormal];
    [ZzzDateSelectPopviewBtn setBackgroundColor:[UIColor orangeColor]];
    [ZzzDateSelectPopviewBtn.layer setCornerRadius:4.f];
    [ZzzDateSelectPopviewBtn addTarget:self action:@selector(ZzzDateSelectPopviewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ZzzDateSelectPopviewBtn];
}

-(void) setLogText:(NSString *) text
{
    [_displayLabel setText:[NSString stringWithFormat:@"%@\n%@", _displayLabel.text, text]];
}

#pragma mark - Button respond
-(void) RegularSelectBtnClick: (UIButton *) sender
{
    [_scrollSelectPopView_motion showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) StripScrollSelectBtnBtnClick:(UIButton *) sender
{
    [_regularSelectPopView_body showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) Zzz6NumberInputPopViewBtnClick
{
    // 弹出支付密码输入界面popview
    NSString *hintText = @"需要验证您的支付密码";
    Zzz6NumberInputPopView *popView = [Zzz6NumberInputPopView messagePopviewWithBtnTitle:@"确定" popViewTitle:@"支付密码" popVuewDescrption:@"请输入支付密码" hintText:hintText isSecureTextEntry:YES];
    popView.delegate = self;
    [popView showInView:[UIApplication sharedApplication].keyWindow andShowModeUpDown:YES];
}

-(void) ZzzBankCardChoosePopViewBtnClick
{
    [self.zzzBankCardChoosePopView showInView:[UIApplication sharedApplication].keyWindow andShowModeUpDown:YES];
}

-(void) ZzzDateSelectPopviewBtnClick
{
    
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
    }
    
}

#pragma mark - Protocol ScrollSelectPopViewDelegate
- (void)clickScrollSelectPopViewBtn_next_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    if(popview == _scrollSelectPopView_motion)
    {
        [self setLogText:@"clickScrollSelectPopViewBtn_next"];
        NSLog(@"clickScrollSelectPopViewBtn_next");
    }
}

- (void)clickScrollSelectPopViewBtn_previous_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    if(popview == _scrollSelectPopView_motion)
    {
        NSLog(@"clickScrollSelectPopViewBtn_previous");
        [self setLogText:@"clickScrollSelectPopViewBtn_previous"];
    }
}

- (void)clickScrollSelectPopViewBtn_confirm_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    if(popview == _scrollSelectPopView_motion)
    {
        NSLog(@"clickScrollSelectPopViewBtn_confirm");
        [self setLogText:@"clickScrollSelectPopViewBtn_confirm"];
    }
}

- (void)clickScrollSelectPopViewBtn_cancel_scrollSelectPopView:(ScrollSelectPopView *)popview selectedItemByGroupID:(NSInteger)groupIndex itemID:(NSInteger)itemIndex
{
    if(popview == _scrollSelectPopView_motion)
    {
        NSLog(@"clickScrollSelectPopViewBtn_cancel");
        [self setLogText:@"clickScrollSelectPopViewBtn_cancel"];
    }
}

// 选择的结果:groupIndex 组id，itemIndex 实体内容id
-(void) scrollSelectPopView:(ScrollSelectPopView *) popview selectedItemByGroupID:(NSInteger) groupIndex itemID: (NSInteger) itemIndex
{
    if(popview == _scrollSelectPopView_motion)
    {
        NSLog(@"%@", [NSString stringWithFormat:@"scrollSelectPopView itemIndex is :%ld", (long)itemIndex]);
        [self setLogText:[NSString stringWithFormat:@"scrollSelectPopView itemIndex is :%ld", (long)itemIndex]];
    }
}

#pragma mark - NumberInputLength6PopView Delegate

-(void) Zzz6NumberInputPopViewClickConfirmBtnWithMSG:(NSString *)msg
{
    NSLog(@"input number is %@:" ,msg);
}

-(void) Zzz6NumberInputPopViewClickCancelBtn
{
    NSLog(@"NumberInputLength6PopViewClickCancelBtn");
}

#pragma mark - ZzzBankCardChoosePopView Delegate
- (void) zzzBankCardChoosePopViewClickConfirmBtn
{
    [self setLogText:@"zzzBankCardChoosePopViewClickConfirmBtn"];
}

- (void) zzzBankCardChoosePopViewClickCancelBtn
{
    [self setLogText:@"zzzBankCardChoosePopViewClickCancelBtn"];
}

-(void) zzzBankCardChoosePopViewSelectedBankCard:(NSInteger) index
{
    [self setLogText:[NSString stringWithFormat:@"zzzBankCardChoosePopViewSelectedBankCard itemIndex is :%ld", (long)index]];
}

@end
