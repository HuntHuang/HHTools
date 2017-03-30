//
//  UITextField+Tool.h
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Tool)

// 让数组里的每一个UITextField变成第一响应者，最后一个UITextField进行block
- (void)becomeNextFirstResponderInArrayField:(NSArray *)txtArr  finishedTodo:(dispatch_block_t)inputFinished;

// 限制输入框字数，多用于在UITextFieldDelegate代理方法：- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
- (BOOL)limitLengthInRange:(NSRange)range replacementString:(NSString *)string Length:(NSInteger)length;

@end
