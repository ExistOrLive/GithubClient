//
//  SYDCentralFactory.m
//  SYDServiceSDK
//
//  Created by zhumeng on 2019/1/9.
//  Copyright © 2019年 zhumeng. All rights reserved.
//

#import "SYDCentralFactory.h"

#import <objc/Runtime.h>
#import <objc/message.h>

@interface SYDCentralFactory()

@property(nonatomic,strong) NSMutableDictionary * sydCentralModelMap;

@end

@implementation SYDCentralFactory

#pragma mark - 单例

+ (instancetype) sharedInstance
{
    static SYDCentralFactory * centralFactory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        centralFactory = [[SYDCentralFactory alloc] init];
    });
    
    return centralFactory;
}


- (instancetype) init
{
    if(self = [super init]){
        _sydCentralModelMap = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void) addConfigWithFilePath:(NSString *) filePath withBundle:(NSBundle *) bundle{
    
    NSDictionary * centralRouterConfig = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    if(centralRouterConfig){
        
        [centralRouterConfig enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL * stop)
         {
            NSString * modelKey = key;
            NSDictionary * modelValue = value;
            
            NSString * classString = [modelValue objectForKey:@"class"];
            Class cla = NSClassFromString(classString);
            if(!cla){
                // 支持swift 创建的类
                NSBundle *tmpBundle = bundle;
                if(!tmpBundle){
                    tmpBundle = [NSBundle mainBundle];
                }
                NSString *moduleName = [tmpBundle objectForInfoDictionaryKey:@"CFBundleName"];
                NSString *classStringName = [NSString stringWithFormat:@"_TtC%lu%@%lu%@", (unsigned long)moduleName.length, moduleName, (unsigned long)classString.length, classString];
                cla = NSClassFromString(classStringName);
            }
            
            if(cla)
            {
                SYDCentralRouterModelType type = (SYDCentralRouterModelType)((NSNumber *)[modelValue objectForKey:@"type"]).intValue;
                SYDCentralRouterModel * model = nil;
                if(SYDCentralRouterModelType_Service == type)
                {
                    SYDCentralRouterServiceModel * tmpModel = [[SYDCentralRouterServiceModel alloc] init];
                    NSDictionary * queueInfo = [modelValue objectForKey:@"asyncMethods"];
                    
                    if(queueInfo)
                    {
                        [tmpModel setQueueTag:[queueInfo objectForKey:@"queueTag"]];
                        [tmpModel setAsyncMethodArray:[queueInfo objectForKey:@"methods"]];
                    }
                    model = tmpModel;
                }
                else
                {
                    model = [[SYDCentralRouterModel alloc] init];
                }
                
                [model setModelType:type];
                [model setModelKey:modelKey];
                [model setCla:cla];
                [model setIsSingle:[[modelValue objectForKey:@"isSingle"] boolValue]];
                [model setSingletonMethodStr:[modelValue objectForKey:@"singleMethod"]];
                [_sydCentralModelMap setObject:model forKey:modelKey];
                
            }
            else
            {
                NSLog(@"SYDCentralFactory_init: class for [%@] not exist",modelKey);
            }
        }];
    }
    
    
}

- (SYDCentralRouterModel *) getCentralRouterModel:(const NSString *) beanKey
{
    return [self.sydCentralModelMap objectForKey:beanKey];
}


- (Class) getBeanClass:(const NSString *) beanKey{
    SYDCentralRouterModel * model = [self.sydCentralModelMap objectForKey:beanKey];
    return model.cla;
}

- (id) getCommonBean:(const NSString *) beanKey
{
    SYDCentralRouterModel * model = [self.sydCentralModelMap objectForKey:beanKey];
    
    id commomBean = nil;
    
    if(model)
    {
        if(model.isSingle)
        {
            commomBean = [model singleton];
            
            if(!commomBean)
            {
                commomBean = [self getSingleton:beanKey];
                
                if(!commomBean)
                {
                    NSLog(@"SYDCentralFactory_getCommonBean: create singleton for [%@] failed",beanKey);
                }
            }
            
        }
        else
        {
            commomBean = class_createInstance([model cla], 0);
        }
    }
    else
    {
        NSLog(@"SYDCentralFactory_getCommonBean: SYDCentralRouterModel for [%@] is not exist",beanKey);
    }
    
    return commomBean;
}


- (id) getCommonBean:(const NSString *) beanKey withInjectParam:(NSDictionary *) param
{
    id commonBean = [self getCommonBean:beanKey];
    
    if(commonBean)
    {
        [param enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL * stop)
         {
            NSString * tmpKey = key;
            
            @try
            {
                [commonBean setValue:value forKey:tmpKey];
            }
            @catch(NSException * exception)
            {
                NSLog(@"SYDCentralFactory_getCommonBeanWithInjectParam: value for key[%@] not exist,exception[%@]",beanKey,exception);
            }
            
        }];
    }
    
    return commonBean;
}

- (id) getSingleton:(const NSString *) beanKey
{
    SYDCentralRouterModel * model = [self.sydCentralModelMap objectForKey:beanKey];
    
    id singleton = nil;
    
    if(model)
    {
        if(model.isSingle && model.singletonMethodStr)
        {
            SEL singleMethodSel = NSSelectorFromString(model.singletonMethodStr);
            Method singletonMethod = class_getClassMethod(model.cla,singleMethodSel);
            id(*singletonMethodIMP)(id,SEL) = (id(*)(id,SEL))method_getImplementation(singletonMethod);
            
            if(singletonMethodIMP)
            {
                singleton = singletonMethodIMP(model.cla,singleMethodSel);
                [model setSingleton:singleton];
            }
            else
            {
                NSLog(@"SYDCentralFactory_getSingleton: singleton method for [%@] not exist",beanKey);
            }
        }
        else
        {
            NSLog(@"SYDCentralFactory_getSingleton: SYDCentralRouterModel for [%@] is not singleton",beanKey);
        }
    }
    else
    {
        NSLog(@"SYDCentralFactory_getSingleton: SYDCentralRouterModel for [%@] is not exist",beanKey);
    }
    
    return singleton;
}


@end



@implementation SYDCentralFactory (ViewController)

- (UIViewController *) getOneUIViewController:(const NSString *) viewControllerKey
{
    Class viewControllerClass = [self getViewControllerClass:viewControllerKey];
    
    if(!viewControllerClass)
    {
       NSLog(@"SYDCentralFactory_getOneUIViewController: class for [%@] is not exist",viewControllerKey);
        return nil;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    SEL getOneViewControllerSEL = @selector(getOneViewController);
    SEL setVCKEYSEL = @selector(setVCKey:);
    
#pragma clang diagnostic pop
    
    Method getOneViewControllerMethod = class_getClassMethod(viewControllerClass,getOneViewControllerSEL);
    Method setVCKEYMethod = class_getInstanceMethod(viewControllerClass,setVCKEYSEL);
    
    UIViewController *(*getOneViewController)(id,SEL) = (UIViewController * (*)(id,SEL))method_getImplementation(getOneViewControllerMethod);
    void (*setVCKey)(id,SEL,const NSString *) = (void (*)(id,SEL,const NSString *))method_getImplementation(setVCKEYMethod);
    
    
    if(getOneViewController){
        UIViewController *controller  = getOneViewController(viewControllerClass,
                                                             getOneViewControllerSEL);
        setVCKey(controller,setVCKEYSEL,viewControllerKey);
        return controller;
    }
    else{
        NSLog(@"SYDCentralFactory_getOneViewController: method for [%@] not exist ",viewControllerKey);
        return class_createInstance(viewControllerClass, 0);
    }
}

- (UIViewController *) getOneUIViewController:(const NSString *) viewControllerKey withInjectParam:(NSDictionary *) param
{
    UIViewController * viewController = [self getOneUIViewController:viewControllerKey];
    
    if(viewController)
    {
        [param enumerateKeysAndObjectsUsingBlock:^(id key,id value,BOOL * stop)
         {
             NSString * tmpKey = key;
             @try
             {
                 [viewController setValue:value forKey:tmpKey];
             }
             @catch(NSException * exception)
             {
                 NSLog(@"SYDCentralFactory_getOneUIViewControllerWithInjectParam: value for key[%@] not exist,exception[%@]",viewControllerKey,exception);
             }
             
         }];
    }

    return viewController;
}

- (Class) getViewControllerClass:(const NSString *) viewControllerKey
{
    Class viewControllerClass = nil;
    
    if(!self.viewControllerModelMapCache)
    {
        self.viewControllerModelMapCache = [[NSMutableDictionary alloc] init];
    }
    else
    {
        viewControllerClass = [self.viewControllerModelMapCache objectForKey:viewControllerKey];
    }
    
    if(!viewControllerClass)
    {
        SYDCentralRouterModel * model = [self getCentralRouterModel:viewControllerKey];
        viewControllerClass = [model cla];
        
        if(!model || !viewControllerClass)
        {
            NSLog(@"SYDCentralFactory_getViewControllerClass: model for [%@] is not exist",viewControllerKey);
            return nil;
        }
        
        [self.viewControllerModelMapCache setObject:viewControllerClass forKey:viewControllerKey];
    }
    
    return viewControllerClass;
}


@end


@implementation SYDCentralFactory (SYDService)

- (id) getSYDServiceBean:(const NSString *) serviceKey
{
    id serviceBean = nil;
    
    if(!self.serviceModelMapCache)
    {
        self.serviceModelMapCache = [[NSMutableDictionary alloc] init];
    }
    else
    {
        serviceBean = [self.serviceModelMapCache objectForKey:serviceKey];
    }
    
    if(!serviceBean)
    {
        serviceBean = [self getCommonBean:serviceKey];
        
        if(serviceBean)
        {
            [self.serviceModelMapCache setObject:serviceBean forKey:serviceKey];
        }
        else
        {
            NSLog(@"SYDCentralFactory_getSYDServiceBean: serviceBean for [%@] not exist",serviceKey);
        }
    }
    
    return serviceBean;
}

@end

