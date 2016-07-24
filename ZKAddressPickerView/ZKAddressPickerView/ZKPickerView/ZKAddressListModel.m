//
//  ZKAddressListModel.m
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKAddressListModel.h"
#import "MJExtension.h"

@implementation ZKAddressListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"name":@"username",
             @"telNum":@"phone",
             @"province":@"province.name",
             @"city":@"province.city.name",
             @"town":@"province.city.district.name",
             @"detailAddress":@"province.city.district.field.name",
             @"provinceID":@"province.id",
             @"cityID":@"province.city.id",
             @"townID":@"province.city.district.id",
             };
}

@end
