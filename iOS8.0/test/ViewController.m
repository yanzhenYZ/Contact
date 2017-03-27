//
//  ViewController.m
//  test
//
//  Created by yanzhen on 17/3/24.
//  Copyright © 2017年 v2tech. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PersonsTableViewController.h"
#import "Person.h"
//9.0
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface ViewController ()<ABPeoplePickerNavigationControllerDelegate>
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
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CFErrorRef *error = NULL;
                    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, error);
                    [self getAllAddressBook:book];
                });
            }else{
                
            }
        });
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef *error = NULL;
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, error);
        [self getAllAddressBook:book];
    }else{
        NSLog(@"----没有获得授权----");
    }
}

- (void)getAllAddressBook:(ABAddressBookRef)addressBookRef{
    CFIndex personCount = ABAddressBookGetPersonCount(addressBookRef);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    for (int i = 0; i < personCount; i++) {
        Person *p = [[Person alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *name = @"";
#warning mark - firstName lastName 都有可能为空
        if (lastName.length > 0) {
            name = [name stringByAppendingString:lastName];
        }
        
        if (firstName.length > 0) {
            name = [name stringByAppendingString:firstName];
        }
        //[lastName stringByAppendingString:firstName];
        p.name = lastName;
        //电话
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSMutableArray *phones = [[NSMutableArray alloc] init];
        for (int k = 0; k < ABMultiValueGetCount(phone); k++)
        {
//            //获取电话Label
//            NSString * personPhoneLabel = (__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            if (personPhone.length > 0) {
                [phones addObject:personPhone];
            }
        }
        p.telePhones = phones;
        //头像
        NSData *imageData = (__bridge NSData*)ABPersonCopyImageData(person);
        p.headImg = [UIImage imageWithData:imageData];
        [_dataSource addObject:p];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    PersonsTableViewController *vc = [[PersonsTableViewController alloc] initWithDataSource:self.dataSource];
    [self.navigationController pushViewController:vc animated:YES];
    
//    //通讯录存储的管理类
//    CNContactStore * stroe = [[CNContactStore alloc]init];
//    //取出联系人的请求类
//    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactPhoneNumbersKey,CNContactGivenNameKey,CNContactFamilyNameKey]];
//    //取出联系人的block执行，有多少联系人就执行多少次
//    [stroe enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//        
//        NSString * LinkName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
//        
//        NSArray * parr = contact.phoneNumbers;
//        
//    }];
}

- (void)testUI{
    ABPeoplePickerNavigationController *vc = [[ABPeoplePickerNavigationController alloc] init];
    vc.peoplePickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
#warning mark - 打开代理下面的方法会导致崩溃

// Called after a person has been selected by the user.
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person{
//    NSLog(@"--- %s ---",__func__);
//    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
//    personViewController.displayedPerson = person;
//    [peoplePicker pushViewController:personViewController animated:YES];
//}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    NSLog(@"--- %s ---",__func__);
}

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}


// Deprecated, use predicateForSelectionOfPerson and/or -peoplePickerNavigationController:didSelectPerson: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    NSLog(@"--- %s ---",__func__);
    return NO;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    NSLog(@"--- %s ---",__func__);
    return YES;
}

@end
