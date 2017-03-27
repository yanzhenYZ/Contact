//
//  PersonTableViewCell.m
//  test
//
//  Created by yanzhen on 17/3/24.
//  Copyright © 2017年 v2tech. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "Person.h"

@interface PersonTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;


@end

@implementation PersonTableViewCell

-(void)configure:(Person *)person{
    self.headImgView.image = [UIImage imageNamed:@"1234"];
    if (person.headImg) {
        self.headImgView.image = person.headImg;
    }
    self.nameLabel.text = person.name;
    if (person.telePhones.count > 0) {
        self.phoneLabel.text = person.telePhones[0];
    }
    
    self.selectedBtn.selected = person.selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
