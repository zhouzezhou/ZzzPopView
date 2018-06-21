# ZzzPopView - OC版本

swift版本正在开发中。

各种功能的Popview，包括：
- **纵向长条pickerview的Popview**：文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）
- **纵向TableView的Popview**：文本显示内容，包括标题和详细内容，底部可选择是否显示控制按钮（上一个、完成、下一个）
- **6位数输入Popview**：6位数字输入的popview,当然你也可以在源码里方便的改写成其它位数，提供了明文输入和密码输入两种方式，popview上的文字都可以创建方法中自定义，一个popview解决多种使用场景。
- **银行卡选择Popview**：选择银行卡的popview，支付系统里经常会用到。
- **起始和终止日期选择Popview**：分别选择一个起始日期和一个终止日期的popview

- - - 
### 纵向长条pickerview的Popview

文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）

当被选内容数量较多时，使用此popview比在底部的小size的pickview显示内容更直观大方

点击选择器之外的空间隐藏Popview，选择时会回调被选中的itemIndex

效果预览：
![Ca2m36.png](https://s1.ax1x.com/2018/05/07/Ca2m36.png)

使用方法：
```
// 导入头文件
#import "ScrollSelectPopView.h"
	  
// 随便弄点测试数据
DataScrollSelect *selectData_motion = [[DataScrollSelect alloc] init];

[selectData_motion.arrData addObject:@"坐姿划船"];
[selectData_motion.arrData addObject:@"臀推(桥式提臀)"];
[selectData_motion.arrData addObject:@"腿举"];
[selectData_motion.arrData addObject:@"杠铃头上举"];
[selectData_motion.arrData addObject:@"引体向上"];
[selectData_motion.arrData addObject:@"坐姿高位下拉"];
[selectData_motion.arrData addObject:@"坐姿哑铃臂弯举"];
[selectData_motion.arrData addObject:@"坐姿双臂下压"];
[selectData_motion.arrData addObject:@"杠铃弯举"];
[selectData_motion.arrData addObject:@"仰卧杠铃屈臂伸"];
[selectData_motion.arrData addObject:@"俯身支撑臂屈伸"];

// 创建PopView
SelectPopView *scrollSelectPopView_motion = [ScrollSelectPopView popviewWithScrollSelectData:selectData_motion];
// 设置代理，接收用户交互的回调
scrollSelectPopView_motion.delegate = self;

// 立即显示PopView(在需要显示的时候调用)
[scrollSelectPopView_motion showInView:[UIApplication sharedApplication].keyWindow];
```




- - - 
### 纵向TableView的Popview

文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）

当被选内容有较长的详细内容需要显示，但又不想跳转到其它界面进行选择时可以使用此Popview，从侧面滑入滑出的动画效果非常高效和简洁，内容在屏幕一侧显示，滑动内容查看更多选项。

点击选择器之外的空间隐藏Popview，选择时会回调被选中的itemIndex

效果预览：
![CagnmQ.png](https://s1.ax1x.com/2018/05/07/CagnmQ.png)

使用方法：
```
// 导入头文件
#import "RegularSelectPopView.h"

// 随便弄点测试数据
DataRegularSelect *regularData_body = [[DataRegularSelect alloc] init];

DataOneRegularSelectInfo *temp1 = [[DataOneRegularSelectInfo alloc] init];
temp1.name = @"胸";
temp1.decript = @"乳房是雌性哺乳动物孕育后代的重要器官。人类的乳房结构分为内、外部位。主要为乳腺和其他肌肉组织组成。对于人类的女性而言，如何养护乳房是首要问题，比如预防各种的乳房疾病、及时检查等都是重要环节。乳房还具有审美意义，人体艺术的形成基于该器官健康状况。乳房的主要成分是脂肪，另外是乳腺。女性胸部只是第二性征，并非生殖器官。";

[regularData_body addObject:temp1];

DataOneRegularSelectInfo *temp2 = [[DataOneRegularSelectInfo alloc] init];
temp2.name = @"肩";
temp2.decript = @"肩膀是一个汉语词汇，读音为 jiānbǎng，指人的胳膊上部与躯干相连的部分，比喻勇于或能够承担的责任，亦有同名歌曲等。释义：1、指人的胳膊上部与躯干相连的部分。2、比喻勇于或能够承担的责任。";

[regularData_body addObject:temp2];

DataOneRegularSelectInfo *temp3 = [[DataOneRegularSelectInfo alloc] init];
temp3.name = @"背";
temp3.decript = @"背，中国汉字，多音字：(1)bēi，用于“背负”“背债”“背包”。(2)bèi，用于“背风”“背约”“背道而驰”“背信弃义”。";

[regularData_body addObject:temp3];

DataOneRegularSelectInfo *temp4 = [[DataOneRegularSelectInfo alloc] init];
temp4.name = @"腿";
temp4.decript = @"腿，tui，骽， 胫和股的总称。腿tuǐ 的基本字义：1.人和动物用来支持身体和行走的部分：大~，前~，后~。2.器物下部像腿一样起支撑作用的部分：桌子~，椅子~。3.指火腿：云~（云南火腿）。";

[regularData_body addObject:temp4];

DataOneRegularSelectInfo *temp5 = [[DataOneRegularSelectInfo alloc] init];
temp5.name = @"腰";
temp5.decript = @"腰是一个汉字，读作yāo，本意是指东西的中段，中间，也特指身体胯上胁下的部分，或指所穿衣服在身体的腰部的部分。";

[regularData_body addObject:temp5];

// 创建PopView
RegularSelectPopView *regularSelectPopView_body = [RegularSelectPopView popviewWithRegularSelectData:_regularData_body];
// 设置代理，接收用户交互的回调
regularSelectPopView_body.delegate = self;

// 立即显示PopView(在需要显示的时候调用)
[regularSelectPopView_body showInView:[UIApplication sharedApplication].keyWindow];
```

- - - 
### 6位数输入Popview

6位数字输入的popview，当然你也可以在源码里方便的改写成其它位数。

提供了明文输入和密（暗）文输入两种方式，密（暗）文输入时可对数字位置进行打乱，防止他人窥屏时记住用户的密码输入顺序对安全造成风险。

popview上的文字都可以创建方法中自定义。

点击选择器之外的空间隐藏Popview。

一个popview解决多种使用场景。

效果预览：
![Ca2ngK.png](https://s1.ax1x.com/2018/05/07/Ca2ngK.png)

使用方法：
```
// 导入头文件
#import "Zzz6NumberInputPopView.h"

// 假设使用场景为支付密码输入
// 创建popview
Zzz6NumberInputPopView *popView = [Zzz6NumberInputPopView messagePopviewWithBtnTitle:@"确定" popViewTitle:@"支付密码" popVuewDescrption:@"请输入支付密码" hintText:@"需要验证您的支付密码" isSecureTextEntry:YES];

// 设置代理，接收用户交互的回调
popView.delegate = self;

// 立即显示PopView(在需要显示的时候调用)
[popView showInView:[UIApplication sharedApplication].keyWindow andShowModeUpDown:YES];
```

- - - 
### 银行卡选择Popview

选择银行卡的popview，支付系统里经常会用到。

传入银行卡的数据，弹出popview，以Tableview的形式让用户需要使用哪一张银行卡。

效果预览：
![Ca2ujO.png](https://s1.ax1x.com/2018/05/07/Ca2ujO.png)

使用方法：
```
// 导入头文件
#import "ZzzBankCardChoosePopView.h"

// 存放银行卡信息数组
NSMutableArray<DataBankCardInfo *> *cardInfoArr = [NSMutableArray array];       

// 随便弄点测试数据
cardInfoArr = [NSMutableArray array];

DataBankCardInfo *card1 = [[DataBankCardInfo alloc] init];
card1.logoNamed = @"AppIcon";
card1.isSelected = NO;
card1.bankCardNumber = @"612345678901234000";
card1.bankName = @"中国工商银行";
[cardInfoArr addObject:card1];

DataBankCardInfo *card2 = [[DataBankCardInfo alloc] init];
card2.logoNamed = @"AppIcon";
card2.isSelected = NO;
card2.bankCardNumber = @"612345678901234123";
card2.bankName = @"中国建设银行";
[cardInfoArr addObject:card2];

DataBankCardInfo *card3 = [[DataBankCardInfo alloc] init];
card3.logoNamed = @"AppIcon";
card3.isSelected = YES;
card3.bankCardNumber = @"612345678901234456";
card3.bankName = @"中国人民银行";
[cardInfoArr addObject:card3];

DataBankCardInfo *card4 = [[DataBankCardInfo alloc] init];
card4.logoNamed = @"AppIcon";
card4.isSelected = NO;
card4.bankCardNumber = @"612345678901234789";
card4.bankName = @"中国农业银行";
[cardInfoArr addObject:card4];

DataBankCardInfo *card5 = [[DataBankCardInfo alloc] init];
card5.logoNamed = @"AppIcon";
card5.isSelected = NO;
card5.bankCardNumber = @"612345678901234111";
card5.bankName = @"中国邮政储蓄银行";
[cardInfoArr addObject:card5];

DataBankCardInfo *card6 = [[DataBankCardInfo alloc] init];
card6.logoNamed = @"AppIcon";
card6.isSelected = NO;
card6.bankCardNumber = @"612345678901234222";
card6.bankName = @"中国光大银行";
[cardInfoArr addObject:card6];

// 创建PopView
ZzzBankCardChoosePopView *zzzBankCardChoosePopView = [ZzzBankCardChoosePopView popviewWithCardBankData:cardInfoArr];
// 设置代理，接收用户交互的回调
zzzBankCardChoosePopView.delegate = self;

// 立即显示PopView(在需要显示的时候调用)
[zzzBankCardChoosePopView showInView:[UIApplication sharedApplication].keyWindow andShowModeUpDown:YES];
```

- - - 
### 起始和终止日期选择Popview

分别选择一个起始日期和一个终止日期的popview

日期的格式为yyyy年 MM月 dd日,例如：2018年 05月 08日

可做为查询的条件嵌入项目，非常漂亮且方便。

效果预览：
![CrTvJx.png](https://s1.ax1x.com/2018/05/14/CrTvJx.png)

使用方法：
```
// 导入头文件
#import "ZzzDateSelectPopview.h"

// 创建PopView
ZzzDateSelectPopview *dateSelectPopView = [ZzzDateSelectPopview messagePopviewWithBtnTitle:@"查询" popViewTitle:@"查询条件" popVuewDescrption:@"单次查询最长天数不超过31天"];
// 设置代理，接收用户交互的回调
dateSelectPopView.delegate = self;

// 立即显示PopView(在需要显示的时候调用)
[dateSelectPopView showInView:[UIApplication sharedApplication].keyWindow  andShowModeUpDown:YES];
```


