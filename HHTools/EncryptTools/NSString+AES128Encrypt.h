//
//  NSString+AES128Encrypt.h
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES128Encrypt)

+ (NSString *)AES128encryptAES:(NSString *)content key:(NSString *)key;

+ (NSString *)AES128decryptAES:(NSString *)content key:(NSString *)key;

@end
