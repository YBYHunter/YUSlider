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

@property (nonatomic,strong) UILabel * minLab;

@property (nonatomic,strong) UILabel * maxLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.silderView];
    [self.view addSubview:self.silderViewBig];
    [self.view addSubview:self.silderViewDouble];
    
    [self.view addSubview:self.minLab];
    [self.view addSubview:self.maxLab];
}


#pragma mark - YUSilderViewDelegate

- (void)silderViewValuesChangeWithMinleve:(NSInteger)minLeve silderView:(UIView *)silderView {
    
    NSLog(@" minLeve - %ld",(long)minLeve);
    self.minLab.text = [NSString stringWithFormat:@"最小值：%ld",(long)minLeve];
}

- (void)silderViewValuesChangeWithMaxleve:(NSInteger)maxLeve silderView:(UIView *)silderView {
    NSLog(@" maxLeve - %ld",(long)maxLeve);
    self.maxLab.text = [NSString stringWithFormat:@"最大值：%ld",(long)maxLeve];
}



#pragma mark - getter

- (YUSilderView *)silderViewBig {
    if (_silderViewBig == nil) {
        _silderViewBig = [[YUSilderView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 200, 250, 64)];
        _silderViewBig.silderViewDelegate = self;
        [_silderViewBig setupSilderViewWithAllLevels:100 isShowPoint:NO initialLevel:2];
        _silderViewBig.isOpenClickSlide = NO;
    }
    return _silderViewBig;
}

- (YUSilderView *)silderViewDouble {
    if (_silderViewDouble == nil) {
        _silderViewDouble = [[YUSilderView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 300, 250, 64)];
        _silderViewDouble.silderViewDelegate = self;
        [_silderViewDouble setupSilderViewWithAllLevels:100 isShowPoint:NO initialLevel:2 maxInitialLevel:99];
    }
    return _silderViewDouble;
}

- (YUSilderView *)silderView {
    if (_silderView == nil) {
        _silderView = [[YUSilderView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 100, 250, 64)];
        _silderView.silderViewDelegate = self;
        [_silderView setupSilderViewWithAllLevels:7 isShowPoint:YES initialLevel:2];
    }
    return _silderView;
}

- (UILabel *)minLab {
    if (_minLab == nil) {
        _minLab = [[UILabel alloc] init];
        _minLab.frame = CGRectMake((self.view.frame.size.width - 100)/2, 400, 100, 44);
        _minLab.textColor = [UIColor blackColor];
        _minLab.text = @"最小值:**";
    }
    return _minLab;
}

- (UILabel *)maxLab {
    if (_maxLab == nil) {
        _maxLab = [[UILabel alloc] init];
        _maxLab.frame = CGRectMake((self.view.frame.size.width - 100)/2, 444, 100, 44);
        _maxLab.textColor = [UIColor blackColor];
        _maxLab.text = @"最大值:**";
    }
    return _maxLab;
}



















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
