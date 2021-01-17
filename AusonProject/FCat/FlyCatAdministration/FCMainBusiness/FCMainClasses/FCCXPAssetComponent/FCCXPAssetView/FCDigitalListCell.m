//
//  FCDigitalListCell.m
//  Auson
//
//  Created by Yochi on 2021/1/14.
//  Copyright © 2021 Yochi. All rights reserved.
//

#import "FCDigitalListCell.h"
#import "UIFont+Extension.h"
#import "PCMacroDefinition.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWidth(R) (R)*(kScreenWidth)/320
#define kHeight(R) (iPhone4?((R)*(kScreenHeight)/480):((R)*(kScreenHeight)/568))

#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度

@implementation FCDigitalListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = COLOR_HexColor(0x171B2B);
        self.contentView.backgroundColor = COLOR_HexColor(0x171B2B);
        
        //头像
        self.imgHead = [[UIImageView alloc]initWithFrame:CGRectMake(14, 15, 30, 30)];
        self.imgHead.layer.cornerRadius = 15;
        self.imgHead.layer.masksToBounds = YES;
        self.imgHead.image = [UIImage imageNamed:@"headerImage"];
        [self addSubview:self.imgHead];
        //列表中姓名
        self.labName = [[UILabel alloc]initWithFrame:CGRectMake(MaxX(self.imgHead) + 10, Y(self.imgHead), 150, HEIGHT(self.imgHead))];
        self.labName.textColor = [UIColor whiteColor];
        self.labName.font = [UIFont font_DINProBoldTypeSize:14];
        self.labName.text = @"USDT";
        [self addSubview:self.labName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
