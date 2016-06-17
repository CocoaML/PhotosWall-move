//
//  QYPhotoWall.m
//  04-PhotoWallDemo
//
//  Created by qingyun on 16/5/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYPhotoWall.h"
#import "QYImageTile.h"
#import "Masonry.h"
#import "Common.h"
@implementation QYPhotoWall

+(instancetype)photoWall{
    QYPhotoWall *photoWall = [[QYPhotoWall alloc] init];
    [photoWall addSubImageTile];
    return photoWall;
}

//添加瓦片
-(void)addSubImageTile{
    for (int i = 1; i < 7; i++) {
        QYImageTile *imageTile = [[QYImageTile alloc] init];
        [self addSubview:imageTile];
        
        imageTile.tag = imageTile.tileIndex = 100 + i;
        NSString *tileName = [NSString stringWithFormat:@"cat%d.jpg",i];
        imageTile.image = [UIImage imageNamed:tileName];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [imageTile addGestureRecognizer:pan];
    }
}

//处理平移手势
-(void)pan:(UIPanGestureRecognizer *)panGestureRecognizer{
    //获取当前平移手势作用的视图panView
    QYImageTile *panView = (QYImageTile *)panGestureRecognizer.view;
    __weak QYPhotoWall *weakSelf = self;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //1.panView置顶
        [self bringSubviewToFront:panView];
        //2.获取手势作用点(在照片墙上的点)
        CGPoint location = [panGestureRecognizer locationInView:self];
        //3.更改panView的约束(缩小,重置位置)
        [panView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(QYScreenW / 4.0, QYScreenW/4.0));
            make.centerX.equalTo(weakSelf.mas_left).with.offset(location.x);
            make.centerY.equalTo(weakSelf.mas_top).with.offset(location.y);
        }];
        //4.添加动画(更改透明度)
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf layoutIfNeeded];
            panView.alpha = 0.8;
        }];
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        //1.获取手势作用点(在照片墙上的点)
        CGPoint location = [panGestureRecognizer locationInView:self];
        //2.更改panView的约束(缩小,重置位置)
        [panView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(QYScreenW / 4.0, QYScreenW/4.0));
            make.centerX.equalTo(weakSelf.mas_left).with.offset(location.x);
            make.centerY.equalTo(weakSelf.mas_top).with.offset(location.y);
        }];
        
        //3.获取当前手势作用的点所在的视图(panView除外)
        NSInteger findTag = [self pointInView:panView point:location];
        //4.判断findTag有效
        if (findTag != -1) {
            //保存findTag
            NSInteger tempTag = findTag;
            
            if (findTag > panView.tag) {
                //当findTag > panView.tag,让[(panView.tag + 1) - findTag]区间内的所有的视图的tag值和tileIndex都 减1
                [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.tag > panView.tag && obj.tag <= findTag) {
                        QYImageTile *tile = (QYImageTile *)obj;
                        tile.tag = tile.tileIndex -= 1;
                    }
                }];
            }else{
                //当findTag < panView.tag,rang[findTag - (panView.tag - 1)]区间内的所有的视图的tag值和tileIndex 都 加1
                [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.tag >= findTag && obj.tag < panView.tag) {
                        QYImageTile *tile = (QYImageTile *)obj;
                        tile.tag = tile.tileIndex += 1;
                    }
                }];
            }
            //存储panView应有的tag(为之后设置tileIndex做准备)
            panView.tag = tempTag;
            
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
                [weakSelf layoutIfNeeded];
            } completion:^(BOOL finished) {}];
        }
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        //1.更新panView的tileIndex为tag
        panView.tileIndex = panView.tag;
        //2.执行动画
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            [weakSelf layoutIfNeeded];
        } completion:^(BOOL finished) {
            panView.alpha = 1.0;
        }];
    }
}

//获取当前手势作用的点所在的视图 panView point:手势作用在照片墙中的点
-(NSInteger)pointInView:(QYImageTile *)panView point:(CGPoint)point{
    
    __block NSInteger findTag = -1;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //判断obj不是view
        if (obj != panView) {
            if (CGRectContainsPoint(obj.frame, point)) {
                findTag = obj.tag;
                *stop = YES;
            }
        }
    }];
    return findTag;
}















@end
