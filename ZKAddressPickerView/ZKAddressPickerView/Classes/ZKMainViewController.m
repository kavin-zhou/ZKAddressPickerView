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
@property (nonatomic, strong) ZKAddressListModel *model;

@end

@implementation ZKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initAddressPickerView];
}

- (void)initAddressPickerView
{
    _addressPickerView = [ZKAddressPickerView pickerViewWithDelegate:self isEdit:_model?YES:NO addressListModel:_model];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [_addressPickerView show];
    
}

@end
