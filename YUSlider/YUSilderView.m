//
//  YUSilderView.m
//  YUSlider
//
//  Created by 于博洋 on 2017/2/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "YUSilderView.h"

@interface YUSilderView ()

/**
 * method 选中的背景色
 */
@property (nonatomic,strong) UIImageView * selectedBgColorImageView;

/**
 * method 未选中的背景色
 */
@property (nonatomic,strong) UIImageView * notSelectedBgColorImageView;

/**
 * method 上面的刻度
 */
@property (nonatomic,strong) NSMutableArray * pointViewLists;

/**
 * method 上面拖动的点
 */
@property (nonatomic,strong) UIImageView * sliderImageView;

/**
 * method 当前等级
 */
@property (nonatomic,assign,readonly) NSInteger allLevel;

@property (nonatomic,assign) CGFloat unitLenght;
@property (nonatomic,assign) CGFloat originX;

@end


@implementation YUSilderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.selectedBgColorImageView];
        [self addSubview:self.notSelectedBgColorImageView];
        [self addSubview:self.sliderImageView];
        
    }
    return self;
}

#pragma mark - 初始化方法

- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels initialLevel:(NSInteger)initialLevel {
    
    CGFloat sliderWidth = 20;
    CGFloat sliderHeight = 20;
    _allLevel = allLevels;
    
    self.selectedBgColorImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.notSelectedBgColorImageView.frame = self.selectedBgColorImageView.frame;
    
    self.sliderImageView.frame = CGRectMake(0, (self.frame.size.height - sliderHeight)/2, sliderWidth, sliderHeight);
    
    //0--0--0--0--0--0--0
    // "-" 12个等级
    NSInteger allLenght = self.selectedBgColorImageView.frame.size.width;
    _originX = self.selectedBgColorImageView.frame.origin.x+3;
    _unitLenght = (allLenght/(allLevels * 2 - 2)); //7个等级分成12份
    
    dispatch_apply(self.pointViewLists.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        UIImageView * pointImageView = self.pointViewLists[index];
        NSInteger num = pointImageView.tag - 3000;
        CGFloat pointWidth = pointImageView.frame.size.width;
        CGFloat pointHeight = pointImageView.frame.size.height;
        
        CGRect rect = CGRectMake(num * (_unitLenght * 2), (self.frame.size.height - pointHeight)/2, pointWidth, pointHeight);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            pointImageView.frame = rect;
        });
    });
    
    
    [self movePointImageView:initialLevel animation:NO];
}

#pragma mark - 滑块移动位置方法（动画）

- (void)movePointImageView:(NSInteger)leve animation:(BOOL)animation {
    
    UIImageView * pointImageView = self.pointViewLists[leve - 1];
    CGFloat sliderCenterX = pointImageView.center.x;
    
    if (animation) {
        /*
         usingSpringWithDamping 的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显。
         initialSpringVelocity 则表示初始的速度，数值越大一开始移动越快，
         值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况。
         */
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.sliderImageView.center = CGPointMake(sliderCenterX, self.sliderImageView.center.y);
            [self setvalueLineview];
            
        } completion:^(BOOL finished) {
            if (finished) {
                if ([self.silderViewDelegate respondsToSelector:@selector(selectSilderViewWithLeve:)]) {
                    [self.silderViewDelegate selectSilderViewWithLeve:leve];
                }
            }
        }];
    }
    else {
        
        self.sliderImageView.center = CGPointMake(sliderCenterX, self.sliderImageView.center.y);
        [self setvalueLineview];
        if ([self.silderViewDelegate respondsToSelector:@selector(selectSilderViewWithLeve:)]) {
            [self.silderViewDelegate selectSilderViewWithLeve:leve];
        }
    }
    
    
}

#pragma mark - touchDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSInteger currentLeve = [self getCurrentLevelWithTouch:touches];
    [self movePointImageView:currentLeve animation:YES];
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGPoint point = CGPointMake(location.x, self.sliderImageView.center.y);
    self.sliderImageView.center = point;
    
    [self setvalueLineview];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSInteger currentLeve = [self getCurrentLevelWithTouch:touches];
    [self movePointImageView:currentLeve animation:YES];

}


/**
 * method 根据 UITouch 获取当前 等级
 * 逻辑解释见：http://www.jianshu.com/p/958d1aa0493f
 */
- (NSInteger)getCurrentLevelWithTouch:(NSSet<UITouch *> *)touches {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGFloat touchMoveX = location.x;
    
    for (int i = 0; i < _allLevel; i++) {
        NSInteger level = (i*2+1);
        if (touchMoveX <= _originX + _unitLenght * level) {
            touchMoveX = _originX + _unitLenght * (level-1);
            NSInteger nowLevel = (((long)level-1)/2)+1;
            
            return nowLevel;
        }
    }
    
    return 1;
}

- (void)setvalueLineview {
    
    CGFloat sliderDistance = self.sliderImageView.center.x;
    
    self.selectedBgColorImageView.frame = CGRectMake(0, self.selectedBgColorImageView.frame.origin.y, sliderDistance, self.selectedBgColorImageView.frame.size.height);
    
    
    self.notSelectedBgColorImageView.frame = CGRectMake(sliderDistance, self.notSelectedBgColorImageView.frame.origin.y, self.frame.size.width - sliderDistance, self.notSelectedBgColorImageView.frame.size.height);
    
}




#pragma mark - getter



- (UIImageView *)selectedBgColorImageView {
    if (_selectedBgColorImageView == nil) {
        _selectedBgColorImageView = [[UIImageView alloc] init];
        _selectedBgColorImageView.backgroundColor = [UIColor grayColor];
    }
    return _selectedBgColorImageView;
}

- (UIImageView *)notSelectedBgColorImageView {
    if (_notSelectedBgColorImageView == nil) {
        _notSelectedBgColorImageView = [[UIImageView alloc] init];
        _notSelectedBgColorImageView.backgroundColor = [UIColor blackColor];
    }
    return _notSelectedBgColorImageView;
}

- (NSMutableArray *)pointViewLists {
    if (_pointViewLists == nil) {
        _pointViewLists = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 7; i++) {
            UIImageView * pointImageView = [[UIImageView alloc] init];
            pointImageView.frame = CGRectMake(0, 0, 10, 10);
            pointImageView.tag = 3000 + i;
            pointImageView.backgroundColor = [UIColor yellowColor];
            [_pointViewLists addObject:pointImageView];
            //在图层最上面
//            [self addSubview:pointImageView];
            //在背景色上面
            [self insertSubview:pointImageView aboveSubview:self.notSelectedBgColorImageView];
        }
        
    }
    return _pointViewLists;
}


- (UIImageView *)sliderImageView {
    if (_sliderImageView == nil) {
        _sliderImageView = [[UIImageView alloc] init];
        _sliderImageView.backgroundColor = [UIColor blueColor];
    }
    return _sliderImageView;
}










@end
