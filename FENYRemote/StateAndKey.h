//
//  StateAndKey.h
//  ipadDemo
//
//  Created by 王旭 on 15/12/30.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    tsInit = 0,//程序初始化
    tsWaitVerifyIn,//等待核验员登入
    tsWaitLogIn,//等待检定员登入
    tsInputCarNo,//请输入或获取车牌号
    tsPreMotorDevice,//欲初始化，无任何指令使用
    tsAskLogin,//请求登入，无
    tsAskCarNumplate,//请求车牌，无
    tsAskStartMotor,//请求启动马达，无
    tsWaitSaveSample,//保存采样，无
    tsInlineEditPar,//升降收缩
    tsAskParList,//无
    tsSaveParList,//无
    tsWaitRunCmd,//等待启动
    tsRunning,//正在运行
    tsStop,//停止
    tsPreStop,//无
    tsEditSample,//方向键，确定键，。。。。
    tsSendSample,
    tsSaveSample,
    tsAfterEditK,
    tsAskEndChk,
    tsSelectChkMode,
    tsEndTest,
    tsSetPar,
    tSelfTest,
    tsSysPar,
    tsDirectDisp,//无
    tsInputOffNo,//升降收缩
    
}TTestState;

typedef enum {
    kvNone = 0,	/*无效键*/
    kvRun,		/*启动*/
    kvZero,     /*清零*/
    kvSample,	/*采样*/
    kvCapture,	/*抓拍车牌*/
    kvStop,		/*停止*/
    kvEnter,	/*确认*/
    kvSlipIn,	/*侧滑夹紧*/
    kvSlipOut,	/*侧滑张开*/
    kvGearUp,	/*起落置,升*/
    kvGearDown,	/*起落置,降*/
    kvManualMode,	/*人工采样*/
    kvAutoMode,		/*自动采样*/
    /*******自己加的**********/
    kvUp,       /*上*/
    kvDown,     /*下*/
    kvLeft,     /*左*/
    kvRight,    /*右*/
    kvAddSpeed,     /*10倍增加速度*/
    kvReduceSpeed,  /*10倍减去速度*/
    kvAssignSpeed,  /*发送指定速度*/
    kvReturen,  /*返回*/
    
    kvManualCapture,  /*手动输入车牌*/
    kvQueryCar,     /*查询车辆信息*/
    kvUserEnter,     /*用户登入*/
    kvUserExit,     /*用户退出*/
    
}TKeyValue;

@interface StateAndKey : NSObject

@end
