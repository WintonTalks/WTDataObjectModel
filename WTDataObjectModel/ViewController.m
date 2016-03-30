//
//  ViewController.m
//  WTDataObjectModel
//
//  Created by winTon on 16/3/26.
//  Copyright © 2016年 Winton. All rights reserved.
//

#import "SWQDataModel.h"
#import "SWQJsonModel.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SWQDataModel *model1 = [SWQDataModel new];
    model1.name = @"123";
    model1.type = @"ddd";
    model1.age = @"14";
    model1.height = @"222.5";
    model1.ssss = @"wwwww";
    model1.aaa = @"a123";
    
    //1.对象转换成字典
    NSDictionary *dict1 = [SWQJsonModel dictionaryWithModel:model1];
    NSLog(@"dict1 --------= %@\n",dict1);
    
    
    //2.获取model所有属性名称
    NSArray *propertyArr = [SWQJsonModel propertiesInModel:model1];
    NSLog(@"propertyArr -------= %@\n",propertyArr);
    
    //3.字典转换成模型
    SWQDataModel *model2 = [SWQJsonModel modelWithDict:dict1 className:@"SWQDataModel"];
    NSLog(@"model2.name -----------= %@\n model2.type --------= %@\n",model2.name,model2.type);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
