//
//  ViewController.m
//  YUSlider
//
//  Created by 于博洋 on 2017/2/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "ViewController.h"
#import "YUSilderView.h"

@interface ViewController ()<YUSilderViewDelegate>

@property (nonatomic,strong) YUSilderView * silderView;

@property (nonatomic,strong) UIButton * startBut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.silderView];
    [self.view addSubview:self.startBut];
}

- (void)startButAction {
    [self.silderView movePointImageView:arc4random()%7 + 1 animation:YES];
}


#pragma mark - getter

- (YUSilderView *)silderView {
    if (_silderView == nil) {
        _silderView = [[YUSilderView alloc] initWithFrame:CGRectMake(10, 100, 200, 64)];
        _silderView.silderViewDelegate = self;
        [_silderView setupSilderViewWithAllLevels:7 initialLevel:1];
    }
    return _silderView;
}

- (UIButton *)startBut {
    if (_startBut == nil) {
        _startBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBut setTitle:@"动" forState:UIControlStateNormal];
        _startBut.frame = CGRectMake(10, 200, 44, 44);
        [_startBut addTarget:self action:@selector(startButAction) forControlEvents:UIControlEventTouchUpInside];
        _startBut.backgroundColor = [UIColor redColor];
    }
    return _startBut;
}


#pragma mark - YUSilderViewDelegate

- (void)selectSilderViewWithLeve:(NSInteger)leve {
    NSLog(@" leve - %ld",(long)leve);
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
