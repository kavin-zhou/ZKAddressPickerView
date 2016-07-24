//
//  ZKGlobalConfig.h
//  ZKAddressPickerView
//
//  Created by ZK on 16/7/24.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AutoLayout.h"

#define userDefaults         [NSUserDefaults standardUserDefaults]

#define SCREEN_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT        [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH    (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH    (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4          (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5          (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6          (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P         (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define KeyWindow           [[[UIApplication sharedApplication] delegate] window]
#define WindowZoomScale     (SCREEN_WIDTH/320.f)

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]         //RGB进制颜色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]       //RGBA进制颜色值
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1]   //16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000

extern NSString *const UserDefaultKey_TimeDifference;

