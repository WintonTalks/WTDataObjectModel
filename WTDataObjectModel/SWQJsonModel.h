//
//  SWQJsonModel.h
//  WTDataObjectModel
//
//  Created by 孙文强 on 16/3/26.
//  Copyright © 2016年 Winton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWQJsonModel : NSObject

/**
 *  对象转换成字典
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
+ (NSDictionary *)dictionaryWithModel:(id)model;


/**
 *  获取model所有属性名称
 *
 *  @param model <#model description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)propertiesInModel:(id)model;


/**
 *  字典转换成模型
 *
 *  @param dict      <#dict description#>
 *  @param classname <#classname description#>
 *
 *  @return <#return value description#>
 */
+ (id)modelWithDict:(NSDictionary *)dict className:(NSString *)className;


@end
