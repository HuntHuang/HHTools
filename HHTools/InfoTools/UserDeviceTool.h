//
//  UserDeviceTool.h
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDeviceTool : NSObject

// 获取设备型号
+ (NSString *)getDeviceName;

// 获取ip地址
+ (NSString *)getDeviceIPAddresses;

// 获取mac地址
+ (NSString *)getMacAddress;
@end
