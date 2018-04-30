//
//  Zzz6NumberInputPopView.m
//  ZzzPopView
//
//  Created by zhouzezhou on 2018/4/30.
//  Copyright © 2018年 zhouzezhou. All rights reserved.
//

#import "Zzz6NumberInputPopView.h"
#import "Masonry.h"
#import "XTYRandomKeyboard.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// 设置RGB颜色值
#define COLOR(R,G,B,A)    [UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:A]
#define PRESENTATION_ANIMATION_DURATION 0.5
#define UI_Padding   20
#define MSGLenght 6     // 输入框长度

@interface Zzz6NumberInputPopView()

@property (nonatomic, assign) BOOL showModeIsUpDown;        // 显示模式 - 是否为上下模式

/** 弹出框里面承载容器的视图 */
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *allBackgroudView;
@property (nonatomic, strong) UITextField *msgTextField;        // 输入框输入框
@property (nonatomic, strong) UIButton *confirmBtn;             // 确定按钮
@property (nonatomic, strong) NSMutableArray *msgButtonArray;   // 输入框显示按钮
// 是否为安全输入模式，YES输入的字符显示为星号（*），NO输入什么就显示什么
@property (nonatomic, assign) BOOL isSecureTextEntry;

@end

@implementation Zzz6NumberInputPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    
    return self;
}

// 初始化View
+(Zzz6NumberInputPopView *) messagePopviewWithBtnTitle:(NSString *) btnTitle popViewTitle:(NSString *) popviewTitle popVuewDescrption:(NSString *) desc hintText:(NSString *)hintText isSecureTextEntry:(BOOL) isSecret
{
    return [[self alloc] initWithBtnTitle:btnTitle popViewTitle:popviewTitle popVuewDescrption:desc hintText:hintText isSecureTextEntry:isSecret];
}

-(Zzz6NumberInputPopView *) initWithBtnTitle:(NSString *) btnTitle popViewTitle:(NSString *) popviewTitle popVuewDescrption:(NSString *) desc hintText:(NSString *)hintText  isSecureTextEntry:(BOOL) isSecret
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _isSecureTextEntry = isSecret;
        
        //添加键盘弹出和收回的通知
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 弹出框后面的背景视图
        UIView *shawdowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        shawdowView.backgroundColor  = [UIColor blackColor];
        shawdowView.alpha = 0.6;
        [self addSubview:shawdowView];
        _allBackgroudView = shawdowView;
        
        shawdowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *shawdowViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickshawdowView)];
        [shawdowView addGestureRecognizer:shawdowViewTapGestureRecognizer];
        
        // 承载容器的视图
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.54f , SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f)];
        backgroudView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:backgroudView];
        _containerView = backgroudView;
        
        // 大小常量
        float titleViewHeight = 60.f;
        float offset = 10.f;
        float titleHeight = titleViewHeight - offset * 2;
        //        float tableviewHeight = SCREEN_HEIGHT * 0.46f - titleViewHeight;
        
        // 标题栏View(取消按钮 + 标题文字 + 确定按钮）
        // 取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setImage:[UIImage imageNamed:@"CancelBlackBtn"] forState:UIControlStateNormal];
        [backgroudView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(offset);
            make.top.mas_equalTo(backgroudView).with.offset(offset);
            make.height.mas_equalTo(titleHeight);
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
        
        // 副标题 + 提示信息 + 确定按钮
        // 副标题
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setText:desc];
        [descriptionLabel setTextColor:[UIColor colorWithRed:(CGFloat)0xFF/255.0 green:(CGFloat)0x99/255.0 blue:(CGFloat)0x66/255.0 alpha:1]];
        [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
        [descriptionLabel setFont:[UIFont systemFontOfSize:14.f]];
        [descriptionLabel setNumberOfLines:0];
        [backgroudView addSubview:descriptionLabel];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(backgroudView);
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(offset);
            make.left.mas_equalTo(backgroudView).with.offset(offset);
            make.right.mas_equalTo(backgroudView).with.offset(-offset);
        }];
        
        // 提示信息
        // 标题2 - 提示信息
        UILabel *label2 = [[UILabel alloc] init];
        [label2 setText: hintText];
        [label2 setTextColor:[UIColor lightGrayColor]];
        [label2 setFont: [UIFont systemFontOfSize:14]];
        [backgroudView addSubview:label2];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(offset + 10);
            make.right.mas_equalTo(backgroudView).with.offset(-offset - 10);
            make.top.mas_equalTo(descriptionLabel.mas_bottom).with.offset(30.f);
            make.height.mas_equalTo(20);
        }];
        
        // 输入框
        // 按钮的宽度
        float btnWidth = (SCREEN_WIDTH - ((offset + 10) * 2)) / MSGLenght;
        // 输入框承载层 - UIView
        UIView *msgBackgroudView = [[UIView alloc] init];
        //        [msgBackgroudView setBackgroundColor:[UIColor redColor]];
        [backgroudView addSubview:msgBackgroudView];
        
        [msgBackgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView).with.offset(offset + 10);
            make.right.mas_equalTo(backgroudView).with.offset(-offset - 10);
            make.top.mas_equalTo(label2.mas_bottom).with.offset(10.f);
            make.height.mas_equalTo(btnWidth);
        }];
        
        // 底部的文本框
        self.msgTextField = [[UITextField alloc] init];
        [self.msgTextField addTarget:self action:@selector(txChange:) forControlEvents:UIControlEventEditingChanged];
        //        self.msgTextField.keyboardType = UIKeyboardTypeNumberPad;
        [self.msgTextField setHidden:YES];
        [msgBackgroudView addSubview:self.msgTextField];
        
        [self.msgTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(msgBackgroudView).with.offset(0);
            make.right.mas_equalTo(msgBackgroudView).with.offset(0);
            make.top.mas_equalTo(msgBackgroudView).with.offset(0);
            make.bottom.mas_equalTo(msgBackgroudView).with.offset(0);
        }];
        
        if(_isSecureTextEntry)
        {
            XTYRandomKeyboard *keyBoad = [[XTYRandomKeyboard alloc] initWithTitleColor:[UIColor blackColor] backGroundImage:[self getKeyBoardUIImageBackgroud]];
            [keyBoad setInputView:self.msgTextField];
        }
        else
        {
            self.msgTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        // 表面的显示文字 - 按钮
        _msgButtonArray = [NSMutableArray array];
        
        //for循环创建按钮
        for (int i = 0; i < MSGLenght; i++)
        {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, btnWidth)];
            button.titleLabel.font = [UIFont systemFontOfSize:30.0];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [button addTarget:self action:@selector(touchBegin) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderWidth = 0.5;
            [_msgButtonArray addObject:button];
            [msgBackgroudView addSubview:button];
        }
        
        // 确定按钮
        self.confirmBtn = [[UIButton alloc] init];
        [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmBtn setBackgroundColor:[UIColor grayColor]];
        [self.confirmBtn.layer setCornerRadius:4.0f];
        [self.confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.confirmBtn setEnabled:NO];
        [self.confirmBtn setTitle:btnTitle forState:UIControlStateNormal];
        [backgroudView addSubview:self.confirmBtn];
        [self.confirmBtn addTarget:self action:@selector(clickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backgroudView.mas_left).with.offset(UI_Padding);
            make.right.mas_equalTo(backgroudView.mas_right).with.offset(-UI_Padding);
            make.height.mas_equalTo(44.f);
            make.bottom.mas_equalTo(backgroudView.mas_bottom).with.offset(-UI_Padding);
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
        CGRect oriFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f);
        _containerView.frame = oriFrame;
        
        [view addSubview:self];
        
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.containerView.alpha = 1.0f;
                             self.allBackgroudView.alpha = 0.6f;
                             
                             // 从下向上滑入
                             self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT * 0.54f , SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f);
                         } completion:^(BOOL finished) {
                             [self.msgTextField becomeFirstResponder];
                         }];
        
    }
    else
    {
        _containerView.alpha = 0;
        _allBackgroudView.alpha = 0;
        
        // 从右向左滑入
        CGRect oriFrame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.54f , SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f);
        _containerView.frame = oriFrame;
        
        [view addSubview:self];
        
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.containerView.alpha = 1.0f;
                             self.allBackgroudView.alpha = 0.6f;
                             
                             // 从右向左滑入
                             self.containerView.frame = CGRectMake(0, SCREEN_HEIGHT * 0.54f , SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f);
                         } completion:^(BOOL finished) {
                             [self.msgTextField becomeFirstResponder];
                         }];
    }
}

- (void)dismiss {
    if(self.showModeIsUpDown)
    {
        [UIView animateWithDuration:PRESENTATION_ANIMATION_DURATION
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.allBackgroudView.alpha = 0.0;
                             
                             // 从上向下滑出
                             CGRect oriFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f);
                             self.containerView.frame = oriFrame;
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
                             self.allBackgroudView.alpha = 0.0;
                             
                             // 从左向右滑出
                             CGRect oriFrame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.54f , SCREEN_WIDTH, SCREEN_HEIGHT * 0.46f);
                             self.containerView.frame = oriFrame;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}

#pragma mark - Private Mothed

-(void) endMSGInput
{
    [self.msgTextField resignFirstResponder];
    
    if([self.delegate respondsToSelector:@selector(Zzz6NumberInputPopViewClickConfirmBtnWithMSG:)])
    {
        [self.delegate Zzz6NumberInputPopViewClickConfirmBtnWithMSG:self.msgTextField.text];
    }
    self.showModeIsUpDown = YES;
    [self dismiss];
}

#pragma mark - Events
// 确定按钮
- (void)clickConfirmBtn:(UIButton *) sender
{
    NSLog(@"点击了确定按钮");
    
    if(self.msgTextField.text.length == _msgButtonArray.count)
    {
        [self endMSGInput];
    }
}

// 取消按钮
-(void) clickCancelBtn:(UIButton *) sender
{
    [self.msgTextField resignFirstResponder];
    
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(Zzz6NumberInputPopViewClickCancelBtn)])
    {
        [self.delegate Zzz6NumberInputPopViewClickCancelBtn];
    }
}

// 点击了空白区域
-(void) clickshawdowView
{
    [self clickCancelBtn:nil];
}

// 输入框输入框成为第一响应者
- (void)touchBegin
{
    [self.msgTextField becomeFirstResponder];
}

// 监听，输入文字
- (void)txChange:(UITextField*)tx
{
    NSString *text = tx.text;
    
    // 这里可以监听,当输入的位置达到要求时
    if (text.length >= _msgButtonArray.count)
    {
        [self.confirmBtn setEnabled:YES];
        [self.confirmBtn setBackgroundColor:COLOR(0x08,0x9F,0xE6,1.f)];
    }
    else
    {
        [self.confirmBtn setEnabled:NO];
        [self.confirmBtn setBackgroundColor:[UIColor grayColor]];
    }
    
    // 删除输入的多余字符
    if(text.length > _msgButtonArray.count)
    {
        tx.text = [tx.text substringWithRange:NSMakeRange(0, _msgButtonArray.count)];
    }
    
    for (int i = 0; i < _msgButtonArray.count; i++)
    {
        UIButton *btn = [_msgButtonArray objectAtIndex:i];
        NSString *str = @"";
        if (i < text.length)
        {
            if(_isSecureTextEntry)
            {
                str = @"*";
            }
            else
            {
                str = [text substringWithRange:NSMakeRange(i, 1)];
            }
            
        }
        [btn setTitle:str forState:UIControlStateNormal];
    }
}

#pragma mark - Notification

// 收到键盘弹出通知后的响应
- (void)keyboardWillShow:(NSNotification *)info {
    
    // 每次弹起键盘都打乱数字的位置(仅isSecret为YES时生效)
    if(_isSecureTextEntry)
    {
        XTYRandomKeyboard *keyBoad = [[XTYRandomKeyboard alloc] initWithTitleColor:[UIColor blackColor] backGroundImage:[self getKeyBoardUIImageBackgroud]];
        [keyBoad setInputView:self.msgTextField];
    }
    
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

#pragma mark - Other Mothed
// 获取键盘背景UIImage
-(UIImage *) getKeyBoardUIImageBackgroud
{
    // 自定义键盘
    CGSize imageSize =CGSizeMake(50,50);
    UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
    [COLOR(246,245, 247, 1) set];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

@end


