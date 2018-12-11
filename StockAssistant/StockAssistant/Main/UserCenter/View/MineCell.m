//
//  MineCell.m
//  sock
//
//  Created by 王浩祯 on 2018/3/8.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;

        
    }
    return self;
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
