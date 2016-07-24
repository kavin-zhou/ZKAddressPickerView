//
//  ZKMainViewController.m
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKAddressPickerView.h"
#import "ZKAddressListModel.h"

@interface ZKMainViewController () <ZKAddressPickerViewDelegate>

@property (nonatomic, strong) ZKAddressPickerView *addressPickerView;
@property (nonatomic, strong) ZKAddressListModel  *model;
@property (weak, nonatomic) IBOutlet UIButton     *addressBtn;

@end

@implementation ZKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark *** Actions ***
- (IBAction)simulateCreateAddress
{
    [self setupAddressPickerWithEdit:NO];
}

- (IBAction)simulateEditAddress
{
    [self setupAddressPickerWithEdit:YES];
}

- (void)setupAddressPickerWithEdit:(BOOL)edit
{
    // 注意: picker初始化方法写在这里不够合理(造成picker弹出后瞬白现象), 正常情况下在viewDidLoad中实现. 这里为了方便演示创建和编辑地址的picker的效果, 不得已在按钮事件中实现.
    _addressPickerView = [ZKAddressPickerView pickerViewWithDelegate:self isEdit:edit addressListModel:edit?self.model:nil];
    [_addressPickerView show];
}

#pragma mark *** <ZKAddressPickerViewDelegate> ***
- (void)addressPickerView:(ZKAddressPickerView *)addressPickerView didSelectProvince:(NSString *)province city:(NSString *)city town:(NSString *)town
{
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", province, city, town];
    [_addressBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark *** Test Data ***
- (ZKAddressListModel *)model
{
    if (!_model) {
        _model = [[ZKAddressListModel alloc] init];
        _model.province = @"河南省";
        _model.city = @"商丘市";
        _model.town = @"宁陵县";
    }
    return _model;
}

@end
