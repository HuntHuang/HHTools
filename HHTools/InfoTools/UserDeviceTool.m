//
//  UserDeviceTool.m
//  HHTools
//
//  Created by 黄志航 on 2017/3/30.
//  Copyright © 2017年 Hunt. All rights reserved.
//

#import "UserDeviceTool.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>

@implementation UserDeviceTool

+ (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceDict = @{
                                 @"iPhone3,1" : @"iPhone 4",
                                 @"iPhone3,2" : @"iPhone 4",
                                 @"iPhone3,3" : @"iPhone 4",
                                 @"iPhone4,1" : @"iPhone 4S",
                                 @"iPhone5,1" : @"iPhone 5",
                                 @"iPhone5,2" : @"iPhone 5 (GSM+CDMA)",
                                 @"iPhone5,3" : @"iPhone 5c (GSM)",
                                 @"iPhone5,4" : @"iPhone 5c (GSM+CDMA)",
                                 @"iPhone6,1" : @"iPhone 5s (GSM)",
                                 @"iPhone6,2" : @"iPhone 5s (GSM+CDMA)",
                                 @"iPhone7,1" : @"iPhone 6 Plus",
                                 @"iPhone7,2" : @"iPhone 6",
                                 @"iPhone8,1" : @"iPhone 6s",
                                 @"iPhone8,2" : @"iPhone 6s Plus",
                                 @"iPhone8,4" : @"iPhone SE",
                                 @"iPhone9,1" : @"国行、日版、港行iPhone 7",
                                 @"iPhone9,2" : @"港行、国行iPhone 7 Plus",
                                 @"iPhone9,3" : @"美版、台版iPhone 7",
                                 @"iPhone9,4" : @"美版、台版iPhone 7 Plus",
                                 @"iPod1,1"   : @"iPod Touch 1G",
                                 @"iPod2,1"   : @"iPod Touch 2G",
                                 @"iPod3,1"   : @"iPod Touch 3G",
                                 @"iPod4,1"   : @"iPod Touch 4G",
                                 @"iPod5,1"   : @"iPod Touch (5 Gen)",
                                 @"iPad1,1"   : @"iPad",
                                 @"iPad1,2"   : @"iPad 3G",
                                 @"iPad2,1"   : @"iPad 2 (WiFi)",
                                 @"iPad2,2"   : @"iPad 2",
                                 @"iPad2,3"   : @"iPad 2 (CDMA)",
                                 @"iPad2,4"   : @"iPad 2",
                                 @"iPad2,5"   : @"iPad Mini (WiFi)",
                                 @"iPad2,6"   : @"iPad Mini",
                                 @"iPad2,7"   : @"iPad Mini (GSM+CDMA)",
                                 @"iPad3,1"   : @"iPad 3 (WiFi)",
                                 @"iPad3,2"   : @"iPad 3 (GSM+CDMA)",
                                 @"iPad3,3"   : @"iPad 3",
                                 @"iPad3,4"   : @"iPad 4 (WiFi)",
                                 @"iPad3,5"   : @"iPad 4",
                                 @"iPad3,6"   : @"iPad 4 (GSM+CDMA)",
                                 @"iPad4,1"   : @"iPad Air (WiFi)",
                                 @"iPad4,2"   : @"iPad Air (Cellular)",
                                 @"iPad4,4"   : @"iPad Mini 2 (WiFi)",
                                 @"iPad4,5"   : @"iPad Mini 2 (Cellular)",
                                 @"iPad4,6"   : @"iPad Mini 2",
                                 @"iPad4,7"   : @"iPad Mini 3",
                                 @"iPad4,8"   : @"iPad Mini 3",
                                 @"iPad4,9"   : @"iPad Mini 3",
                                 @"iPad5,1"   : @"iPad Mini 4 (WiFi)",
                                 @"iPad5,2"   : @"iPad Mini 4 (LTE)",
                                 @"iPad5,3"   : @"iPad Air 2",
                                 @"iPad5,4"   : @"iPad Air 2",
                                 @"iPad6,3"   : @"iPad Pro 9.7",
                                 @"iPad6,4"   : @"iPad Pro 9.7",
                                 @"iPad6,7"   : @"iPad Pro 12.9",
                                 @"iPad6,8"   : @"iPad Pro 12.9",
                                 @"i386"      : @"Simulator",
                                 @"x86_64"    : @"Simulator"
                                 };
    return [deviceDict objectForKey:deviceString];
}

+ (NSString *)getDeviceIPAddresses
{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0)
    {
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
        {
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len)
            {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    for (int i = 0; i < ips.count; i++)
    {
        if (ips.count > 0)
        {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

+ (NSString *)getMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}
@end
