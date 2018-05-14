//
//  ZzzDateSelectPopview.m
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/5/14.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//
#import "ZzzDateSelectPopview.h"
#import "UITextField+DatePicker.h"
#import "NoCopyTextField.h"
#import "Masonry.h"



// 屏幕的宽度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
// 屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

// 系统状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height


#define PRESENTATION_ANIMATION_DURATION 0.5
#define DISMISS_ANIMATION_DURATION 0.5

#define UI_Color_MiddleGray COLOR(0xA2,0xA2,0xA2,1.f)               // 中等灰色,用于提示文字
#define UI_Color_ButtonBackgroudNormal COLOR(0x08,0x9F,0xE6,1.f)                 // 按钮背景颜色，蓝色089FE6

// 设置RGB颜色值
#define COLOR(R,G,B,A)    [UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:A]

#define UI_Color_ButtonTitleNormal [UIColor whiteColor]           // 按钮文字颜色

#define UI_PaddingLeft   20            // 左边距
#define UI_PaddingRight  UI_PaddingLeft// 右边距
#define UI_PaddingTop    5             // 上边距
#define UI_PaddingBottom UI_PaddingTop // 下边距

#define MSGLenght 6     // 短信验证码长度

@interface ZzzDateSelectPopview() <UITextFieldDelegate>

@property (nonatomic, assign) BOOL showModeIsUpDown;        // 显示模式 - 是否为上下模式

/** 弹出框里面承载容器的视图 */
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *allBackgroudView;

@property (nonatomic, strong) NoCopyTextField *startDateTextField;
@property (nonatomic, strong) NoCopyTextField *endDateTextField;

@property (nonatomic, strong) UIButton *confirmBtn;             // 支付按钮

@end

@implementation ZzzDateSelectPopview


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

// 初始化View
+(ZzzDateSelectPopview *) messagePopviewWithBtnTitle:(NSString *) btnTitle popViewTitle:(NSString *) popviewTitle popVuewDescrption:(NSString *) desc
{
    return [[self alloc] initWithBtnTitle:btnTitle popViewTitle:popviewTitle popVuewDescrption:desc];
}

-(ZzzDateSelectPopview *) initWithBtnTitle:(NSString *) btnTitle popViewTitle:(NSString *) popviewTitle popVuewDescrption:(NSString *) desc
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        //添加键盘弹出和收回的通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 弹出框后面的背景视图
        UIView *shawdowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        shawdowView.backgroundColor  = [UIColor blackColor];
        shawdowView.alpha = 0.6;
        [self addSubview:shawdowView];
        _allBackgroudView = shawdowView;
        
        // 承载容器的视图
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.68f , kScreenWidth, kScreenHeight * 0.32f)];
        backgroudView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:backgroudView];
        _containerView = backgroudView;
        
        // 大小常量
        float titleViewHeight = 60.f;
        float offset = 10.f;
        float titleHeight = titleViewHeight - offset * 2;
        //        float tableviewHeight = kScreenHeight * 0.46f - titleViewHeight;
        
        // 标题栏View(取消按钮 + 标题文字 + 确定按钮）
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"CancelBlackBtn.png"] forState:UIControlStateNormal];
        //        [cancelBtn setBackgroundColor:[UIColor redColor]];
        [backgroudView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(offset + 4);
            make.top.mas_equalTo(backgroudView).with.offset(offset);
            make.height.mas_equalTo(titleHeight);
            //            make.bottom.mas_equalTo(backgroudView).with.offset(-offset);
        }];
        
        
        // 标题文字
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setText:popviewTitle];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:18.f]];
        [backgroudView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backgroudView);
            make.height.mas_equalTo(titleViewHeight);
            make.top.mas_equalTo(backgroudView).with.offset(0);
        }];
        
        // 描述
        UILabel *payMoney = [[UILabel alloc] init];
        [payMoney setText:desc];
        [payMoney setTextColor:UI_Color_MiddleGray];
        [payMoney setTextAlignment:NSTextAlignmentCenter];
        [payMoney setFont:[UIFont systemFontOfSize:14.f]];
        [payMoney setNumberOfLines:0];
        [backgroudView addSubview:payMoney];
        [payMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backgroudView);
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(offset);
            make.left.mas_equalTo(backgroudView).with.offset(offset);
            make.right.mas_equalTo(backgroudView).with.offset(-offset);
        }];
        
        
        // 查询按钮
        self.confirmBtn = [[UIButton alloc] init];
        [self.confirmBtn setTitleColor:UI_Color_ButtonTitleNormal forState:UIControlStateNormal];
        //        [self.confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        //        [self.confirmBtn setBackgroundColor:UI_Color_ButtonBackgroudNormal];
        [self.confirmBtn setBackgroundColor:[UIColor grayColor]];
        [self.confirmBtn.layer setCornerRadius:4.0f];
        [self.confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.confirmBtn setEnabled:NO];
        [self.confirmBtn setTitle:btnTitle forState:UIControlStateNormal];
        [backgroudView addSubview:self.confirmBtn];
        [self.confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.center.mas_equalTo(parentView);
            make.left.mas_equalTo(backgroudView.mas_left).with.offset(UI_PaddingLeft);
            make.right.mas_equalTo(backgroudView.mas_right).with.offset(-UI_PaddingLeft);
            make.height.mas_equalTo(44.f);
            make.bottom.mas_equalTo(backgroudView.mas_bottom).with.offset(-UI_PaddingLeft);
        }];
        
        
        // 左侧 - 日期选择器
        UIView *datePickerView_left = [[UIView alloc] init];
        //        [datePickerView_left setBackgroundColor:[UIColor redColor]];
        [backgroudView addSubview:datePickerView_left];
        
        // 给datePickerView_left添加交互
        datePickerView_left.userInteractionEnabled = YES;
        UITapGestureRecognizer *viewTapGestureRecognizer_datePickerView_left = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTouchUpInside_datePickerView_left:)];
        [datePickerView_left addGestureRecognizer:viewTapGestureRecognizer_datePickerView_left];
        
        [datePickerView_left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(offset);
            make.top.mas_equalTo(payMoney.mas_bottom).with.offset(offset);
            make.bottom.mas_equalTo(self.confirmBtn.mas_top).with.offset(-offset);
            make.width.mas_equalTo((kScreenWidth - offset - offset) / 2);
        }];
        
        UILabel *startDateTextLabel = [[UILabel alloc] init];
        [startDateTextLabel setText:@"开始日期"];
        [startDateTextLabel setTextColor:[UIColor blackColor]];
        
        [startDateTextLabel setTextAlignment:NSTextAlignmentCenter];
        [startDateTextLabel setFont:[UIFont systemFontOfSize:16.f]];
        [startDateTextLabel setNumberOfLines:0];
        [datePickerView_left addSubview:startDateTextLabel];
        [startDateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(datePickerView_left);
            make.top.mas_equalTo(datePickerView_left.mas_top).with.offset(offset);
            make.left.mas_equalTo(startDateTextLabel);
            make.right.mas_equalTo(startDateTextLabel);
        }];
        
        // 日期选择器背景View
        UIView *datePickView_TextField = [[UIView alloc] init];
        //        [datePickView_TextField setBackgroundColor:[UIColor greenColor]];
        [datePickerView_left addSubview:datePickView_TextField];
        
        [datePickView_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerX.mas_equalTo(datePickerView_left);
            make.top.mas_equalTo(startDateTextLabel.mas_bottom).with.offset(offset);
            make.bottom.mas_equalTo(datePickerView_left.mas_bottom);
            make.left.mas_equalTo(datePickerView_left).with.offset(offset);
            make.right.mas_equalTo(datePickerView_left).with.offset(-offset);
        }];
        
        self.startDateTextField = [[NoCopyTextField alloc] init];
        //        [textField setPlaceholder: placeholder];
        [self.startDateTextField setTextColor:[UIColor blackColor]];
        [self.startDateTextField setFont:[UIFont systemFontOfSize:18]];
        [self.startDateTextField setClearButtonMode:UITextFieldViewModeNever];
        [self.startDateTextField setTextAlignment:NSTextAlignmentCenter];
        [self.startDateTextField setBorderStyle:UITextBorderStyleNone];
        [datePickView_TextField addSubview:self.startDateTextField];
        
        [self.startDateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(datePickView_TextField.mas_left).with.offset(0);
            make.right.mas_equalTo(datePickView_TextField.mas_right).with.offset(0);
            make.top.mas_equalTo(datePickView_TextField.mas_top).with.offset(UI_PaddingTop);
            make.bottom.mas_equalTo(datePickView_TextField.mas_bottom).with.offset(-UI_PaddingTop);
        }];
        
        self.startDateTextField.delegate = self;
        self.startDateTextField.datePickerInput = YES;
        
        // UITextField 下面的线条
        UIView *textFieldLine = [[UIView alloc] init];
        [textFieldLine setBackgroundColor:UI_Color_MiddleGray];
        [datePickView_TextField addSubview:textFieldLine];
        
        [textFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(datePickView_TextField.mas_left).with.offset(0);
            make.right.mas_equalTo(datePickView_TextField.mas_right).with.offset(0);
            make.bottom.mas_equalTo(datePickView_TextField.mas_bottom).with.offset(-1);
            make.height.mas_equalTo(1.f);
        }];
        
        
        
        // 右侧 - 日期选择器
        UIView *datePickerView_right = [[UIView alloc] init];
        //        [datePickerView_right setBackgroundColor:[UIColor redColor]];
        [backgroudView addSubview:datePickerView_right];
        
        [datePickerView_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(backgroudView).with.offset(-offset);
            make.top.mas_equalTo(payMoney.mas_bottom).with.offset(offset);
            make.bottom.mas_equalTo(self.confirmBtn.mas_top).with.offset(-offset);
            make.width.mas_equalTo((kScreenWidth - offset - offset) / 2);
        }];
        
        // 给datePickerView_left添加交互
        datePickerView_right.userInteractionEnabled = YES;
        UITapGestureRecognizer *viewTapGestureRecognizer_datePickerView_right = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTouchUpInside_datePickerView_right:)];
        [datePickerView_right addGestureRecognizer:viewTapGestureRecognizer_datePickerView_right];
        
        
        UILabel *endDateTextLabel = [[UILabel alloc] init];
        [endDateTextLabel setText:@"截止日期"];
        [endDateTextLabel setTextColor:[UIColor blackColor]];
        
        [endDateTextLabel setTextAlignment:NSTextAlignmentCenter];
        [endDateTextLabel setFont:[UIFont systemFontOfSize:16.f]];
        [endDateTextLabel setNumberOfLines:0];
        [datePickerView_right addSubview:endDateTextLabel];
        [endDateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(datePickerView_right);
            make.top.mas_equalTo(datePickerView_right.mas_top).with.offset(offset);
            make.left.mas_equalTo(endDateTextLabel);
            make.right.mas_equalTo(endDateTextLabel);
        }];
        
        // 日期选择器背景View
        UIView *datePickView_endTextField = [[UIView alloc] init];
        //        [datePickView_endTextField setBackgroundColor:[UIColor greenColor]];
        [datePickerView_right addSubview:datePickView_endTextField];
        
        [datePickView_endTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerX.mas_equalTo(datePickerView_right);
            make.top.mas_equalTo(endDateTextLabel.mas_bottom).with.offset(offset);
            make.bottom.mas_equalTo(datePickerView_right.mas_bottom);
            make.left.mas_equalTo(datePickerView_right).with.offset(offset);
            make.right.mas_equalTo(datePickerView_right).with.offset(-offset);
        }];
        
        self.endDateTextField = [[NoCopyTextField alloc] init];
        //        [textField setPlaceholder: placeholder];
        [self.endDateTextField setTextColor:[UIColor blackColor]];
        [self.endDateTextField setFont:[UIFont systemFontOfSize:18]];
        [self.endDateTextField setClearButtonMode:UITextFieldViewModeNever];
        [self.endDateTextField setTextAlignment:NSTextAlignmentCenter];
        [self.endDateTextField setBorderStyle:UITextBorderStyleNone];
        [datePickView_endTextField addSubview:self.endDateTextField];
        
        [self.endDateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(datePickView_endTextField.mas_left).with.offset(0);
            make.right.mas_equalTo(datePickView_endTextField.mas_right).with.offset(0);
            make.top.mas_equalTo(datePickView_endTextField.mas_top).with.offset(UI_PaddingTop);
            make.bottom.mas_equalTo(datePickView_endTextField.mas_bottom).with.offset(-UI_PaddingTop);
        }];
        
        self.endDateTextField.delegate = self;
        self.endDateTextField.datePickerInput = YES;
        
        // UITextField 下面的线条
        UIView *textFieldLine_end = [[UIView alloc] init];
        [textFieldLine_end setBackgroundColor:UI_Color_MiddleGray];
        [datePickView_endTextField addSubview:textFieldLine_end];
        
        [textFieldLine_end mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(datePickView_endTextField.mas_left).with.offset(0);
            make.right.mas_equalTo(datePickView_endTextField.mas_right).with.offset(0);
            make.bottom.mas_equalTo(datePickView_endTextField.mas_bottom).with.offset(-1);
            make.height.mas_equalTo(1.f);
        }];
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
        CGRect oriFrame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight * 0.46f);
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
                             self.containerView.frame = CGRectMake(0, kScreenHeight * 0.68f , kScreenWidth, kScreenHeight * 0.32f);
                         } completion:^(BOOL finished) {
                             //                             [self.msgTextField becomeFirstResponder];
                         }];
        
    }
    else
    {
        _allBackgroudView.alpha = 0;
        // 从右向左滑入
        CGRect oriFrame = CGRectMake(kScreenWidth, kScreenHeight * 0.68f , kScreenWidth, kScreenHeight * 0.32f);
        _containerView.frame = oriFrame;
        
        [view addSubview:self];
        
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             // 从右向左滑入
                             self.containerView.frame = CGRectMake(0, kScreenHeight * 0.68f , kScreenWidth, kScreenHeight * 0.32f);
                         } completion:^(BOOL finished) {
                             //                             [self.msgTextField becomeFirstResponder];
                         }];
    }
}

- (void)dismiss {
    if([self.startDateTextField isFirstResponder])
    {
        [self.startDateTextField resignFirstResponder];
    }
    
    if([self.endDateTextField isFirstResponder])
    {
        [self.endDateTextField resignFirstResponder];
    }
    
    if(self.showModeIsUpDown)
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
                             
                             // 从上向下滑出
                             CGRect oriFrame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight * 0.46f);
                             self.containerView.frame = oriFrame;
                             
                             // 从左向右滑出
                             //                         CGRect oriFrame = CGRectMake(kScreenWidth, kScreenHeight * 0.68f , kScreenWidth, kScreenHeight * 0.46f);
                             //                         _containerView.frame = oriFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                         }];
    }
    else
    {
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             // 从左向右滑出
                             CGRect oriFrame = CGRectMake(kScreenWidth, kScreenHeight * 0.68f , kScreenWidth, kScreenHeight * 0.32f);
                             self.containerView.frame = oriFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                         }];
    }
}

#pragma mark - Private Mothed

//-(void) endMSGInput
//{
//    [self.msgTextField resignFirstResponder];
//
//    if([self.delegate respondsToSelector:@selector(ZzzDateSelectPopviewClickConfirmBtnWithMSG:)])
//    {
//        [self.delegate ZzzDateSelectPopviewClickConfirmBtnWithMSG:self.msgTextField.text];
//    }
//    self.showModeIsUpDown = YES;
//    [self dismiss];
//}

#pragma mark - Events
// 支付按钮
- (void)clickConfirmBtn:(UIButton *) sender
{
    NSLog(@"点击了查询按钮");
    
    if([self.delegate respondsToSelector:@selector(ZzzDateSelectPopviewDelegateClickConfirmBtnWithStartDate:AndEndDate:)])
    {
        [self.delegate ZzzDateSelectPopviewDelegateClickConfirmBtnWithStartDate:self.startDateTextField.text AndEndDate:self.endDateTextField.text];
    }
    [self dismiss];
}

// 取消按钮
-(void) clickCancelBtn:(UIButton *) sender
{
    //    [self.msgTextField resignFirstResponder];
    
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(ZzzDateSelectPopviewClickCancelBtn)])
    {
        [self.delegate ZzzDateSelectPopviewClickCancelBtn];
    }
}


-(void) viewTouchUpInside_datePickerView_left :(UITapGestureRecognizer *)recognizer
{
    if(![self.startDateTextField isFirstResponder])
    {
        [self.startDateTextField becomeFirstResponder];
    }
}


-(void) viewTouchUpInside_datePickerView_right :(UITapGestureRecognizer *)recognizer
{
    if(![self.endDateTextField isFirstResponder])
    {
        [self.endDateTextField becomeFirstResponder];
    }
}




// 短信验证码输入框成为第一响应者
//- (void)touchBegin
//{
//    [self.msgTextField becomeFirstResponder];
//}

// 监听，输入文字
//- (void)txChange:(UITextField*)tx
//{
//    NSString *text = tx.text;
//
//    // 这里可以监听,当输入的位置达到要求时
//    if (text.length >= _msgButtonArray.count)
//    {
//        [self.confirmBtn setEnabled:YES];
//        [self.confirmBtn setBackgroundColor:UI_Color_ButtonBackgroudNormal];
//        //        [self endMSGInput];
//    }
//    else
//    {
//        [self.confirmBtn setEnabled:NO];
//        [self.confirmBtn setBackgroundColor:[UIColor grayColor]];
//    }
//
//    //    DLog(@"text lenght is %ld", tx.text.length);
//    //    DLog(@"new Pad number is %@", [tx.text substringWithRange:NSMakeRange(tx.text.length - 1, 1)]);
//
//    // 删除输入的多余字符
//    if(text.length > _msgButtonArray.count)
//    {
//        tx.text = [tx.text substringWithRange:NSMakeRange(0, _msgButtonArray.count)];
//    }
//    //    DLog(@"text is %@", tx.text);
//
//    for (int i = 0; i < _msgButtonArray.count; i++)
//    {
//        UIButton *btn = [_msgButtonArray objectAtIndex:i];
//        NSString *str = @"";
//        if (i < text.length)
//        {
//            if(_isSecureTextEntry)
//            {
//                str = @"*";
//            }
//            else
//            {
//                str = [text substringWithRange:NSMakeRange(i, 1)];
//            }
//
//        }
//        [btn setTitle:str forState:UIControlStateNormal];
//
//
//
//
//    }
//}

#pragma mark - Notification

// 收到键盘弹出通知后的响应
- (void)keyboardWillShow:(NSNotification *)info {
    
    //保存info
    NSDictionary *dict = info.userInfo;
    //得到键盘的显示完成后的frame
    CGRect keyboardBounds = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //得到键盘弹出动画的时间
    double duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //坐标系转换
    //由于取出的位置信息是绝对的，所以要将其转换为对应于当前view的位置，否则位置信息会出错！
    CGRect keyboardBoundsRect = [self convertRect:keyboardBounds toView:nil];
    //得到键盘的高度，即输入框需要移动的距离
    double offsetY = keyboardBoundsRect.size.height;
    //得到键盘动画的曲线信息，按原作的话说“此处是难点”，stackoverflow网站里找到的
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    //添加动画
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, -offsetY);
    } completion:nil];
    
}

// 隐藏键盘通知的响应
- (void)keyboardWillHide:(NSNotification *)info {
    //输入框回去的时候就不需要高度了，直接取动画时间和曲线还原回去
    NSDictionary *dict = info.userInfo;
    double duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    //CGAffineTransformIdentity是置位，可将改变的transform还原
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.containerView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

#pragma mark - UITextFieldDelegate

// textfield成为第一响应者时将日期显示出来
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.text.length == 0)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年 MM月 dd日"];
        NSString *dateStr = [formatter stringFromDate:[UITextField sharedDatePicker].date];
        textField.text = dateStr;
        
        [self isRightDateInputByTextfield:textField replacementString:dateStr];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 判断日期是否填写正确
    //    NSLog(@"string %@", string);
    [self isRightDateInputByTextfield:textField replacementString:string];
    
    return YES;
}

-(void) isRightDateInputByTextfield:(UITextField *)textfield replacementString:(NSString *)string
{
    if(textfield == self.startDateTextField)
    {
        if(self.endDateTextField.text.length != 0)
        {
            [self.confirmBtn setEnabled:YES];
            [self.confirmBtn setBackgroundColor:UI_Color_ButtonBackgroudNormal];
        }
    }
    else
    {
        if(self.startDateTextField.text.length != 0)
        {
            [self.confirmBtn setEnabled:YES];
            [self.confirmBtn setBackgroundColor:UI_Color_ButtonBackgroudNormal];
        }
    }
}

@end


