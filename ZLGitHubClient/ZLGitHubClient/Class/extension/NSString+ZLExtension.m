//
//  NSString+ZLExtension.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "NSString+ZLExtension.h"

@implementation NSString (ZLExtension)

+ (NSString *) generateSerialNumber
{
    //17位的当前时间+3位16进制的随机数
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *serialNumber = [NSString stringWithFormat:@"%@%@%@%@",dateStr,[self getStrHexFromDec:(arc4random()%16)],[self getStrHexFromDec:(arc4random()%16)],[self getStrHexFromDec:(arc4random()%16)]];
    return serialNumber;
}

//随机生成A-F16进制字符
+ (NSString *)getStrHexFromDec:(int)randomNum
{
    NSString *stringHex;
    switch (randomNum) {
        case 10:
            stringHex=@"A";
            break;
        case 11:
            stringHex=@"B";
            break;
        case 12:
            stringHex=@"C";
            break;
        case 13:
            stringHex=@"D";
            break;
        case 14:
            stringHex=@"E";
            break;
        case 15:
            stringHex=@"F";
            break;
        default:
        {
            stringHex=[NSString stringWithFormat:@"%d",randomNum];
        }
            break;
    }
    return stringHex;
}

@end
