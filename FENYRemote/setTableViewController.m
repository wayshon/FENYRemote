//
//  setTableViewController.m
//  ipadDemo
//
//  Created by 王旭 on 15/11/4.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "setTableViewController.h"

@interface setTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *LineIP;
@property (weak, nonatomic) IBOutlet UITextField *LinePort;
@property (weak, nonatomic) IBOutlet UITextField *HostIP;
@property (weak, nonatomic) IBOutlet UITextField *HostPort;
@end

@implementation setTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)LineSure:(id)sender {
    if ([_LineIP.text isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:_LinePort.text forKey:@"LinePort"];
    }else if ([_LinePort.text isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject:_LineIP.text forKey:@"LineIP"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_LineIP.text forKey:@"LineIP"];
        [[NSUserDefaults standardUserDefaults] setObject:_LinePort.text forKey:@"LinePort"];
    }
}

- (IBAction)HostSure:(id)sender {
    if ([_HostIP.text isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:_HostPort.text forKey:@"HostPort"];
    }else if ([_HostPort.text isEqualToString:@""]){
        [[NSUserDefaults standardUserDefaults] setObject:_HostIP.text forKey:@"HostIP"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_HostIP.text forKey:@"HostIP"];
        [[NSUserDefaults standardUserDefaults] setObject:_HostPort.text forKey:@"HostPort"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


@end
