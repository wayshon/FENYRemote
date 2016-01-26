//
//  SocketModel.h
//  ipadDemo
//
//  Created by 王旭 on 15/12/28.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StateAndKey.h"


typedef void (^modelBlock)(NSDictionary *dic);

@protocol modelDelegate <NSObject>

@optional
- (void)UnconnectionTips;
- (void)updateWithState:(TTestState)state Tips:(NSString *)tips Camera:(BOOL)camera Stand:(NSString *)standard Speed:(NSString *)speed Car:(NSMutableString *)car Sample:(NSMutableArray *)sample standArray:(NSMutableArray *)standArr;

//零时用的
- (void)testUpdateWithState:(TTestState)state Tips:(NSString *)tips Camera:(BOOL)camera Bg:(BOOL)bg HY:(NSMutableString *)hy JD:(NSMutableString *)jd Car:(NSMutableString *)car Sample:(NSMutableArray *)sample standArray:(NSMutableArray *)standArr Standard:(NSString *)sd Speed:(NSString *)sp;

@end

@interface SocketModel : NSObject

@property (nonatomic,copy) modelBlock block;
@property id <modelDelegate> delegate;

+ (instancetype)sharedModel;

@end
