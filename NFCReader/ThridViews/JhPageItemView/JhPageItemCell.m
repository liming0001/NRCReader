//
//  JhPageItemCell.m
//  JhPageItemView
//
//  Created by Jh on 2018/11/15.
//  Copyright © 2018 Jh. All rights reserved.
//

#import "JhPageItemCell.h"

@implementation JhPageItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = [UIColor colorWithHexString:@"#c1c1c1"].CGColor;
    self.layer.borderWidth = 0.5;
}


-(void)setData:(JhPageItemModel *)data{
    _data=data;
    self.customTextLabel.text = _data.text;
    self.customTextLabel.textColor = [UIColor colorWithHexString:_data.colorString];
    self.imgView.image = [UIImage imageNamed:_data.img];


}



@end
