//
//  QYImageTile.m
//  04-PhotoWallDemo
//
//  Created by qingyun on 16/5/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYImageTile.h"
#import "Masonry.h"
#import "Common.h"
@implementation QYImageTile

-(void)setTileIndex:(NSInteger)tileIndex{
    _tileIndex = tileIndex;
    
    self.userInteractionEnabled = YES;
    //计算各种瓦片的尺寸
    CGFloat width1 = QYScreenW / 3.0;
    CGFloat width2 = width1 * 2;
    
    switch (tileIndex) {
        case 101://左上角
        {
            //mas_remakeConstraints先清除之前的约束,再添加新的约束
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(width2, width2));
            }];
        }
            break;
        case 102://右上角
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(width1, width1));
            }];
        }
            break;
        case 103://右中间
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(width1, width1));
            }];
        }
            break;
        case 104://右下角
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(width1, width1));
            }];
        }
            break;
        case 105://下中间
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.centerX.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(width1, width1));
            }];
        }
            break;
        case 106://左下角
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(width1, width1));
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
