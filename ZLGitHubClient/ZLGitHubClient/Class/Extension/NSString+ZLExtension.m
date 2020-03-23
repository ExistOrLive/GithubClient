//
//  NSString+ZLExtension.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/1.
//  Copyright © 2019 ZM. All rights reserved.
//

#import "NSString+ZLExtension.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (ZLExtension)

+ (NSString *)generateSerialNumber
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


+ (NSString *) MIMETypeForExtention:(NSString *) ext
{
    CFStringRef theUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)(ext), NULL);
    
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(theUTI,kUTTagClassMIMEType);
        
    CFRelease(theUTI);
    
    return (__bridge_transfer NSString *)MIMEType;
}

+ (BOOL) isTextFileForExtension:(NSString *) ext
{
    NSArray * array = @[@"m",@"h",@"swift",@"txt",@"text",@"json",@"c",@"python",@"cpp",@"hpp",@"java",@"python",@"js",@"css",@"html",@"xml",@"kt",@"sh"];
    if([array containsObject:ext])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSString *)htmlEntityDecode{
    NSString *string = [self mutableCopy];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@"\n"];
    return string;
}


-(NSString *)htmlEntityEncode{
    
    NSString *string = [self mutableCopy];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;

}

@end
