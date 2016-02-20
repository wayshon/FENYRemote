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

@property (nonatomic) NSMutableString *userName;
@property (nonatomic) NSMutableString *passWord;
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
    
    __block PhoneRemoteVC *blockSelf = self;
    _model.RemoteUpdateBlock = ^(TTestState state,NSString *tips,BOOL camera,BOOL bg,NSMutableString *jd){
        _state = state;
        _hasCamera = camera;
        _hasBG = bg;
        _userName = jd;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf updateView];
            blockSelf.tips.text = tips;
        });
    };
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
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

#warning Incomplete implementation
//iphone版的alertview尺寸都还没弄
- (void)alertViewJD {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    ConttentView *contentView = [[ConttentView alloc] initWithImg:@"JDenterBG"];
    [contentView.userName becomeFirstResponder];
    [alert setContainerView:contentView];
    contentView.delegate = self;
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"登入", nil]];
    [alert setDelegate:self];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [contentView.userName resignFirstResponder];
        [contentView.passWord resignFirstResponder];
        if (buttonIndex == 0) {
            [alertView close];
        }else if(buttonIndex == 1){
#warning Incomplete implementation
            //这里发送登入指令
            uint8_t CMD = 0x3D;
            TKeyValue action = kvUserEnter;
            NSMutableString *sendStr = _userName;
            [sendStr appendString:_passWord];
            uint8_t content[13];
            content[0] = action;
            for (int i = 1; i < 13; i++) {
                content[i] = [sendStr characterAtIndex:i-1];
            }
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
            [alertView close];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(EnterErrorAlertView) userInfo:nil repeats:NO];
        }
    }];
    
    //[alert setUseMotionEffects:YES];
    
    [alert show];
}

- (void)EnterErrorAlertView {
    if (_state <= tsWaitLogIn) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登入不成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

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
                    content[i] = [_inputCarNo characterAtIndex:i-1];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
                [alertView close];
            }
        }];
    }else {
        [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"确定", nil]];
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [captureView.carNumber resignFirstResponder];
            
            if (buttonIndex == 0) {
                [alertView close];
            }else {
#warning Incomplete implementation
                //这里发送车牌号
                uint8_t CMD = 0x3D;
                TKeyValue action = kvManualCapture;
                uint8_t content[7];
                content[0] = action;
                for (int i = 1; i < 7; i++) {
                    content[i] = [_inputCarNo characterAtIndex:i-1];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
                [alertView close];
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
                uint8_t content[3];
                content[0] = action;
                content[1] = (unsigned char)(([_KeyBoardText intValue] * 10) >> 8);
                content[2] = (unsigned char)(([_KeyBoardText intValue] * 10) & 0xffu);
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:3];
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
    if (userName.length > 0) {
        self.userName = [[NSMutableString alloc] initWithString:userName];
        switch (_userName.length) {
            case 1:
                for (int i = 0; i < 5; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 2:
                for (int i = 0; i < 4; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 3:
                for (int i = 0; i < 3; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 4:
                for (int i = 0; i < 2; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 5:
                [self.userName appendString:@"0"];
                break;
                
            default:
                break;
        }
    }
}

- (void)GetPassWordWithStr:(NSString *)passWord {
    if (passWord.length > 0) {
        self.passWord = [[NSMutableString alloc] initWithString:passWord];
        switch (_passWord.length) {
            case 1:
                for (int i = 0; i < 5; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 2:
                for (int i = 0; i < 4; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 3:
                for (int i = 0; i < 3; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 4:
                for (int i = 0; i < 2; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 5:
                [self.passWord appendString:@"0"];
                break;
                
            default:
                break;
        }
    }
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

#pragma mark -CaptureViewDelegate
- (void)captureCarNumber:(NSString *)car {
    _inputCarNo = car;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
