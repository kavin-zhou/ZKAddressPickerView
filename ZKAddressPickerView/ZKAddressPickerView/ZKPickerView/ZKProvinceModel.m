//
//  ZKProvinceModel.m
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKProvinceModel.h"
#import "MJExtension.h"

@implementation ZKAddressBaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id",
             @"citys":@"city",
             @"towns":@"district"};
}
@end

@implementation ZKProvinceModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"citys":@"ZKCityModel"};
}
@end

@implementation ZKCityModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"towns":@"ZKTownModel"};
}
@end

@implementation ZKTownModel
@end
