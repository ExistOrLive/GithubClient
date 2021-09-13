//
//  ZLBaseObject.m
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/7.
//  Copyright © 2020 ZM. All rights reserved.
//

#import "ZLBaseObject.h"
#import <objc/runtime.h>

@implementation ZLBaseObject

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone
{
    ZLBaseObject * object = [[[self class] allocWithZone:zone] init];
    
    Class currentClass = [self class];
    
    while(currentClass != [NSObject class])
    {
        unsigned int IvarNum = 0;
        Ivar * ivar = class_copyIvarList(currentClass, &IvarNum);
        
        for(unsigned int i = 0; i < IvarNum; i++)
        {
            @try
            {
                /**
                 * 这里之前使用object_getIvar() 和 object_setIvar() ,但是当变量为基本数据类型事异常crash，原因不明
                 * 因此使用KVC代替
                 */
                NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar[i])];
                id value = [self valueForKey:ivarName];
                [object setValue:value forKey:ivarName];
            }
            @catch(NSException * exception)
            {
                
            }
            @finally
            {
                
            }
        }
        
        currentClass = class_getSuperclass(currentClass);
    }
    
    return object;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder
{
    Class currentClass = [self class];
    
    while(currentClass != [NSObject class])
    {
         unsigned int IvarNum = 0;
         Ivar * ivar = class_copyIvarList(currentClass, &IvarNum);
         for(int i = 0; i < IvarNum; i++)
         {
             @try
             {
                 NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(*ivar)];
                 id value = [self valueForKey:ivarName];
                 [coder encodeObject:value forKey:ivarName];
             }
             @catch (NSException *exception)
             {
                 
             }
             @finally
             {
                 ivar ++;
             }
         }
        
        currentClass = class_getSuperclass(currentClass);
        
    }
    
 
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        Class currentClass = [self class];
        
        while(currentClass != [NSObject class])
        {
            unsigned int IvarNum = 0;
            Ivar * ivar = class_copyIvarList(currentClass, &IvarNum);
            for(int i = 0; i < IvarNum ; i++)
            {
                @try
                {
                    NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(*ivar)];
                    id object = [coder decodeObjectForKey:ivarName];
                    [self setValue:object forKey:ivarName];
                }
                @catch(NSException * exception)
                {
                    
                }
                @finally
                {
                    ivar ++;
                }
                
            }
            
            currentClass = class_getSuperclass(currentClass);
        }
    }
    
    return self;
}



@end
