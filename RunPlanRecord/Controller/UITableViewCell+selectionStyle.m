//
//  UITableViewCell+selectionStyle.m
//  Weima
//
//  Created by Windy on 2017/9/15.
//  Copyright © 2017年 微马科技控股有限公司. All rights reserved.
//

#import "UITableViewCell+selectionStyle.h"

@implementation UITableViewCell (selectionStyle)

+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method m1 = class_getInstanceMethod([self class], @selector(initWithCoder:));
//        Method m2 = class_getInstanceMethod([self class], @selector(wm_initWithCoder:));
//        method_exchangeImplementations(m1, m2);
//    });
}

//- (instancetype)xx_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    [self xx_initWithStyle:style reuseIdentifier:reuseIdentifier];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    return self;
//}


- (instancetype)wm_initWithCoder:(NSCoder *)aDecoder{

    [self wm_initWithCoder:aDecoder];
//    self.contentView.backgroundColor =  WMColor(43, 43, 43);   //[UIColor blackColor];
//    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//    self.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0x262626];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}



@end
