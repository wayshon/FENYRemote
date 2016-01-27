//
//  remotecontrolViewController.m
//  10.19demo
//
//  Created by 王旭 on 15/10/19.
//  Copyright (c) 2015年 王旭. All rights reserved.
//

#import "PhoneRemoteVC.h"
#import "LNNumberpadPhone.h"
#import "OBShapedButton.h"
#import "ODXSocket.h"
#import "SocketModel.h"
#import "CustomIOSAlertView.h"
#import "ConttentView.h"
#import "CaptureView.h"
#import "YcKeyBoardView.h"
//#import "DetailViewController3.h"
#import "DetailModel.h"

@interface PhoneRemoteVC ()<CustomIOSAlertViewDelegate,YcKeyBoardViewDelegate,LNNumberpadPhoneDelegate,modelDelegate,CaptureViewDelegate>

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *passWord;
@property (nonatomic,strong) UISwipeGestureRecognizer *upGestureRecognizer;
@property (nonatomic,strong) YcKeyBoardView *key;
@property (nonatomic) NSString *KeyBoardText;

@property (weak, nonatomic) IBOutlet OBShapedButton *SlipIn;
@property (weak, nonatomic) IBOutlet OBShapedButton *SlipOut;
@property (weak, nonatomic) IBOutlet OBShapedButton *GearUp;
@property (weak, nonatomic) IBOutlet OBShapedButton *GearDown;
@property (atomic,strong) ODXSocket *socket;
@property (nonatomic) SocketModel *model;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (nonatomic) TTestState state;
@property (nonatomic) NSString *tip;
@property (nonatomic) BOOL hasCamera;
@property (nonatomic) BOOL hasBG;
@property (nonatomic) NSString *inputCarNo;
@property (nonatomic) BOOL NumberPadFlag;

@end
@implementation PhoneRemoteVC
@synthesize upGestureRecognizer;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGesture];
    _socket = [ODXSocket sharedSocket];
    _model = [SocketModel sharedModel];
    _model.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateView];
    [super viewWillAppear:animated];
}

#pragma mark - BtnActions
- (IBAction)mainBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
        {
            if (_hasBG) {
                [self alertViewCaptureWithCamera:_hasCamera];
            }else {
                uint8_t CMD = 0x3D;
                TKeyValue action = kvEnter;
                uint8_t content[1];
                content[0] = action;
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
            }
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSaveSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}

- (IBAction)UpBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvAddSpeed;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}

- (IBAction)DownBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReduceSpeed;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
        
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)LeftBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvLeft;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)RightBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvRight;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)ReturnBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReturen;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReturen;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReturen;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)ZeroBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvZero;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)StopBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvStop;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)StartBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvRun;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)SamplingBtnActions:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSample;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)SlipInBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}
- (IBAction)SlipOutBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}
- (IBAction)GearUpBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}
- (IBAction)GearDownBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}

#pragma mark -alertView

- (void)tsInitAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备正在初始化" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tsWaitVerifyInAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请核验员至后台登入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检定员登入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"登入" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        [self alertViewJD];
//    }];
    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertViewJD {
//    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
//    ConttentView *contentView = [[ConttentView alloc] initWithImg:@"JDenterBG"];
//    [contentView.userName becomeFirstResponder];
//    [alert setContainerView:contentView];
//    contentView.delegate = self;
//    [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"登入", nil]];
//    [alert setDelegate:self];
//    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//        [contentView.userName resignFirstResponder];
//        [contentView.passWord resignFirstResponder];
//        if (buttonIndex == 0) {
//            [alertView close];
//        }else if(buttonIndex == 1){
//#warning Incomplete implementation
//            //这里发送登入指令
//            [alertView close];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self EnterErrorAlertView];
//            });
//        }
//    }];
//    
//    //[alert setUseMotionEffects:YES];
//    
//    [alert show];
}

//- (void)EnterErrorAlertView {
//    if (_state == tsWaitLogIn || _state == tsInit || _state == tsWaitVerifyIn) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登入不成功" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//    }
//}

- (void)alertViewCaptureWithCamera:(BOOL)camera {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    CaptureView *captureView = [[CaptureView alloc] initWithImg:@"carNumberBG" Pad:NO];
    captureView.deledate = self;
    [alert setContainerView:captureView];
    [alert setDelegate:self];
    if (camera) {
        [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"拍照", @"确定", nil]];
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [captureView.carNumber resignFirstResponder];
            
            if (buttonIndex == 0) {
                [alertView close];
            }else if(buttonIndex == 1){
                //拍照
                uint8_t CMD = 0x3D;
                TKeyValue action = kvCapture;
                uint8_t content[1];
                content[0] = action;
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
                [alertView close];
            }else {
#warning Incomplete implementation
                //这里发送车牌号
                uint8_t CMD = 0x3D;
                TKeyValue action = kvManualCapture;
                uint8_t content[7];
                content[0] = action;
                for (int i = 1; i < 7; i++) {
                    content[i] = [_inputCarNo characterAtIndex:i];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
                [alertView close];
            }
        }];
    }else {
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [captureView.carNumber resignFirstResponder];
            
            if (buttonIndex == 0) {
                [alertView close];
            }else {
#warning Incomplete implementation
                //这里发送车牌号
                uint8_t CMD = 0x33;
                uint8_t content[6];
                for (int i = 0; i < 6; i++) {
                    content[i] = [_inputCarNo characterAtIndex:i];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:6];
            }
        }];
    }
    //[alert setUseMotionEffects:YES];
    
    [alert show];
    
}

#pragma mark -LNNumberpadDelegate
- (void)SendFlag:(BOOL)flag {
    _NumberPadFlag = flag;
}

- (void)sendAssignSpeed {
    if (![_KeyBoardText isEqualToString:@""]){
#warning Incomplete implementation
        switch (_state) {
            case tsInit:
                [self tsInitAlertView];
                break;
            case tsWaitVerifyIn:
                [self tsWaitVerifyInAlertView];
                break;
            case tsWaitLogIn:
                [self alertView];
                break;
            case tsInputCarNo:
                
                break;
            case tsPreMotorDevice:
                
                break;
            case tsAskLogin:
                
                break;
            case tsAskCarNumplate:
                
                break;
            case tsAskStartMotor:
                
                break;
            case tsWaitSaveSample:
                
                break;
            case tsInlineEditPar:
                
                break;
            case tsAskParList:
                
                break;
            case tsSaveParList:
                
                break;
            case tsWaitRunCmd:
                
                break;
            case tsRunning:
            {
                uint8_t CMD = 0x3D;
                TKeyValue action = kvAssignSpeed;
                uint8_t content[2];
                content[0] = action;
                content[1] = [_KeyBoardText intValue];
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
            }
                break;
            case tsStop:
                
                break;
            case tsPreStop:
                
                break;
            case tsEditSample:
                
                break;
            case tsSendSample:
                
                break;
            case tsSaveSample:
                
                break;
            case tsAfterEditK:
                
                break;
            case tsAskEndChk:
                
                break;
            case tsSelectChkMode:
                
                break;
            case tsEndTest:
                
                break;
            case tsSetPar:
                
                break;
            case tSelfTest:
                
                break;
            case tsSysPar:
                
                break;
            case tsDirectDisp:
                
                break;
            case tsInputOffNo:
                
                break;
                
            default:
                
                break;
        }
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

#pragma ContentViewDelegate
- (void)GetUserNameWithStr:(NSString *)userName {
    _userName = userName;
}

- (void)GetPassWordWithStr:(NSString *)passWord {
    _passWord = passWord;
}

- (void)updateView {
    _tips.text = _tip;
}

#pragma Gesture
- (void)setGesture{
    self.upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.upGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    if(self.key == nil){
        self.key = [[YcKeyBoardView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 180, [UIScreen mainScreen].bounds.size.width, 40)];
    }
    self.key.delegate = self;
    [self.key.textView becomeFirstResponder];
    self.key.textView.textAlignment = NSTextAlignmentCenter;
    self.key.textView.font = [UIFont systemFontOfSize:25];
    self.key.textView.inputView = [LNNumberpadPhone defaultLNNumberpad];
    [LNNumberpadPhone defaultLNNumberpad].delegate = self;
    [self.view addSubview:self.key];
}

//上滑键盘的方法
-(void)keyboardShow:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform = CGAffineTransformMakeTranslation(0, -410);//origin.y - 253
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        //重置位置坐标
        self.key.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _KeyBoardText = self.key.textView.text;
        self.key.textView.text = @"";
        [self.key removeFromSuperview];
        if (_NumberPadFlag) {
            [self sendAssignSpeed];
        }
    }];
}

-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    [contentView resignFirstResponder];
    //接口请求
    _KeyBoardText = self.key.textView.text;
}

#pragma mark -modelDelegate
- (void)UnconnectionTips {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tips.text = @"未连接";
    });
}

- (void)updateWithState:(TTestState)state Tips:(NSString *)tips Camera:(BOOL)camera Stand:(NSString *)standard Speed:(NSString *)speed Car:(NSMutableString *)car Sample:(NSMutableArray *)sample standArray:(NSMutableArray *)standArr errorArray:(NSMutableArray *)errorArr User:(NSString *)user {
    _state = state;
    _tip = tips;
    _hasCamera = camera;
    _userName = user;
    [self updateView];
}

//零时用的
- (void)UpdateWithState:(TTestState)state Tips:(NSString *)tips Camera:(BOOL)camera Bg:(BOOL)bg HY:(NSMutableString *)hy JD:(NSMutableString *)jd Car:(NSMutableString *)car Sample:(NSMutableArray *)sample standArray:(NSMutableArray *)standArr Standard:(NSString *)sd Speed:(NSString *)sp{
    _state = state;
    _hasCamera = camera;
    _hasBG = bg;
    _userName = jd;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateView];
        _tips.text = tips;
    });
}

#pragma mark -CaptureViewDelegate
- (void)captureCarNumber:(NSString *)car {
    _inputCarNo = car;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
