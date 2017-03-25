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

@property (nonatomic,strong) YUSilderView * silderViewBig;

@property (nonatomic,strong) YUSilderView * silderViewDouble;

@property (nonatomic,strong) UIButton * startBut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.silderView];
    [self.view addSubview:self.silderViewBig];
    [self.view addSubview:self.silderViewDouble];
    
    [self.view addSubview:self.startBut];
}

- (void)startButAction {
    [self.silderView movePointImageView:arc4random()%7 + 1 animation:YES];
}


#pragma mark - getter

- (YUSilderView *)silderViewBig {
    if (_silderViewBig == nil) {
        _silderViewBig = [[YUSilderView alloc] initWithFrame:CGRectMake(10, 200, 200, 64)];
        _silderViewBig.silderViewDelegate = self;
        [_silderViewBig setupSilderViewWithAllLevels:100 initialLevel:2 type:YUSilderViewTypeLong];
    }
    return _silderViewBig;
}

- (YUSilderView *)silderViewDouble {
    if (_silderViewDouble == nil) {
        _silderViewDouble = [[YUSilderView alloc] initWithFrame:CGRectMake(10, 300, 200, 64)];
        _silderViewDouble.silderViewDelegate = self;
        [_silderViewDouble setupSilderViewWithAllLevels:3 initialLevel:2 type:YUSilderViewTypeDouble];
    }
    return _silderViewDouble;
}

- (YUSilderView *)silderView {
    if (_silderView == nil) {
        _silderView = [[YUSilderView alloc] initWithFrame:CGRectMake(10, 100, 200, 64)];
        _silderView.silderViewDelegate = self;
        [_silderView setupSilderViewWithAllLevels:5 initialLevel:2 type:YUSilderViewTypeNone];
    }
    return _silderView;
}

- (UIButton *)startBut {
    if (_startBut == nil) {
        _startBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBut setTitle:@"动" forState:UIControlStateNormal];
        _startBut.frame = CGRectMake(10, 400, 44, 44);
        [_startBut addTarget:self action:@selector(startButAction) forControlEvents:UIControlEventTouchUpInside];
        _startBut.backgroundColor = [UIColor redColor];
    }
    return _startBut;
}


#pragma mark - YUSilderViewDelegate

- (void)selectSilderViewWithLeve:(NSInteger)leve {
//    NSLog(@" leve - %ld",(long)leve);
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
