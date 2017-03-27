//
//  ViewController.m
//  test
//
//  Created by yanzhen on 17/3/24.
//  Copyright © 2017年 v2tech. All rights reserved.
//

#import "ViewController.h"
#import "PersonsTableViewController.h"
#import "Person.h"
//9.0
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ViewController ()<CNContactPickerDelegate>
@property (nonatomic, strong) NSMutableArray<Person *> *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataSource = [[NSMutableArray alloc] init];
    [self requestAccess];
}

//获取通讯录权限
- (void)requestAccess{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (CNAuthorizationStatusNotDetermined == status) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAllPerson];
            });
        }];
    }else if (CNAuthorizationStatusAuthorized == status){
        [self getAllPerson];
    }else{
        NSLog(@"----没有获得授权----");
    }
}

- (void)getAllPerson{
    //通讯录存储的管理类
    CNContactStore *stroe = [[CNContactStore alloc] init];
    //取出联系人的请求类
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactPhoneNumbersKey,CNContactGivenNameKey,CNContactFamilyNameKey,CNContactImageDataKey]];
    //取出联系人的block执行，有多少联系人就执行多少次
    __block NSMutableArray *peoples = [NSMutableArray array];
    [stroe enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        Person *p = [[Person alloc] init];
        NSString *name = @"";
        if (contact.familyName.length > 0) {
            name = [name stringByAppendingString:contact.familyName];
        }
        
        if (contact.givenName.length > 0) {
            name = [name stringByAppendingString:contact.givenName];
        }
        p.name = name;
        
        //电话
        __block NSMutableArray *phones = [NSMutableArray array];
        [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CNPhoneNumber *num = (CNPhoneNumber *)obj.value;
            [phones addObject:num.stringValue];
        }];
        p.telePhones = phones;
        //头像
        p.headImg = [UIImage imageWithData:contact.imageData];
        
        [peoples addObject:p];
    }];
    [_dataSource addObjectsFromArray:peoples];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//1
    PersonsTableViewController *vc = [[PersonsTableViewController alloc] initWithDataSource:self.dataSource];
    [self.navigationController pushViewController:vc animated:YES];
#pragma mark - 2
//    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] init];
//    vc.delegate = self;
//    [self.navigationController presentViewController:vc animated:YES completion:nil];

}

#pragma mark - CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    NSLog(@"--- %s ---",__func__);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    NSLog(@"--- %s ---",__func__);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    NSLog(@"--- %s ---",__func__);
}

/*!
 * @abstract Plural delegate methods.
 * @discussion These delegate methods will be invoked when the user is done selecting multiple contacts or properties.
 * Implementing one of these methods will configure the picker for multi-selection.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{
    [contacts enumerateObjectsUsingBlock:^(CNContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull num, NSUInteger idx, BOOL * _Nonnull stop) {
            CNPhoneNumber *number = (CNPhoneNumber *)num.value;
            NSLog(@"TTTT:%@",number.stringValue);
        }];
    }];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties{
    NSLog(@"--- %s ---",__func__);
}
@end
