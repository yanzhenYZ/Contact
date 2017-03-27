//
//  PersonsTableViewController.m
//  test
//
//  Created by yanzhen on 17/3/24.
//  Copyright © 2017年 v2tech. All rights reserved.
//

#import "PersonsTableViewController.h"
#import "PersonTableViewCell.h"
#import "Person.h"
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>

@interface PersonsTableViewController ()<MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSArray<Person *> *dataSource;
@end

@implementation PersonsTableViewController

-(instancetype)initWithDataSource:(NSArray *)dataSource{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonTableViewCell"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发短信" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)sendMessage{
    __block NSMutableArray *phones = [[NSMutableArray alloc] init];
    [_dataSource enumerateObjectsUsingBlock:^(Person * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            if (obj.telePhones.count > 0) {
                [phones addObject:obj.telePhones[0]];
            }
        }
    }];
    if (phones.count > 0) {
        [self showMessageView:phones title:@"test" body:@"这是测试用短信，勿回复！"];
    }
}

-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonTableViewCell" forIndexPath:indexPath];
    [cell configure:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Person *p = _dataSource[indexPath.row];
    p.selected = !p.selected;
    [tableView reloadData];
}

@end
