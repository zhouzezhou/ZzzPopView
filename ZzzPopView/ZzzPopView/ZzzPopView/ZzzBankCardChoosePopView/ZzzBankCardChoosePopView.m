//
//  ZzzBankCardChoosePopView.m
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/5/1.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "ZzzBankCardChoosePopView.h"
#import "Masonry.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define NAV_VC_HEIGHT (SCREEN_HEIGHT - ([UIApplication sharedApplication].statusBarFrame.size.height + 44))    // 减去导航栏和状态栏的高度后Navigation的高度

#define PRESENTATION_ANIMATION_DURATION 0.5
#define DISMISS_ANIMATION_DURATION 0.5

@interface ZzzBankCardChoosePopView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) float screenContent_height;       // 显示区域的高度，根据传进来的viewController判断
@property (nonatomic, strong) NSMutableArray<DataBankCardInfo *> *cardInfoArr;  // 银行卡信息数组
@property (nonatomic, assign) NSInteger selectedIndex;      // 选中的银行卡Index
@property (nonatomic, assign) BOOL showModeIsUpDown;        // 显示模式 - 是否为上下模式

/** 弹出框里面承载容器的视图 */
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *allBackgroudView;

@end

@implementation ZzzBankCardChoosePopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

+(ZzzBankCardChoosePopView *) popviewWithCardBankData:(NSMutableArray<DataBankCardInfo *> *) data
{
    return [[self alloc] initWithCardBankData:data];
}

-(ZzzBankCardChoosePopView *) initWithCardBankData:(NSMutableArray<DataBankCardInfo *> *) data
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.cardInfoArr = data;
        self.screenContent_height = SCREEN_HEIGHT;
        //        if(viewController.navigationController)
        //        {
        //            // test
        //            self.screenContent_height = SCREEN_HEIGHT;
        //
        ////            // 减去 导航栏 和 状态栏 的高度后NavigationView里内容的高度
        ////            self.screenContent_height = (SCREEN_HEIGHT - ([UIApplication sharedApplication].statusBarFrame.size.height + viewController.navigationController.navigationBar.bounds.size.height));
        //        }
        //        else
        //        {
        //            self.screenContent_height = SCREEN_HEIGHT;
        //        }
        
        // 弹出框后面的背景视图
        UIView *shawdowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.screenContent_height)];
        shawdowView.backgroundColor  = [UIColor blackColor];
        shawdowView.alpha = 0.6;
        [self addSubview:shawdowView];
        _allBackgroudView = shawdowView;
        
        // 承载容器的视图
        float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        NSLog(@"statusBarHeight is :%f", statusBarHeight);
        
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, self.screenContent_height * 0.33f , SCREEN_WIDTH, self.screenContent_height * 0.67f)];
        backgroudView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:backgroudView];
        _containerView = backgroudView;
        
        // 大小常量
        float titleViewHeight = 60.f;
        float offset = 10.f;
        float titleHeight = titleViewHeight - offset * 2;
        float tableviewHeight = self.screenContent_height * 0.67f - titleViewHeight;
        
        // 标题栏View(取消按钮 + 标题文字 + 确定按钮）
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"CancelBlackBtn.png"] forState:UIControlStateNormal];
        //        [cancelBtn setBackgroundColor:[UIColor redColor]];
        [backgroudView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(offset);
            make.top.mas_equalTo(backgroudView).with.offset(offset);
            make.height.mas_equalTo(titleHeight);
            //            make.bottom.mas_equalTo(backgroudView).with.offset(-offset);
        }];
        
        // 确定按钮
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setImage:[UIImage imageNamed:@"arrows_right"] forState:UIControlStateNormal];
        [backgroudView addSubview:confirmBtn];
        [confirmBtn setHidden:YES];
        [confirmBtn addTarget:self action:@selector(clickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(backgroudView).with.offset(-offset);
            make.top.mas_equalTo(backgroudView).with.offset(offset);
            make.height.mas_equalTo(titleHeight);
            //            make.bottom.mas_equalTo(backgroudView).with.offset(-offset);
        }];
        
        
        // 标题文字
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:@"选择银行卡"];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [backgroudView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backgroudView);
            make.height.mas_equalTo(titleViewHeight);
            make.top.mas_equalTo(backgroudView).with.offset(0);
        }];
        
        // 银行卡列表
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, titleViewHeight, SCREEN_WIDTH, tableviewHeight) style:UITableViewStyleGrouped];
        [tableview setDelegate:self];
        [tableview setDataSource:self];
        [tableview setEstimatedSectionHeaderHeight:0];
        [tableview setEstimatedSectionFooterHeight:0];
        //        [tableview setBackgroundColor:[UIColor redColor]];
        
        [backgroudView addSubview:tableview];
        
        
        // 底部按钮？
        
        
        
        // 底部文字信息？
        
    }
    return self;
}

// 展示在哪个视图上
- (void)showInView:(UIView *)view andShowModeUpDown:(BOOL) isUpDown
{
    self.showModeIsUpDown = isUpDown;
    if(isUpDown)
    {
        _containerView.alpha = 0;
        _allBackgroudView.alpha = 0;
        
        // 从下向上滑入
        CGRect oriFrame = CGRectMake(0, self.screenContent_height, SCREEN_WIDTH, self.screenContent_height * 0.67f);
        _containerView.frame = oriFrame;
        
        [view addSubview:self];
        
        //    _containerView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.containerView.alpha = 1.0f;
                             self.allBackgroudView.alpha = 0.6f;
                             
                             // 从下向上滑入
                             self.containerView.frame = CGRectMake(0, self.screenContent_height * 0.33f , SCREEN_WIDTH, self.screenContent_height * 0.67f);
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    else
    {
        _allBackgroudView.alpha = 0;
        // 从右向左滑入
        CGRect oriFrame = CGRectMake(SCREEN_WIDTH, self.screenContent_height * 0.33f , SCREEN_WIDTH, self.screenContent_height * 0.67f);
        _containerView.frame = oriFrame;
        
        [view addSubview:self];
        
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             // 从右向左滑入
                             self.containerView.frame = CGRectMake(0, self.screenContent_height * 0.33f , SCREEN_WIDTH, self.screenContent_height * 0.67f);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)dismiss {
    if(self.showModeIsUpDown)
    {
        [UIView animateWithDuration:DISMISS_ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             //                             _containerView.alpha = 0.0;
                             self.allBackgroudView.alpha = 0.0;
                             //                             self.alpha = 0.0;
                             
                             // 从上向下滑出
                             CGRect oriFrame = CGRectMake(0, self.screenContent_height, SCREEN_WIDTH, self.screenContent_height * 0.67f);
                             self.containerView.frame = oriFrame;
                             
                             // 从左向右滑出
                             //                         CGRect oriFrame = CGRectMake(SCREEN_WIDTH, self.screenContent_height * 0.33f , SCREEN_WIDTH, self.screenContent_height * 0.67f);
                             //                         _containerView.frame = oriFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                         }];
    }
    else
    {
        [UIView animateWithDuration:DISMISS_ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // 从左向右滑出
                             CGRect oriFrame = CGRectMake(SCREEN_WIDTH, self.screenContent_height * 0.33f , SCREEN_WIDTH, self.screenContent_height * 0.67f);
                             self.containerView.frame = oriFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                         }];
    }
}

#pragma mark - Tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardInfoArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCardBankSelecteTableViewControllerCell"];
    
    //    cell.textLabel.text = @"中国工商银行信用卡(782)";
    //    [cell.imageView setImage:[UIImage imageNamed:@"icon.png"]];
    
    // 银行卡信息
    DataBankCardInfo *temp = self.cardInfoArr[indexPath.row];
    if(temp.isSelected)
    {
        self.selectedIndex = indexPath.row;
    }
    
    [self chooseBankCardNormalViewData:temp gotoIconNamed:@"arrows_right.png" parentView:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DLog(@"selected indexpath is %@", indexPath);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 更新tableview
    if(indexPath.row != self.selectedIndex)
    {
        _cardInfoArr[indexPath.row].isSelected = YES;
        _cardInfoArr[self.selectedIndex].isSelected = NO;
        
        NSIndexPath *oriSelected = [NSIndexPath indexPathForItem:self.selectedIndex inSection:indexPath.section];
        NSArray<NSIndexPath *> *tempArr = [NSArray arrayWithObjects:indexPath, oriSelected, nil];
        [tableView reloadRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    // 代理方法传值回VC
    if([self.delegate respondsToSelector:@selector(zzzBankCardChoosePopViewSelectedBankCard:)])
    {
        [self.delegate zzzBankCardChoosePopViewSelectedBankCard:indexPath.row];
    }    
    
    [self dismiss];
}

#pragma mark - Private Mothed

// 普通模式的选择银行卡界面(银行logo + 银行卡信息 + 右侧小按钮)
-(UIView *) chooseBankCardNormalViewData:(DataBankCardInfo *)info gotoIconNamed:(NSString *) imgNamed parentView:(UIView *)parentView
{
    // 银行卡信息
    CGFloat leftMargin = 10.f;
    CGFloat iamgeInsetMargin = 10.f;
    
    //test
    //    [parentView setBackgroundColor:[UIColor greenColor]];
    
    // 银行logo
    UIImageView *bankIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:info.logoNamed]];
    [bankIcon setContentMode:UIViewContentModeScaleAspectFit];
    //    [imageView setBackgroundColor:[UIColor redColor]];
    [parentView addSubview: bankIcon];
    
    [bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(parentView).with.offset(leftMargin + 10.f);
        make.top.mas_equalTo(parentView).with.offset(iamgeInsetMargin);
        make.bottom.mas_equalTo(parentView).with.offset(-iamgeInsetMargin);
        make.width.mas_equalTo(parentView.mas_height).with.offset(-iamgeInsetMargin * 2);
    }];
    
    // 小箭头
    UIImageView *gotoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgNamed]];
    [gotoIcon setContentMode:UIViewContentModeScaleAspectFit];
    //    [imageView setBackgroundColor:[UIColor redColor]];
    [gotoIcon setHidden:!info.isSelected];
    [parentView addSubview: gotoIcon];
    
    [gotoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(parentView).with.offset(-leftMargin - 10.f);
        make.top.mas_equalTo(parentView).with.offset(iamgeInsetMargin);
        make.bottom.mas_equalTo(parentView).with.offset(-iamgeInsetMargin);
        make.width.mas_equalTo(14);
    }];
    
    // 银行卡信息（银行 + 类型 + 卡号）
    UILabel *bankLabel = [[UILabel alloc] init];
    NSString *text;
    // 计算得出卡后后几位
    NSString *bankCardNumber = info.bankCardNumber;
    if([bankCardNumber length] > 4)
    {
        // 除4取余，显示余下的部分（银行卡卡号长度为16或者19）
        int mod = fmod([bankCardNumber length], 4);
        //            DLog(@"mod is :%lu", (long)mod);
        if(mod == 0)
        {
            bankCardNumber = [bankCardNumber substringFromIndex:[bankCardNumber length] - 4];
        }
        else
        {
            bankCardNumber = [bankCardNumber substringFromIndex:[bankCardNumber length] - mod];
        }
    }
    
    // 不区别借贷记卡 2018年04月10日 Zzz
    text = [NSString stringWithFormat:@"%@ 尾号(%@)", info.bankName, bankCardNumber];
    
    [bankLabel setText:text];
    [bankLabel setTextColor:[UIColor blackColor]];
    [bankLabel setFont:[UIFont systemFontOfSize:12.f]];
    [bankLabel setTextAlignment:NSTextAlignmentLeft];
    [parentView addSubview:bankLabel];
    
    [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankIcon.mas_right).with.offset(leftMargin);
        make.top.mas_equalTo(parentView).with.offset(0);
        make.bottom.mas_equalTo(parentView).with.offset(0);
        make.right.mas_equalTo(parentView).with.offset(0);
    }];
    
    return parentView;
}

#pragma mark - Events

// 点击右上角关闭按钮,弹出框消失
- (void)clickCloseBtn {
    [self dismiss];
}

// 点击确定按钮，执行代理方法,弹出框消失
- (void)clickConfirmBtn {
    if ([self.delegate respondsToSelector:@selector(zzzBankCardChoosePopViewClickConfirmBtn)]) {
        [self.delegate zzzBankCardChoosePopViewClickConfirmBtn];
    }
    [self dismiss];
}

-(void) clickCancelBtn:(UIButton *) sender
{
    if ([self.delegate respondsToSelector:@selector(zzzBankCardChoosePopViewClickCancelBtn)]) {
        [self.delegate zzzBankCardChoosePopViewClickCancelBtn];
    }
    [self dismiss];
}

@end
