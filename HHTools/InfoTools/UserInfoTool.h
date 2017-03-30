//
//  UserInfoTool.h
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoTool : NSObject

// 根据身份证号计算年龄
+ (NSInteger)getAgeWithIdentityCard:(NSString *)number;

// 根据身份证号获取性别
+ (NSString *)getSexStringFromIdentityCard:(NSString *)numberStr;

@end
