//
//  PersonTableViewCell.h
//  test
//
//  Created by yanzhen on 17/3/24.
//  Copyright © 2017年 v2tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;
@interface PersonTableViewCell : UITableViewCell
- (void)configure:(Person *)person;
@end
