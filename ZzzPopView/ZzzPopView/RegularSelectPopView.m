//
//  RegularSelectPopView.m
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/27.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "RegularSelectPopView.h"
#import "Masonry.h"

// 屏幕的宽度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
// 屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
// 系统状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

// 设置RGB颜色值
#define COLOR(R,G,B,A)    [UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:A]

#define PRESENTATION_ANIMATION_DURATION 0.5
#define DISMISS_ANIMATION_DURATION 0.5
#define PADDING 10.f
#define TITLEFONTSIZE 20
#define TITLEFONTSIZE_ALONE 30      // 只有标题时的字体大小，以后修改为动态计算获得 20180306
#define DESCRIPTFONTSIZE 15

@interface RegularSelectPopView() <UITableViewDelegate, UITableViewDataSource>

/** 弹出框里面承载容器的视图 */
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *allBackgroudView;

@property (nonatomic, strong) UITableView *tableview;           // 承载内容的Tableview

@property (nonatomic, strong) DataRegularSelect *regularSelectData;
@property (nonatomic, assign) NSInteger showingItemIndex;      // 正在显示的行ID，对应rowID
@property (nonatomic, assign) float backgroudViewWidth;      // 白色背景层宽度
@property (nonatomic, assign) float backgroudViewHeight;      // 白色背景层高度
@property (nonatomic, assign) float selectedImgWidth;           // 选中图片的宽度
@property (nonatomic, assign) float titleFontSize;              // 标题文字大小
@property (nonatomic, assign) float descriptFontSize;           // 描述文字大小

@end

@implementation RegularSelectPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

// 初始化View
+(RegularSelectPopView *) popviewWithRegularSelectData:(DataRegularSelect *) data
{
    return [[self alloc] initWithRegularSelectData:data];
}

-(RegularSelectPopView *) initWithRegularSelectData:(DataRegularSelect *) data
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // 保存数据
        _regularSelectData = data;
        
        // 弹出框后面的背景视图
        UIView *shawdowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        shawdowView.backgroundColor  = [UIColor blackColor];
        shawdowView.alpha = 0.6;
        [self addSubview:shawdowView];
        _allBackgroudView = shawdowView;
        
        shawdowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *shawdowViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shawdowViewTouchUpInside:)];
        [shawdowView addGestureRecognizer:shawdowViewTapGestureRecognizer];
        
        
        // 初始化数据
        _showingItemIndex = 0;
        
        // 大小常量
        float btnFontSize = 15;                 // 按钮字体大小
        float paddingLeft = 10.f;               // 左边距
        _selectedImgWidth = 20.f;          // 选中图片宽度
        _backgroudViewWidth = kScreenWidth * 0.5f; // 白色背景层宽度
        _backgroudViewHeight = kScreenHeight - kStatusBarHeight;      // 白色背景层高度
        _titleFontSize = 30.f;
        _descriptFontSize = 18.f;

        // 承载容器的视图,注意：修改此处需同时修改show和dimiss
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(_backgroudViewWidth, kStatusBarHeight, _backgroudViewWidth, _backgroudViewHeight)];
        backgroudView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:backgroudView];
        _containerView = backgroudView;
        
        // Tableview
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _backgroudViewWidth, _backgroudViewHeight - paddingLeft - 30.f) style:UITableViewStyleGrouped];
        [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableview setDelegate:self];
        [_tableview setDataSource:self];
        [_tableview setEstimatedSectionHeaderHeight:0];
        [_tableview setEstimatedSectionFooterHeight:0];
        [backgroudView addSubview:_tableview];
        
        // 底部按钮：上一个、完成、下一个
        // 上一个
        UIButton *priviousBtn = [[UIButton alloc] init];
        [priviousBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [priviousBtn setBackgroundColor:[UIColor whiteColor]];
        [priviousBtn.layer setCornerRadius:4.0f];
        [priviousBtn.titleLabel setFont:[UIFont systemFontOfSize:btnFontSize]];
        [priviousBtn setTitle:@"上一个" forState:UIControlStateNormal];
        [priviousBtn addTarget:self action:@selector(btnClick_priviousBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backgroudView addSubview:priviousBtn];
        
        [priviousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView.mas_left).with.offset(paddingLeft);
            //                    make.right.mas_equalTo(backgroudView.mas_right).with.offset(-UI_PaddingLeft);
            //                    make.top.mas_equalTo(backgroudView.mas_top);
            make.bottom.mas_equalTo(backgroudView.mas_bottom).with.offset(-paddingLeft);
        }];
        
        // 根据要求显示或隐藏按钮
        if(data.isShowPriviouBtn)
        {
            [priviousBtn setHidden:NO];
        }
        else
        {
            [priviousBtn setHidden:YES];
        }
        
        // 完成
        UIButton *confirmBtn = [[UIButton alloc] init];
        [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [confirmBtn setBackgroundColor:[UIColor whiteColor]];
        [confirmBtn.layer setCornerRadius:4.0f];
        [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:btnFontSize]];
        [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [backgroudView addSubview:confirmBtn];
        
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backgroudView);
            //                    make.left.mas_equalTo(backgroudView.mas_left).with.offset(10.f);
            //                    make.right.mas_equalTo(backgroudView.mas_right).with.offset(-UI_PaddingLeft);
            //                    make.top.mas_equalTo(backgroudView.mas_top);
            make.bottom.mas_equalTo(backgroudView.mas_bottom).with.offset(-paddingLeft);
        }];
        
        [confirmBtn addTarget:self action:@selector(btnClick_confirm:) forControlEvents:UIControlEventTouchUpInside];
        
        // 根据要求显示或隐藏按钮
        if(data.isShowConfirmBtn)
        {
            [confirmBtn setHidden:NO];
        }
        else
        {
            [confirmBtn setHidden:YES];
        }
        
        // 下一个
        UIButton *nextBtn = [[UIButton alloc] init];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:[UIColor whiteColor]];
        [nextBtn.layer setCornerRadius:4.0f];
        [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:btnFontSize]];
        [nextBtn setTitle:@"下一个" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(btnClick_nextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backgroudView addSubview:nextBtn];
        
        [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //                    make.left.mas_equalTo(backgroudView.mas_left).with.offset(10.f);
            make.right.mas_equalTo(backgroudView.mas_right).with.offset(-paddingLeft);
            //                    make.top.mas_equalTo(backgroudView.mas_top);
            make.bottom.mas_equalTo(backgroudView.mas_bottom).with.offset(-paddingLeft);
        }];
        
        // 根据要求显示或隐藏按钮
        if(data.isShowNextBtn)
        {
            [nextBtn setHidden:NO];
        }
        else
        {
            [nextBtn setHidden:YES];
        }
    }
    return self;
}

// 展示在哪个视图上
- (void)showInView:(UIView *)view
{
    _containerView.alpha = 0;
    _allBackgroudView.alpha = 0;
    
    // 从下向上滑入
//    CGRect oriFrame = CGRectMake(kScreenWidth * 0.5f, kScreenHeight, _backgroudViewWidth, _backgroudViewHeight);
    // 从右向左滑入
    CGRect oriFrame = CGRectMake(kScreenWidth, kStatusBarHeight, _backgroudViewWidth, _backgroudViewHeight);
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
                         self.containerView.frame = CGRectMake(kScreenWidth * 0.5f, kStatusBarHeight, self.backgroudViewWidth, self.backgroudViewHeight);
                     } completion:^(BOOL finished) {
                         //                         [_pickerView selectRow:row inComponent:component animated:NO];
                     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         //                             _containerView.alpha = 0.0;
                         self.allBackgroudView.alpha = 0.0;
                         //                             self.alpha = 0.0;
                         
                         // 从左向右滑出
                         CGRect oriFrame = CGRectMake(kScreenWidth, kStatusBarHeight, self.backgroudViewWidth, self.backgroudViewHeight);
                         self.containerView.frame = oriFrame;
                         
                         // 从左向右滑出
                         //                         CGRect oriFrame = CGRectMake(kScreenWidth, self.screenContent_height * 0.33f , kScreenWidth, self.screenContent_height * 0.67f);
                         //                         _containerView.frame = oriFrame;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
}

#pragma mark - Event
-(void) btnClick_confirm:(id) sender
{
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(clickRegularSelectPopViewBtn_confirm_regularSelectPopView:selectedItemByID:)])
    {
        [self.delegate clickRegularSelectPopViewBtn_confirm_regularSelectPopView:self selectedItemByID:_regularSelectData.selectedRowID];
    }
}

-(void) btnClick_priviousBtn:(id) sender
{
    if([self.delegate respondsToSelector:@selector(clickRegularSelectPopViewBtn_previous_regularSelectPopView:selectedItemByID:)])
    {
        [self.delegate clickRegularSelectPopViewBtn_previous_regularSelectPopView:self selectedItemByID:_regularSelectData.selectedRowID];
    }
}

-(void) btnClick_nextBtn:(id) sender
{
    if([self.delegate respondsToSelector:@selector(clickRegularSelectPopViewBtn_next_regularSelectPopView:selectedItemByID:)])
    {
        [self.delegate clickRegularSelectPopViewBtn_next_regularSelectPopView:self selectedItemByID:_regularSelectData.selectedRowID];
    }
}

// 灰色半透明背景层被点击
-(void) shawdowViewTouchUpInside:(UITapGestureRecognizer *)recognizer
{
    [self dismiss];
    
    if([self.delegate respondsToSelector:@selector(clickRegularSelectPopViewBtn_cancel_regularSelectPopView:selectedItemByID:)])
    {
        [self.delegate clickRegularSelectPopViewBtn_cancel_regularSelectPopView:self selectedItemByID:_regularSelectData.selectedRowID];
    }
}

#pragma mark - Protocol Tableview Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_regularSelectData.data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据内容计算高度
    // 计算详细内容显示所需的高度
//    NSString *contentHeight = _regularSelectData.data[indexPath.row].name;
//    CGSize sizeHeight =[contentHeight sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TITLEFONTSIZE]}];
    
    float descriptViewWidth = tableView.bounds.size.width - 4 * PADDING;
    float cellHeight = 0;
    // 详细描述内容为空
    if([_regularSelectData.data[indexPath.row].decript length] == 0)
    {
        cellHeight = descriptViewWidth / 2;
    }
    // 详细描述内容不为空
    else
    {
        CGSize textSize         = CGSizeMake(descriptViewWidth, MAXFLOAT);
        CGSize nameSize             = [_regularSelectData.data[indexPath.row].name boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TITLEFONTSIZE],NSFontAttributeName, nil] context:nil].size;
        CGSize descriptSize             = [_regularSelectData.data[indexPath.row].decript boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:DESCRIPTFONTSIZE],NSFontAttributeName, nil] context:nil].size;
        cellHeight = PADDING * 2 + nameSize.height + PADDING * 2 + descriptSize.height + PADDING * 2;
    }
    
//    NSLog(@"cell height is :%f", PADDING + nameSize.height + PADDING);
    return cellHeight;
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegularSelectPopViewCellreuseIdentifier"];
    
//    [cell setBackgroundColor:[UIColor orangeColor]];
    
    // 背景
    UIView *backgroudView = [[UIView alloc] init];
    [backgroudView setBackgroundColor:COLOR(0XF6,0XF6,0XF6,1)];
    [cell addSubview:backgroudView];
    
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).with.offset(PADDING);
        make.right.mas_equalTo(cell).with.offset(-PADDING);
        make.top.mas_equalTo(cell).with.offset(PADDING);
        make.bottom.mas_equalTo(cell).with.offset(-PADDING);
    }];
    
    // 被选中时的亮色边框
//    UIView *selectedBorderView = [[UIView alloc] init];
    
    
    if([_regularSelectData.data[indexPath.row].decript length] == 0)
    {
        // 标题Label
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:_regularSelectData.data[indexPath.row].name];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont: [UIFont systemFontOfSize:TITLEFONTSIZE_ALONE]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [titleLabel setBackgroundColor:[UIColor blueColor]];
        [backgroudView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(PADDING);
            make.right.mas_equalTo(backgroudView).with.offset(-PADDING);
            make.top.mas_equalTo(backgroudView).with.offset(PADDING);
            make.bottom.mas_equalTo(backgroudView).with.offset(-PADDING);
        }];
    }
    // 详细描述内容不为空
    else
    {
        // 标题Label的size
        float descriptViewWidth = tableView.bounds.size.width - 4 * PADDING;
        CGSize textSize         = CGSizeMake(descriptViewWidth, MAXFLOAT);
        CGSize size             = [_regularSelectData.data[indexPath.row].name boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TITLEFONTSIZE],NSFontAttributeName, nil] context:nil].size;
        // 标题Label
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:_regularSelectData.data[indexPath.row].name];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont: [UIFont systemFontOfSize:TITLEFONTSIZE]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [titleLabel setBackgroundColor:[UIColor blueColor]];
        [backgroudView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(PADDING);
            make.right.mas_equalTo(backgroudView).with.offset(-PADDING);
            make.top.mas_equalTo(backgroudView).with.offset(PADDING);
            make.height.mas_equalTo(size.height);
        }];
        
        // 详细内容Label
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setNumberOfLines:0];
        [descriptionLabel setText:_regularSelectData.data[indexPath.row].decript];
        [descriptionLabel setTextColor:[UIColor blackColor]];
        [descriptionLabel setFont: [UIFont systemFontOfSize:DESCRIPTFONTSIZE]];
        //    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [descriptionLabel setBackgroundColor:[UIColor redColor]];
        [backgroudView addSubview:descriptionLabel];
        
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(PADDING);
            make.right.mas_equalTo(backgroudView).with.offset(-PADDING);
            make.top.mas_equalTo(titleLabel.mas_bottom);
            make.bottom.mas_equalTo(backgroudView).with.offset(-PADDING);
        }];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"selected indexpath is %@", indexPath);
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if([self.delegate respondsToSelector:@selector(regularSelectPopView:selectedItemByID:)])
    {
        [self.delegate regularSelectPopView:self selectedItemByID:indexPath.row];
    }
    
    
    // 更新_tableview
//    if(indexPath.row != self.selectedIndex)
//    {
//        _cardInfoArr[indexPath.row].isSelected = YES;
//        _cardInfoArr[self.selectedIndex].isSelected = NO;
//
//        NSIndexPath *oriSelected = [NSIndexPath indexPathForItem:self.selectedIndex inSection:indexPath.section];
//        NSArray<NSIndexPath *> *tempArr = [NSArray arrayWithObjects:indexPath, oriSelected, nil];
//        [tableView reloadRowsAtIndexPaths:tempArr withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//
//    // 代理方法传值回VC
//    [self.delegate chooseBankCardSelectedBankCard:indexPath.row];
//
//    [self dismiss];
}

@end
