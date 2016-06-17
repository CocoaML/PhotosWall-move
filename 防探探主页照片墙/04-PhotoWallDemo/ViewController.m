//
//  ViewController.m
//  04-PhotoWallDemo
//
//  Created by qingyun on 16/5/21.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"
#import "QYPhotoWall.h"
#import "Common.h"
@interface ViewController ()
@property (nonatomic, strong) QYPhotoWall *photoWall;
@end

@implementation ViewController

-(QYPhotoWall *)photoWall{
    if (_photoWall == nil) {
        _photoWall = [QYPhotoWall photoWall];
        
        _photoWall.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _photoWall;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加照片墙
    [self.view addSubview:self.photoWall];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(self.view,_photoWall);
    
    NSNumber *wNum = @(QYScreenW);
    
    NSDictionary *metrics = NSDictionaryOfVariableBindings(wNum);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_photoWall]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_photoWall(wNum)]" options:0 metrics:metrics views:views]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
