# ZzzPopView
各种功能的Popview，包括：
- **纵向长条pickerview的Popview**：文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）
- **纵向TableView的Popview**：文本显示内容，包括标题和详细内容，底部可选择是否显示控制按钮（上一个、完成、下一个）
- **6位数输入Popview**：6位数字输入的popview,当然你也可以在源码里方便的改写成其它位数，提供了明文输入和密码输入两种方式，popview上的文字都可以创建方法中自定义，一个popview解决多种使用场景。
- **银行卡选择Popview**：未完成


- - - 
### 纵向长条pickerview的Popview

文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）

当被选内容数量较多时，使用此popview比在底部的小size的pickview显示内容更直观大方

点击选择器之外的空间隐藏Popview，选择时会回调被选中的itemIndex

效果预览：
![Markdown](http://i1.bvimg.com/603144/b44c6416a601b6fb.png)

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
![Markdown](http://i2.bvimg.com/603144/5fda8e43c2faa43c.png)

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

### 6位数输入Popview

6位数字输入的popview，当然你也可以在源码里方便的改写成其它位数。

提供了明文输入和密（暗）文输入两种方式，密（暗）文输入时可对数字位置进行打乱，防止他人窥屏时记住用户的密码输入顺序造成安全风险。

popview上的文字都可以创建方法中自定义。

点击选择器之外的空间隐藏Popview。

一个popview解决多种使用场景。

效果预览：
![Markdown](http://i1.bvimg.com/603144/19726400ece3232f.png)

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

