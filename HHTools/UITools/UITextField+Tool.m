//
//  UITextField+Tool.m
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "UITextField+Tool.h"

@implementation UITextField (Tool)

- (void)becomeNextFirstResponderInArrayField:(NSArray *)txtArr  finishedTodo:(dispatch_block_t)inputFinished
{
    NSUInteger index = [txtArr indexOfObject:self];
    if (index != NSNotFound)
    {
        NSUInteger next = index + 1;
        if (next < txtArr.count)
        {
            UITextField *nextObj = [txtArr objectAtIndex:next];
            [nextObj becomeFirstResponder];
        }
        else
        {
            if (inputFinished)
            {
                inputFinished();
            }
        }
    }
}

- (BOOL)limitLengthInRange:(NSRange)range replacementString:(NSString *)string Length:(NSInteger)length
{
    if (string.length == 0)
        return YES;
    
    NSInteger existedLength = self.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger limitLength = existedLength - selectedLength + replaceLength;
    
    if (limitLength > length)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
