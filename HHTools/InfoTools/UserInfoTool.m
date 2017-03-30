//
//  UserInfoTool.m
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "UserInfoTool.h"

@implementation UserInfoTool

+ (NSInteger)getAgeWithIdentityCard:(NSString *)number
{
    if (number == nil || [number isEqualToString:@""])
    {
        return 0;
    }
    NSInteger year, month, day;
    if (number.length == 18)
    {
        year = [[number substringWithRange:NSMakeRange(6, 4)] integerValue];
        month = [[number substringWithRange:NSMakeRange(10, 2)] integerValue];
        day = [[number substringWithRange:NSMakeRange(12, 2)] integerValue];
    }
    else
    { // 15位
        year = [[number substringWithRange:NSMakeRange(6, 2)] integerValue];
        month = [[number substringWithRange:NSMakeRange(8, 2)] integerValue];
        day = [[number substringWithRange:NSMakeRange(10, 2)] integerValue];
    }
    
    // 获取系统当前 年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 计算年龄
    NSInteger age = currentYear - year - 1;
    if ((currentMonth > month) || (currentMonth == month && currentDay >= day))
    {
        age += 1;
    }
    return age;
}

+ (NSString *)getSexStringFromIdentityCard:(NSString *)numberStr
{
    NSString *result = nil;
    BOOL isAllNumber = YES;
    if ([numberStr length] < 17)
    {
        return result;
    }
    //**截取第17为性别识别符
    NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(16, 1)];
    //**检测是否是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p != '\0')
    {
        if(!(*p >= '0' && *p <= '9'))
            isAllNumber = NO;
        p++;
    }
    if (!isAllNumber)
    {
        return result;
    }
    int sexNumber = [fontNumer intValue];
    if(sexNumber % 2 == 1)
    {
        result = @"男";
    }
    else if (sexNumber % 2 == 0)
    {
        result = @"女";
    }
    return result;
}
@end
