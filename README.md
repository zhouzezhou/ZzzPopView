# ZzzPopView
各种功能的Popview，包括：
- **纵向长条pickerview的Popview**：文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）
- **纵向TableView的Popview**：文本显示内容，包括标题和详细内容，底部可选择是否显示控制按钮（上一个、完成、下一个）
- **6位数输入Popview**：未完成
- **银行卡选择Popview**：未完成


- - - 
### 纵向长条pickerview的Popview

文本显示内容，底部可选择是否显示控制按钮（上一个、完成、下一个）

当被选内容数量较多时，使用此popview比在底部的小size的pickview显示内容更直观大方

点击选择器之外的空间隐藏Popview，滚动时回调被选中的itemIndex

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



