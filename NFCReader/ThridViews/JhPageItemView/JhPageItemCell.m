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
    if ([_data.text isEqualToString:@"五花牛"]||[_data.text isEqualToString:@"五小牛"]|[_data.text isEqualToString:@"小三公"]||[_data.text isEqualToString:@"大三公"]) {
        self.customTextLabel.font = [UIFont systemFontOfSize:8];
    }else if ([_data.text isEqualToString:@"牛牛"]||[_data.text isEqualToString:@"炸弹"]||[_data.text isEqualToString:@"没牛"]||[_data.text isEqualToString:@"没点"]){
        self.customTextLabel.font = [UIFont systemFontOfSize:10];
    }else{
       self.customTextLabel.font = [UIFont systemFontOfSize:14];
    }
    self.customTextLabel.textColor = [UIColor colorWithHexString:_data.colorString];
    if (_data.img.length!=0) {
        self.imgView.image = [UIImage imageNamed:_data.img];
    }else{
        self.imgView.image = nil;
    }
}



@end
