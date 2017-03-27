//
//  Person.h
//  test
//
//  Created by yanzhen on 17/3/24.
//  Copyright © 2017年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *telePhones;
@property (nonatomic, strong) UIImage *headImg;
@property (nonatomic) BOOL selected;
@end
