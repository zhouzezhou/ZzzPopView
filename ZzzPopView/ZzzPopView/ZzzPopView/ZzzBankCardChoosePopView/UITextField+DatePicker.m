//
//  UITextField+DatePicker.m
//  Sjyr_ERP
//
//  Created by tujinqiu on 15/11/28.
//  Copyright © 2015年 mysoft. All rights reserved.
//

#import "UITextField+DatePicker.h"

@implementation UITextField (DatePicker)

// 1
+ (UIDatePicker *)sharedDatePicker;
{
    static UIDatePicker *daterPicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        daterPicker = [[UIDatePicker alloc] init];
        daterPicker.datePickerMode = UIDatePickerModeDate;
        [daterPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        NSDate *now = [NSDate date];
        daterPicker.maximumDate = now;
        [daterPicker setDate:now animated:NO];
    });
    
    return daterPicker;
}

// 2
- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.isFirstResponder)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年 MM月 dd日"];
        if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
        {
            NSString *dateFormat = @"yyyy年 MM月 dd日";
            NSRange range = NSMakeRange(0, dateFormat.length);
            [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:[formatter stringFromDate:sender.date]];
        }
        self.text = [formatter stringFromDate:sender.date];
        
//        else
//        {
//            self.text = [formatter stringFromDate:sender.date];
//        }
        
    }
}

// 3
- (void)setDatePickerInput:(BOOL)datePickerInput
{
    if (datePickerInput)
    {
        self.inputView = [UITextField sharedDatePicker];
        [[UITextField sharedDatePicker] addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
        self.inputView = nil;
        [[UITextField sharedDatePicker] removeTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

// 4
- (BOOL)datePickerInput
{
    return [self.inputView isKindOfClass:[UIDatePicker class]];
}

@end
