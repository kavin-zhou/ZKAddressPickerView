//
//  ZKProvinceModel.h
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZKCityModel, ZKTownModel;

@interface ZKAddressBaseModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@end

@interface ZKProvinceModel : ZKAddressBaseModel
@property (nonatomic, strong) NSArray <ZKCityModel *> *citys;
@end

@interface ZKCityModel : ZKAddressBaseModel
@property (nonatomic, strong) NSArray <ZKTownModel *> *towns;
@end

@interface ZKTownModel : ZKAddressBaseModel
@end
