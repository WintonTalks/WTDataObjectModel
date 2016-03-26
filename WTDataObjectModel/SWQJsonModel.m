//
//  SWQJsonModel.m
//  WTDataObjectModel
//
//  Created by 孙文强 on 16/3/26.
//  Copyright © 2016年 Winton. All rights reserved.
//

#import "SWQJsonModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, YYJSONModelDataType) {

    LMJSONModelDataTypeObject = 0,
    LMJSONModelDataTypeBOOL = 1,
    LMJSONModelDataTypeInteger = 2,
    LMJSONModelDataTypeFloat = 3,
    LMJSONModelDataTypeDouble = 4,
    LMJSONModelDataTypeLong = 5,
};

@implementation SWQJsonModel

+ (NSDictionary *)dictionaryWithModel:(id)model {

    if (!model) return nil;

    NSMutableDictionary *dict = [NSMutableDictionary new];

    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);

    unsigned  int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    //遍历所有属性
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        //取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        //取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
       
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        }else if ([valueObject isKindOfClass:[NSArray class]]){
            
            propertyValue = [NSArray arrayWithArray:valueObject];
        }else {
        
            propertyValue = [NSString stringWithFormat:@"%@",[model valueForKey:propertyName]];
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
        
    return dict;
}

+ (NSArray *)propertiesInModel:(id)model {

    if (!model) return nil;

    NSMutableArray *propertiesArray = [[NSMutableArray alloc] init];
    
    NSString *className = NSStringFromClass([model class]);

    id classObject = objc_getClass([className UTF8String]);

    unsigned int count = 0;

    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
       
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [propertiesArray addObject:propertyName];
    }
    
    return [propertiesArray copy];
}


+ (id)modelWithDict:(NSDictionary *)dict className:(NSString *)className {

    if (!dict || !className || className.length == 0) {
        return nil;
    }

    id model = [[NSClassFromString(className) alloc] init];
    
    //取得类对象
    id classObject = objc_getClass([className UTF8String]);


    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    Ivar *ivars = class_copyIvarList(classObject, nil);
    
    for (int i = 0; i < count; i++) {
        
       //取得成员名
        NSString *menberName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        const char *type = ivar_getTypeEncoding(ivars[i]);
        NSString *dataType = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        
        YYJSONModelDataType r_type = LMJSONModelDataTypeObject;
       
        if ([dataType hasPrefix:@"c"]) {
            
            r_type = LMJSONModelDataTypeBOOL;
        }else if ([dataType hasPrefix:@"i"]) {
        
            r_type = LMJSONModelDataTypeInteger;
        }else if ([dataType hasPrefix:@"f"]) {
        
            r_type = LMJSONModelDataTypeFloat;
        }else if ([dataType hasPrefix:@"d"]) {
        
            r_type = LMJSONModelDataTypeDouble;
        }else if ([dataType hasPrefix:@"i"]) {
        
            r_type = LMJSONModelDataTypeLong;
        }
        
        for (int j = 0; j < count; j++) {
            
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            NSRange range = [menberName rangeOfString:propertyName];
            
            if (range.location == NSNotFound) {
                
                continue;
            }else {
            
                id propertyValue = [dict objectForKey:propertyName];
            
                switch (r_type) {
                    case LMJSONModelDataTypeBOOL:{
                    
                     BOOL temp = [[NSString stringWithFormat:@"%@",propertyValue] boolValue];
                    
                        propertyValue = [NSNumber numberWithBool:temp];
                     }
                        
                        break;
                    case LMJSONModelDataTypeInteger: {
                    
                        int temp = [[NSString stringWithFormat:@"%@",propertyValue] intValue];
                       
                        propertyValue = [NSNumber numberWithInt:temp];
                     }
                        break;
                        
                    case LMJSONModelDataTypeLong:{
                     
                        long long temp = [[NSString stringWithFormat:@"%@",propertyValue] longLongValue];
                    
                        propertyValue = [NSNumber numberWithLong:temp];
                    }
                        
                        break;
                        
                    case LMJSONModelDataTypeDouble:{
                    
                        double temp = [[NSString stringWithFormat:@"%@",propertyValue] doubleValue];

                        propertyValue = [NSNumber numberWithDouble:temp];
                    }
                        
                        break;
                        
                    case  LMJSONModelDataTypeFloat:{
                    
                        float temp = [[NSString stringWithFormat:@"%@",propertyValue] floatValue];

                        propertyValue = [NSNumber numberWithFloat:temp];
                    }
                        
                        break;
                    default:
                        break;
                }
            
                [model setValue:propertyValue forKey:menberName];
            
                break;
            }
        }
    }
    

    return model;
}

@end
