//
//  DetailModel.h
//  ipadDemo
//
//  Created by 王旭 on 15/12/30.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic,copy) NSString *chehao;
@property (nonatomic,strong) NSNumber *chexingxuhao;
@property (nonatomic,copy) NSString *chexing;
@property (nonatomic,strong) NSNumber *jijiaqixuhao;
@property (nonatomic,copy) NSString *jijiaqixinghao;
@property (nonatomic,copy) NSString *jijiaqiqihao;
@property (nonatomic,copy) NSString *jijiaqiKzhi;
@property (nonatomic,strong) NSNumber *luntaixuhao;
@property (nonatomic,copy) NSString *luntaixinghao;
@property (nonatomic,copy) NSString *xiuzhengzhi;
@property (nonatomic,copy) NSString *youxiaoqizhi;

@property (nonatomic,copy) NSArray *cx;
@property (nonatomic,copy) NSArray *jjqxh;
@property (nonatomic,copy) NSArray *jjqqh;
@property (nonatomic,copy) NSArray *jjqkz;
@property (nonatomic,copy) NSArray *ltxh;
@property (nonatomic,copy) NSArray *xzz;

@end
