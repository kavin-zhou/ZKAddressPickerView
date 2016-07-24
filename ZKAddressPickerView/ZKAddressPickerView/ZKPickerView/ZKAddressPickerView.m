//
//  ZKAddressPickerView.m
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKAddressPickerView.h"
#import "ZKAddressListModel.h"
#import "ZKGlobalConfig.h"
#import "MJExtension.h"

@interface ZKAddressPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView       *maskView;
@property (weak, nonatomic) IBOutlet UIView       *bottomView;

@property (nonatomic, weak) id <ZKAddressPickerViewDelegate>     delegate;
@property (nonatomic, assign) BOOL                               isEdit;   //是否编辑地址
@property (nonatomic, strong) ZKAddressListModel                 *addressListModel;
@property (strong, nonatomic) NSDictionary                       *pickerDic;
@property (strong, nonatomic) NSMutableArray <ZKProvinceModel *> *provinceArray;
@property (strong, nonatomic) NSArray <ZKCityModel *>            *cityArray;
@property (strong, nonatomic) NSArray <ZKTownModel *>            *townArray;
@property (strong, nonatomic) ZKProvinceModel                    *seletedModel;
@property (assign, nonatomic) NSInteger                          seletedCityIndex;
@property (nonatomic, strong) UIActivityIndicatorView            *indicatorView;

@end

static NSTimeInterval const kAnimationDuration = .2;

@implementation ZKAddressPickerView

#pragma mark *** initical ***

+ (instancetype)pickerViewWithDelegate:(id<ZKAddressPickerViewDelegate>)delegate
                                isEdit:(BOOL)isEdit
                      addressListModel:(id)listModel
{
    ZKAddressPickerView *addressPickerView = [[NSBundle mainBundle]
                                              loadNibNamed:NSStringFromClass([self class])
                                              owner:nil
                                              options:nil].firstObject;
    addressPickerView.isEdit = isEdit;
    addressPickerView.delegate = delegate;
    addressPickerView.addressListModel = listModel;
    return addressPickerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupPicker];
}

- (void)setupPicker
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:addressPath];
        if (array) {
            self.provinceArray = [ZKProvinceModel mj_objectArrayWithKeyValuesArray:array];
            [self initPickerData];
        }
    });
}

- (NSString *)jsonFromObject:(id)object
{
    NSString *jsonStr = @"";
    @try {
        if ([NSJSONSerialization isValidJSONObject:object]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0  error:nil];
            jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"data was not a proper JSON object, check All objects are NSString, NSNumber, NSArray, NSDictionary, or NSNull !!!!!");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] 对象转换成JSON字符串出错了-->\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return jsonStr;
}

- (void)initPickerData
{
    self.seletedModel = self.provinceArray[0];
    self.cityArray = self.seletedModel.citys;
    self.townArray = self.seletedModel.citys[0].towns;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addSeparateLine];
        [self.indicatorView stopAnimating];
        [_pickerView reloadAllComponents];
        // 低版本设备 城市选择提前加载选中数据
        !(IS_IPHONE_4 && _isEdit)?:[self setupDefaultPicker];
    });
}

- (void)addSeparateLine
{
    [self addSeparateLineWithHorizoalAxisOffset:0.f];
    [self addSeparateLineWithHorizoalAxisOffset:-32.f];
}

/** 添加自定义分割线 */
- (void)addSeparateLineWithHorizoalAxisOffset:(CGFloat)offset
{
    UIImage *image = [UIImage imageNamed:@"datepick_dashline"];
    CGFloat topCapInset = image.size.height*0.5;
    CGFloat leftCapInset = image.size.width*0.5;
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(topCapInset, leftCapInset, topCapInset, leftCapInset)];
    
    UIImageView *topLine = [[UIImageView alloc] initForAutoLayout];
    topLine.image = image;
    [self.bottomView addSubview:topLine];
    [topLine autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH*1.2];
    [topLine autoCenterInSuperview];
    [topLine autoAlignAxisToSuperviewAxis:ALAxisHorizontal withOffset:offset];
}

#pragma mark *** <UIPickerViewDataSource, UIPickerViewDelegate> ***

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    }
    else if (component == 1) {
        return self.seletedModel.citys.count;
    }
    else {
        ZKCityModel *city = self.seletedModel.citys[_seletedCityIndex];
        return city.towns.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        ZKProvinceModel *province = self.provinceArray[row];
        return province.name;
    }
    else if (component == 1) {
        ZKCityModel *city = self.cityArray[row];
        return city.name;
    }
    else {
        ZKTownModel *town = self.townArray[row];
        return town.name;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel=(UILabel *)view;
    if (!titleLabel) {
        titleLabel=[[UILabel alloc] init];
        titleLabel.minimumScaleFactor=.6f;
        titleLabel.adjustsFontSizeToFitWidth=YES;       //设置字体大小是否适应lalbel宽度
        titleLabel.textAlignment=NSTextAlignmentCenter; //文字居中显示
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    }
    titleLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return titleLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return SCREEN_WIDTH * 0.3;
    }
    else if (component == 1) {
        return SCREEN_WIDTH * 0.35;
    }
    else {
        return SCREEN_WIDTH * 0.3;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        if ([self.seletedModel isEqual:self.provinceArray[row]]) {
            return;
        }
        self.seletedModel = self.provinceArray[row];
        self.cityArray = self.seletedModel.citys;
        _seletedCityIndex = 0;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        self.townArray = self.seletedModel.citys[0].towns;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    else if (component == 1) {
        if (_seletedCityIndex == [pickerView selectedRowInComponent:1]) {
            return;
        }
        _seletedCityIndex = [pickerView selectedRowInComponent:1];
        self.townArray = self.seletedModel.citys[_seletedCityIndex].towns;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    if ([self.delegate respondsToSelector:@selector(addressPickerView:didSelectProvince:city:town:)]) {
        [self.delegate addressPickerView:self
                       didSelectProvince:self.seletedModel.name
                                    city:self.cityArray[_seletedCityIndex].name
                                    town:_townArray[[_pickerView selectedRowInComponent:2]].name];
    }
}

#pragma mark *** Actions ***

- (IBAction)maskViewDidTouch
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.maskView.alpha = 0;
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-250.f];
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)ensureBtnClick
{
    if (!_provinceArray.count) {
        [self maskViewDidTouch];
        return;
    };
    if ([self.delegate respondsToSelector:@selector(addressPickerView:didSelectProvince:city:town:)]) {
        [self.delegate addressPickerView:self
                       didSelectProvince:self.seletedModel.name
                                    city:self.cityArray[_seletedCityIndex].name
                                    town:_townArray[[_pickerView selectedRowInComponent:2]].name];
    }
    [self maskViewDidTouch];
}

- (void)show
{
    [KeyWindow addSubview:self];
    [self autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self layoutIfNeeded];
    
    // 去除分割线
    [self.pickerView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.hidden = view.frame.size.height < 1;
    }];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        self.maskView.alpha = 0.5;
        [self layoutIfNeeded];
        if (IS_IPHONE_4 && !self.provinceArray.count) {
            [self.indicatorView startAnimating];
        }
        
    }completion:^(BOOL finished) {
        if (!self.isEdit || IS_IPHONE_4) {
            return;
        }
        self.bottomView.userInteractionEnabled = YES;
        
        if (!self.provinceArray.count) {
            NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
            NSArray *array = [NSArray arrayWithContentsOfFile:addressPath];
            if (array) {
                self.provinceArray = [ZKProvinceModel mj_objectArrayWithKeyValuesArray:array];
            }
        }
        [self setupDefaultPicker];
    }];
}

/** 自动选中相应地址 */
- (void)setupDefaultPicker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.indicatorView stopAnimating];
        __block NSInteger proID = 0;
        [self.provinceArray enumerateObjectsUsingBlock:^(ZKProvinceModel *proModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([proModel.name isEqualToString:_addressListModel.province]) {
                proID = idx;
                *stop = YES;
            }
        }];
        [_pickerView selectRow:proID inComponent:0 animated:YES];
        [self pickerView:_pickerView didSelectRow:proID inComponent:0];
        
        __block NSInteger cityID = 0;
        [self.cityArray enumerateObjectsUsingBlock:^(ZKCityModel *cityModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([cityModel.name isEqualToString:_addressListModel.city]) {
                cityID = idx;
                *stop = YES;
            }
        }];
        [_pickerView selectRow:cityID inComponent:1 animated:YES];
        [self pickerView:_pickerView didSelectRow:cityID inComponent:1];
        
        __block NSInteger townID = 0;
        [self.townArray enumerateObjectsUsingBlock:^(ZKTownModel *townModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([townModel.name isEqualToString:_addressListModel.town]) {
                townID = idx;
                *stop = YES;
            }
        }];
        [_pickerView selectRow:townID inComponent:2 animated:YES];
        [self pickerView:_pickerView didSelectRow:townID inComponent:2];
    });
}

#pragma mark *** public methods ***

- (ZKProvinceModel *)seletedProvince
{
    return _provinceArray[[_pickerView selectedRowInComponent:0]];
}

- (ZKCityModel *)seletedCity
{
    return _cityArray[[_pickerView selectedRowInComponent:1]];
}

- (ZKTownModel *)seletedTown
{
    return _townArray[[_pickerView selectedRowInComponent:2]];
}

#pragma mark *** Lazy loading ***

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initForAutoLayout];
        _indicatorView.backgroundColor = [UIColor clearColor];
        [self.bottomView addSubview:_indicatorView];
        [_indicatorView autoCenterInSuperview];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _indicatorView;
}

@end
