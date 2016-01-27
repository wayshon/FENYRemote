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
typedef void (^RemoteUpdateBlock)(TTestState state,NSString *tips,BOOL camera,BOOL bg,NSMutableString *jd);
typedef void (^updateBlock)(TTestState state,NSString *tips,BOOL camera,BOOL bg,NSMutableString *hy,NSMutableString *jd,NSMutableString *car,NSMutableArray *sample,NSMutableArray *standArr,NSString *sd,NSString *sp);

@protocol modelDelegate <NSObject>

@optional
- (void)UnconnectionTips;

@end

@interface SocketModel : NSObject

@property (nonatomic,copy) modelBlock modelBlock;
@property (nonatomic,copy) RemoteUpdateBlock RemoteUpdateBlock;
@property (nonatomic,copy) updateBlock updateBlock;
@property id <modelDelegate> delegate;

+ (instancetype)sharedModel;

@end
