//
//  ZKAddressPickerView.h
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKProvinceModel.h"
@class ZKAddressPickerView;

@protocol ZKAddressPickerViewDelegate <NSObject>
@optional
- (void)addressPickerView:(ZKAddressPickerView *)addressPickerView
        didSelectProvince:(NSString *)province
                     city:(NSString *)city
                     town:(NSString *)town;
@end

@interface ZKAddressPickerView : UIView

- (void)show;
+ (instancetype)pickerViewWithDelegate:(id <ZKAddressPickerViewDelegate>)delegate
                                isEdit:(BOOL)isEdit
                      addressListModel:(id)listModel;

- (ZKProvinceModel *)seletedProvince;
- (ZKCityModel *)    seletedCity;
- (ZKTownModel *)    seletedTown;

@end
