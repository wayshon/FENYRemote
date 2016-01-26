//
//  LNNumberpadPhone.h
//  RemoteController
//
//  Created by 王旭 on 16/1/26.
//  Copyright © 2016年 无锡市瑞丰精密机电技术有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol LNNumberpadPhoneDelegate <NSObject>

@optional

- (void)SendFlag:(BOOL)flag;

@end

@interface LNNumberpadPhone : UIView

// The one and only LNNumberpad instance you should ever need:
+ (LNNumberpadPhone *)defaultLNNumberpad;

@property id <LNNumberpadPhoneDelegate> delegate;

@end

