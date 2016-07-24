//
//  ZKAddressListModel.h
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKAddressListModel : NSObject

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *telNum;
@property (nonatomic, copy) NSString *detailAddress;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *town;
@property (nonatomic, copy) NSString *provinceID;
@property (nonatomic, copy) NSString *cityID;
@property (nonatomic, copy) NSString *townID;

@end
