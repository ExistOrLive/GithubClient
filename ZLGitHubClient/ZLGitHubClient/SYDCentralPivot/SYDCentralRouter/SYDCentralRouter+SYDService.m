
//
//  SYDCentralRouter+SYDService.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/11.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralRouter+SYDService.h"
#import "SYDCentralFactory+SYDService.h"
#import "SYDCentralQueuePool.h"

#import <objc/runtime.h>

@implementation SYDCentralRouter (SYDService)

- (id) sendMessageToService:(const NSString *) serviceKey withSEL:(SEL) message withPara:(NSArray *) paramArray isInstanceMessage:(BOOL) isInstanceMessage
{
    NSLog(@"SYDCentralRouter_sendMessageToService: serviceKey[%@] message[%@] paramArray[%@]",serviceKey, message,paramArray);
    
    id serviceBean = [self.centralFactory getSYDServiceBean:serviceKey];
    
    if(!serviceBean)
    {
        NSLog(@"SYDCentralRouter_sendMessageToService: serviceBean for [%@] not exist",serviceKey);
        return nil;
    }
    
    NSInvocation * invocation = nil;
    
    if(isInstanceMessage)
    {
        if(![serviceBean respondsToSelector:message])
        {
            NSLog(@"SYDCentralRouter_sendMessageToService: serviceBean [%@] can not respondsToInstanceSelector[%@]",serviceKey,message);
            return nil;
        }
        invocation =  [SYDCentralRouter injectArguments:paramArray withSelector:message withReceiver:serviceBean];
    }
    else
    {
        if(![[serviceBean class] respondsToSelector:message])
        {
            NSLog(@"SYDCentralRouter_sendMessageToService: serviceBean [%@] can not respondsToClassSelector[%@]",serviceKey,message);
            return nil;
        }
        invocation =  [SYDCentralRouter injectArguments:paramArray withSelector:message withReceiver:[serviceBean class]];
    }

    
    SYDCentralRouterServiceModel * model = (SYDCentralRouterServiceModel *)[self.centralFactory getCentralRouterModel:serviceKey];
    
    if([[model asyncMethodArray] containsObject:NSStringFromSelector(message)])
    {
        NSLog(@"SYDCentralRouter_sendMessageToService: async perform message [%@] for service[%@]",message,serviceKey);
        
        [[SYDCentralQueuePool sharedInstance] asyncPerformBlock:^{
            [invocation invoke];
        } inQueueForTag:[model queueTag]];
        
        return [SYDCentralRouter getReturnValue:invocation isAsync:YES];
    }
    else
    {
        NSLog(@"SYDCentralRouter_sendMessageToService: sync perform message [%@] for service[%@]",message,serviceKey);
        
        [invocation invoke];
        return [SYDCentralRouter getReturnValue:invocation isAsync:NO];
    }
}



+ (NSInvocation *) injectArguments:(NSArray *) argumentArray withSelector:(SEL) message withReceiver:(id) receiver
{
    NSMethodSignature * methodSignature = [receiver methodSignatureForSelector:message];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setSelector:message];
    
    for(uint index = 0; index < [argumentArray count]; index++)
    {
        id argument = [argumentArray objectAtIndex:index];
        char argumentType = *[methodSignature getArgumentTypeAtIndex:index + 2];
        
        switch(argumentType)
        {
            case _C_ID: //'@':
            {
                //An Object
                [invocation setArgument:&argument atIndex:index+2];
                break;
            }
            case _C_CLASS: //'#':
            {
                //A class object(Class)
                NSLog(@"injectArguments::not support 'class object'");
                break;
            }
            case _C_SEL://':':
            {
                //A method selector(SEL)
                NSLog(@"injectArguments::not support 'method selector'");
                break;
            }
            case _C_CHR://'c':
            {
                //A char
                char aArgument = [argument charValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_UCHR://'C':
            {
                //A unsgined char
                unsigned char aArgument = [argument unsignedCharValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_SHT://'s':
            {
                //A short
                short aArgument = [argument shortValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_USHT://'S':
            {
                //A unsgined short
                unsigned short aArgument = [argument unsignedShortValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_INT://'i':
            {
                //An int
                int aArgument = [argument intValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_UINT://'I':
            {
                //An unsgined int
                unsigned int aArgument = [argument unsignedIntValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_LNG://'l':
            {
                //A long
                long aArgument = [argument longValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_ULNG://'L':
            {
                //A unsgined long
                unsigned long aArgument = [argument unsignedLongValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_LNG_LNG://'q':
            {
                //A long long
                long long aArgument = [argument longLongValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_ULNG_LNG://'Q':
            {
                //A unsgined long long
                unsigned long long aArgument = [argument unsignedLongLongValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_FLT://'f':
            {
                //A float
                float aArgument = [argument floatValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_DBL://'d':
            {
                //A double
                double aArgument = [argument doubleValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_BFLD://'b':
            {
                //A bit field of num bits
                NSLog(@"setNSInvocationArgument::not support 'bit field of num bits'");
                break;
            }
            case _C_BOOL://'B':
            {
                //A C++ bool or aC99 _Bool
                bool aArgument = [argument boolValue];
                [invocation setArgument:&aArgument atIndex:index + 2];
                break;
            }
            case _C_VOID://'v':
            {
                //A void
                NSLog(@"setNSInvocationArgument::not support 'void'");
                break;
            }
            case _C_UNDEF://'?':
            {
                //A unknow type
                NSLog(@"setNSInvocationArgument::not support 'unknow type'");
                break;
            }
            case _C_PTR://'^':
            {
                //A pointer to type
                NSLog(@"setNSInvocationArgument::not support 'pointer to type'");
                break;
            }
            case _C_CHARPTR://'*':
            {
                //A character string(char *)
                NSLog(@"setNSInvocationArgument::not support 'character string'");
                break;
            }
            case _C_ATOM://'%':
            {
                //A atom
                NSLog(@"setNSInvocationArgument::not support 'atom'");
                break;
            }
            case _C_ARY_B://'[':
            {
                //A array begin
                NSLog(@"setNSInvocationArgument::not support 'array begin'");
                break;
            }
            case _C_ARY_E://']':
            {
                //A array end
                NSLog(@"setNSInvocationArgument::not support 'array end'");
                break;
            }
            case _C_UNION_B://'(':
            {
                //A union begin
                NSLog(@"setNSInvocationArgument::not support 'union begin'");
                break;
            }
            case _C_UNION_E://')':
            {
                //A union end
                NSLog(@"setNSInvocationArgument::not support 'union end'");
                break;
            }
            case _C_STRUCT_B://'{':
            {
                //A struct begin
                NSLog(@"setNSInvocationArgument::not support 'struct begin'");
                break;
            }
            case _C_STRUCT_E://'}':
            {
                //A struct end
                NSLog(@"setNSInvocationArgument::not support 'struct end'");
                break;
            }
            case _C_VECTOR://'!':
            {
                //A vector
                NSLog(@"setNSInvocationArgument::not support 'vector'");
                break;
            }
            case _C_CONST://'r':
            {
                //A const
                NSLog(@"setNSInvocationArgument::not support 'const'");
                break;
            }
            default:
            {
                break;
            }
        }
    }
    
    return invocation;
    
}



+ (id) getReturnValue:(NSInvocation *) invocation isAsync:(BOOL) isAsync
{
    NSMethodSignature * methodSignature = [invocation methodSignature];
    char returnType = *[methodSignature methodReturnType];
    
    if(isAsync)
    {
        return nil;
    }
    
    __autoreleasing id returnValue = nil;
    
    switch(returnType)
    {
        case _C_ID: //'@':
        {
            [invocation getReturnValue:&returnValue];
            break;
        }
        case _C_CLASS: //'#':
        {
            break;
        }
        case _C_SEL://':':
        {
            break;
        }
        case _C_CHR://'c':
        {
            //A char
            char aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithChar:aReturnArgument];
            break;
        }
        case _C_UCHR://'C':
        {
            //A unsgined char
            unsigned char aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithUnsignedChar:aReturnArgument];
            break;
        }
        case _C_SHT://'s':
        {
            //A short
            short aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithShort:aReturnArgument];
            break;
        }
        case _C_USHT://'S':
        {
            //A unsgined short
            unsigned short aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithUnsignedShort:aReturnArgument];
            break;
        }
        case _C_INT://'i':
        {
            //An int
            int aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithInt:aReturnArgument];
            break;
        }
        case _C_UINT://'I':
        {
            //An unsgined int
            unsigned int aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithUnsignedInt:aReturnArgument];
            break;
        }
        case _C_LNG://'l':
        {
            //A long
            long aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithLong:aReturnArgument];
            break;
        }
        case _C_ULNG://'L':
        {
            //A unsgined long
            unsigned long aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithUnsignedLong:aReturnArgument];
            break;
        }
        case _C_LNG_LNG://'q':
        {
            //A long long
            long long aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithLongLong:aReturnArgument];
            break;
        }
        case _C_ULNG_LNG://'Q':
        {
            //A unsgined long long
            unsigned long long aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithUnsignedLongLong:aReturnArgument];
            break;
        }
        case _C_FLT://'f':
        {
            //A float
            float aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithFloat:aReturnArgument];
            break;
        }
        case _C_DBL://'d':
        {
            //A double
            double aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithDouble:aReturnArgument];
            break;
        }
        case _C_BFLD://'b':
        {
            //A bit field of num bits
            NSLog(@"setNSInvocationArgument::not support 'bit field of num bits'");
            break;
        }
        case _C_BOOL://'B':
        {
            //A C++ bool or aC99 _Bool
            bool aReturnArgument = 0;
            [invocation getReturnValue:&aReturnArgument];
            returnValue = [NSNumber numberWithBool:aReturnArgument];
            break;
        }
        case _C_VOID://'v':
        {
            //A void
            NSLog(@"setNSInvocationArgument::not support 'void'");
            break;
        }
        case _C_UNDEF://'?':
        {
            //A unknow type
            NSLog(@"setNSInvocationArgument::not support 'unknow type'");
            break;
        }
        case _C_PTR://'^':
        {
            //A pointer to type
            NSLog(@"setNSInvocationArgument::not support 'pointer to type'");
            break;
        }
        case _C_CHARPTR://'*':
        {
            //A character string(char *)
            NSLog(@"setNSInvocationArgument::not support 'character string'");
            break;
        }
        case _C_ATOM://'%':
        {
            //A atom
            NSLog(@"setNSInvocationArgument::not support 'atom'");
            break;
        }
        case _C_ARY_B://'[':
        {
            //A array begin
            NSLog(@"setNSInvocationArgument::not support 'array begin'");
            break;
        }
        case _C_ARY_E://']':
        {
            //A array end
            NSLog(@"setNSInvocationArgument::not support 'array end'");
            break;
        }
        case _C_UNION_B://'(':
        {
            //A union begin
            NSLog(@"setNSInvocationArgument::not support 'union begin'");
            break;
        }
        case _C_UNION_E://')':
        {
            //A union end
            NSLog(@"setNSInvocationArgument::not support 'union end'");
            break;
        }
        case _C_STRUCT_B://'{':
        {
            //A struct begin
            NSLog(@"setNSInvocationArgument::not support 'struct begin'");
            break;
        }
        case _C_STRUCT_E://'}':
        {
            //A struct end
            NSLog(@"setNSInvocationArgument::not support 'struct end'");
            break;
        }
        case _C_VECTOR://'!':
        {
            //A vector
            NSLog(@"setNSInvocationArgument::not support 'vector'");
            break;
        }
        case _C_CONST://'r':
        {
            //A const
            NSLog(@"setNSInvocationArgument::not support 'const'");
            break;
        }
        default:
        {
            break;
        }
    }
    return returnValue;
}

@end
