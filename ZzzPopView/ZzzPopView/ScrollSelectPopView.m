//
//  ScrollSelectPopView.m
//  ExerciseRecord
//
//  Created by zhouzezhou on 2018/2/24.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "ScrollSelectPopView.h"
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

@interface ScrollSelectPopView() <UIPickerViewDataSource, UIPickerViewDelegate>

/** 弹出框里面承载容器的视图 */
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *allBackgroudView;

@property (nonatomic, strong) UIPickerView *pickerView;         // pickerview

@property (nonatomic, strong) DataScrollSelect *pickViewData;
@property (nonatomic, assign) NSInteger showingItemIndex;      // 正在显示的行ID，对应rowID
@property (nonatomic, assign) float backgroudViewWidth;      // 白色背景层宽度
@property (nonatomic, assign) float backgroudViewHeight;      // 白色背景层高度
@property (nonatomic, assign) float selectedImgWidth;           // 选中图片的宽度
@property (nonatomic, assign) float pickviewWidth;              // pickview的宽度
@property (nonatomic, assign) float pickviewHeight;              // pickview的高度
@property (nonatomic, assign) float pickviewRowHeight;          // pickview的Row高度

@end

@implementation ScrollSelectPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

// 初始化View
+(ScrollSelectPopView *) popviewWithScrollSelectData:(DataScrollSelect *) data
{
    return [[self alloc] initWithScrollSelectData:data];
}

-(ScrollSelectPopView *) initWithScrollSelectData:(DataScrollSelect *) data
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // 保存数据
        _pickViewData = data;
        
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
        //                _pickviewWidth = _backgroudViewWidth - paddingLeft - _selectedImgWidth;
        _pickviewWidth = _backgroudViewWidth;
        
        NSString *contentHeight = @"重";
        CGSize sizeHeight =[contentHeight sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:btnFontSize]}];
        _pickviewHeight = 2 * (_backgroudViewHeight - paddingLeft - sizeHeight.height);
        if(!data.isShowNextBtn && !data.isShowConfirmBtn && !data.isShowPriviouBtn)
        {
            _pickviewHeight = 2 * (_backgroudViewHeight);
        }
        _pickviewRowHeight = _backgroudViewHeight / 15;
        
        // 承载容器的视图,注意：修改此处需同时修改show和dimiss
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.5f, kStatusBarHeight, _backgroudViewWidth, _backgroudViewHeight)];
        backgroudView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:backgroudView];
        _containerView = backgroudView;
        
        // PickerView
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView setBackgroundColor:[UIColor clearColor]];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_pickerView setShowsSelectionIndicator:NO];
        [backgroudView addSubview:_pickerView];
        
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(backgroudView).with.offset(-(self.pickviewHeight / 4));
            make.left.mas_equalTo(backgroudView);
            make.right.mas_equalTo(backgroudView.mas_right);
            make.height.mas_equalTo(self.pickviewHeight);
        }];
    
        // 默认选中项
        [self.pickerView selectRow:data.selectedRowID inComponent:0 animated:NO];
        
        // 选中按钮
        UIImageView *selectedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows_right"]];
//        [selectedImg setBackgroundColor:[UIColor redColor]];
//        [selectedImg setImage:[UIImage imageNamed:@"selectedImg"]];
        [backgroudView addSubview:selectedImg];
        
        [selectedImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView.mas_left).with.offset(paddingLeft);
            make.centerY.mas_equalTo(self.pickerView);
            make.width.mas_equalTo(self.selectedImgWidth);
            make.height.mas_equalTo(self.selectedImgWidth);
        }];
        
        
        // 底部按钮：上一个、完成、下一个

        
        // 根据要求显示或隐藏按钮
        if(data.isShowPriviouBtn)
        {
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
            
            [priviousBtn setHidden:NO];
        }
//        else
//        {
//            [priviousBtn setHidden:YES];
//        }
        
        

        
        // 根据要求显示或隐藏按钮
        if(data.isShowConfirmBtn)
        {
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
            
            [confirmBtn setHidden:NO];
        }
//        else
//        {
//            [confirmBtn setHidden:YES];
//        }
        

        
        
        // 根据要求显示或隐藏按钮
        if(data.isShowNextBtn)
        {
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
            
            [nextBtn setHidden:NO];
        }
//        else
//        {
//            [nextBtn setHidden:YES];
//        }
    }
    return self;
}

// 选中某行
-(void) selectRow:(NSUInteger)selectedRowID
{
    [_pickerView selectRow:selectedRowID inComponent:0 animated:NO];
}

// 展示在哪个视图上
- (void)showInView:(UIView *)view
{
    _containerView.alpha = 0;
    _allBackgroudView.alpha = 0;
    
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
                         
                         // 从右向左滑入
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

#pragma mark - Protocol UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickViewData.arrData count];
}

#pragma mark - Protocol UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _pickviewRowHeight;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return _pickviewWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc] init];
    }
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(0, 0, _pickviewWidth, _pickviewRowHeight);
    textLabel.textAlignment = NSTextAlignmentCenter;
    // 根据不同的类型使用不同的方式得到显示的内容
    textLabel.text = (NSString *)_pickViewData.arrData[row];
    textLabel.font = [UIFont systemFontOfSize:18];
    textLabel.textColor = COLOR(51, 51, 51, 1);
    [view addSubview:textLabel];
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(scrollSelectPopView:selectedItemByGroupID:itemID:)])
    {
        [self.delegate scrollSelectPopView:self selectedItemByGroupID:component itemID:row];
    }
}

#pragma mark - Event
-(void) btnClick_confirm:(id) sender
{
    [self dismiss];
        
    if([self.delegate respondsToSelector:@selector(clickScrollSelectPopViewBtn_confirm_scrollSelectPopView:selectedItemByGroupID:itemID:)])
    {
        [self.delegate clickScrollSelectPopViewBtn_confirm_scrollSelectPopView:self selectedItemByGroupID:[self.pickerView selectedRowInComponent:0] itemID: 0];
    }
}

-(void) btnClick_priviousBtn:(id) sender
{
    if([self.delegate respondsToSelector:@selector(clickScrollSelectPopViewBtn_previous_scrollSelectPopView:selectedItemByGroupID:itemID:)])
    {
        [self.delegate clickScrollSelectPopViewBtn_previous_scrollSelectPopView:self selectedItemByGroupID:[self.pickerView selectedRowInComponent:0] itemID: 0];
    }
}

-(void) btnClick_nextBtn:(id) sender
{
    if([self.delegate respondsToSelector:@selector(clickScrollSelectPopViewBtn_next_scrollSelectPopView:selectedItemByGroupID:itemID:)])
    {
        [self.delegate clickScrollSelectPopViewBtn_next_scrollSelectPopView:self selectedItemByGroupID:[self.pickerView selectedRowInComponent:0] itemID: 0];
    }
}

// 灰色半透明背景层被点击
-(void) shawdowViewTouchUpInside:(UITapGestureRecognizer *)recognizer
{
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(clickScrollSelectPopViewBtn_cancel_scrollSelectPopView:selectedItemByGroupID:itemID:)])
    {
        [self.delegate clickScrollSelectPopViewBtn_cancel_scrollSelectPopView:self selectedItemByGroupID:0 itemID:[self.pickerView selectedRowInComponent:0]];
    }
    
}

@end
