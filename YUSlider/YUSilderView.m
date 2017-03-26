//
//  YUSilderView.m
//  YUSlider
//
//  Created by 于博洋 on 2017/2/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//
#import "YUSilderView.h"

/*
 调节参数
 */

//刻度的宽高
static CGFloat const NonePointSizeWidth = 10;

//刻度2边的间隔
static CGFloat const BothSidesInterval = 15;

//滑块大小
static CGFloat const SliderWidth = 20;

//滑块触摸区域宽
static CGFloat const SliderTouchWidth = 25;

//两滑块之间最小等级
static CGFloat const MinimumLevelBetweenSliders = 10;



@interface YUSilderView ()<UIGestureRecognizerDelegate>

//method 左滑块选中的颜色
@property (nonatomic,strong) UIImageView * leftSelectedBgColorImageView;

//method 右滑块选中的颜色
@property (nonatomic,strong) UIImageView * rightSelectedBgColorImageView;

//method 刻度块
@property (nonatomic,strong) NSMutableArray * pointViewLists;

//method 刻度线（不显示刻度时需要）
@property (nonatomic,strong) UIView * longTypeLineView;

//method 左滑块（触摸区域）
@property (nonatomic,strong) UIView * sliderView;

//method 右滑块（触摸区域）
@property (nonatomic,strong) UIView * sliderViewMax;

//method 左滑块
@property (nonatomic,strong) UIImageView * sliderImageView;

//method 右滑块
@property (nonatomic,strong) UIImageView * sliderMaxImageView;

//method 最大等级
@property (nonatomic,assign,readonly) NSInteger allLevel;

//每个刻度之间的间隔 0--0--0  “- 为 unitLenght”
@property (nonatomic,assign) CGFloat unitLenght;


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
        
        [self addSubview:self.rightSelectedBgColorImageView];
        [self addSubview:self.leftSelectedBgColorImageView];
        [self addSubview:self.longTypeLineView];
        [self addSubview:self.sliderView];
        [self addSubview:self.sliderViewMax];
        
        [self.sliderView addSubview:self.sliderImageView];
        [self.sliderViewMax addSubview:self.sliderMaxImageView];
        
        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

#pragma mark - setter

- (void)setIsOpenClickSlide:(BOOL)isOpenClickSlide {
    _isOpenClickSlide = isOpenClickSlide;
    
    self.sliderView.userInteractionEnabled = !isOpenClickSlide;
    self.sliderViewMax.userInteractionEnabled = !isOpenClickSlide;
}

#pragma mark - 初始化方法

//双滑块初始化
- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels isShowPoint:(BOOL)isShowPoint initialLevel:(NSInteger)initialLevel maxInitialLevel:(NSInteger)maxInitialLevel {
    
    [self setupSilderViewWithAllLevels:allLevels isShowPoint:isShowPoint initialLevel:initialLevel];
    //不可开启
    self.isOpenClickSlide = NO;
    self.sliderViewMax.hidden = NO;
    self.rightSelectedBgColorImageView.hidden = NO;
    self.sliderViewMax.frame = CGRectMake(self.frame.size.width - BothSidesInterval - self.sliderView.frame.size.width, 0, self.sliderView.frame.size.width, self.frame.size.height);
    self.sliderMaxImageView.center = CGPointMake(self.sliderViewMax.frame.size.width/2, self.sliderViewMax.frame.size.height/2);
    
}

//单滑块初始化
- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels isShowPoint:(BOOL)isShowPoint initialLevel:(NSInteger)initialLevel {
    //默认开启
    self.isOpenClickSlide = YES;
    self.sliderViewMax.hidden = YES;
    self.rightSelectedBgColorImageView.hidden = YES;
    
    _allLevel = allLevels;
    
    self.leftSelectedBgColorImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.rightSelectedBgColorImageView.frame = self.leftSelectedBgColorImageView.frame;
    
    self.sliderView.frame = CGRectMake(BothSidesInterval, 0, SliderTouchWidth, self.frame.size.height);
    self.sliderImageView.center = CGPointMake(self.sliderView.frame.size.width/2, self.sliderView.frame.size.height/2);
    
    if (!isShowPoint) {
        self.longTypeLineView.frame = CGRectMake(BothSidesInterval, (self.frame.size.height - 1)/2, self.frame.size.width - BothSidesInterval * 2, 1);
        self.longTypeLineView.hidden = NO;
    }
    
    
    [self setSilderViewWithTypeNone:allLevels initialLevel:initialLevel isShowPoint:isShowPoint];

}



//初始化刻度点位置
- (void)setSilderViewWithTypeNone:(NSInteger)allLevels initialLevel:(NSInteger)initialLevel isShowPoint:(BOOL)isShowPoint {
    //添加刻度点
    [self addPointImageView:allLevels isShowPoint:isShowPoint];
    
    //0--0--0
    // "-" 4个等级
    UIImageView * pointImageView = self.pointViewLists[0];
    CGFloat allLenght = self.leftSelectedBgColorImageView.frame.size.width - BothSidesInterval * 2 - pointImageView.frame.size.width;
    _unitLenght = (allLenght/(allLevels * 2 - 2)); //7个等级分成12份
    
    //初始化刻度frame
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_apply(self.pointViewLists.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
            UIImageView * pointImageView = self.pointViewLists[index];
            NSInteger num = pointImageView.tag - 3000;
            CGFloat pointWidth = pointImageView.frame.size.width;
            CGFloat pointHeight = pointImageView.frame.size.height;
            CGFloat pointX = num * (_unitLenght * 2) + BothSidesInterval;
            
            CGRect rect = CGRectMake(pointX, (self.frame.size.height - pointHeight)/2, pointWidth, pointHeight);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                pointImageView.frame = rect;
            });
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self moveToPointImageView:initialLevel animation:NO sliderView:self.sliderView];
        });
    });
}

#pragma mark - 滑块移动到刻度点

- (void)moveToPointImageView:(NSInteger)leve animation:(BOOL)animation sliderView:(UIView *)sliderView {
    
    UIImageView * pointImageView = self.pointViewLists[leve - 1];
    CGFloat sliderCenterX = pointImageView.center.x;
    
    if (animation) {
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            
            sliderView.center = CGPointMake(sliderCenterX, sliderView.center.y);
            [self setvalueLineview];
            
        } completion:^(BOOL finished) {
            if (finished) {
                if (sliderView == self.sliderView) {
                    if ([self.silderViewDelegate respondsToSelector:@selector(silderViewValuesChangeWithMinleve:silderView:)]) {
                        [self.silderViewDelegate silderViewValuesChangeWithMinleve:leve silderView:self];
                    }
                }
                else if (sliderView == self.sliderViewMax) {
                    if ([self.silderViewDelegate respondsToSelector:@selector(silderViewValuesChangeWithMaxleve:silderView:)]) {
                        [self.silderViewDelegate silderViewValuesChangeWithMaxleve:leve silderView:self];
                    }
                }
            }
        }];
    }
    else {
        
        sliderView.center = CGPointMake(sliderCenterX, self.sliderView.center.y);
        [self setvalueLineview];
        if (sliderView == self.sliderView) {
            if ([self.silderViewDelegate respondsToSelector:@selector(silderViewValuesChangeWithMinleve:silderView:)]) {
                [self.silderViewDelegate silderViewValuesChangeWithMinleve:leve silderView:self];
            }
        }
        else if (sliderView == self.sliderViewMax) {
            if ([self.silderViewDelegate respondsToSelector:@selector(silderViewValuesChangeWithMaxleve:silderView:)]) {
                [self.silderViewDelegate silderViewValuesChangeWithMaxleve:leve silderView:self];
            }
        }
        
    }
    
    
}

#pragma mark - touchDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.isOpenClickSlide) {
        NSInteger currentLeve = [self getCurrentLevelWithTouch:touches];
        [self moveToPointImageView:currentLeve animation:YES sliderView:self.sliderView];
    }
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.isOpenClickSlide) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        
        if (location.x <= 0) {
            location.x = 0;
        }
        
        if (location.x >= self.frame.size.width) {
            location.x = self.frame.size.width;
        }
        
        CGPoint point = CGPointMake(location.x, self.sliderView.center.y);
        self.sliderView.center = point;
        
        [self setvalueLineview];
    }

    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isOpenClickSlide) {
        NSInteger currentLeve = [self getCurrentLevelWithTouch:touches];
        [self moveToPointImageView:currentLeve animation:YES sliderView:self.sliderView];
    }

}

#pragma mark - handleTableviewCellLongPressed

- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    
    NSInteger currentLeve = [self getCurrentLevel:point.x];
    //滑动左滑块
    if (gestureRecognizer.view == self.sliderView) {
        //2个滑块
        if (self.sliderViewMax.hidden == NO) {
            //当前右滑块的等级
            NSInteger currentRightSliderLeve = [self getCurrentLevel:self.sliderViewMax.center.x];
            if (currentLeve + MinimumLevelBetweenSliders >= currentRightSliderLeve) {
                currentLeve = currentRightSliderLeve - MinimumLevelBetweenSliders;
            }
        }
        [self moveToPointImageView:currentLeve animation:NO sliderView:self.sliderView];
    }
    else if (gestureRecognizer.view == self.sliderViewMax) {
        //当前左滑块的等级
        NSInteger currentLeftSliderLeve = [self getCurrentLevel:self.sliderView.center.x];
        if (currentLeve - MinimumLevelBetweenSliders <= currentLeftSliderLeve) {
            currentLeve = currentLeftSliderLeve + MinimumLevelBetweenSliders;
        }
        [self moveToPointImageView:currentLeve animation:NO sliderView:self.sliderViewMax];
        
    }
}



/**
 * method 根据 UITouch 获取当前 等级
 * 逻辑解释见：http://www.jianshu.com/p/958d1aa0493f
 */
- (NSInteger)getCurrentLevelWithTouch:(NSSet<UITouch *> *)touches {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGFloat touchMoveX = location.x ;
    
    return [self getCurrentLevel:touchMoveX];
    
}

- (NSInteger)getCurrentLevel:(CGFloat)touchMoveX {
    
    CGFloat originX = BothSidesInterval;
    //最小
    if (touchMoveX <= 0) {
        return 1;
    }
    
    //最大
    if (touchMoveX > originX + _unitLenght * (_allLevel - 1) * 2 + 1) {
        return _allLevel;
    }
    
    for (int i = 0; i < _allLevel; i++) {
        NSInteger level = (i*2+1);
        
        if (touchMoveX <= originX + _unitLenght * level) {
            touchMoveX = originX + _unitLenght * (level-1);
            NSInteger nowLevel = (((long)level-1)/2)+1;
            return nowLevel;
        }
    }
    
    //出错了自动校验
    return 1;
}

//刷新UI
- (void)setvalueLineview {
    
    CGFloat leftSliderDistance = self.sliderView.center.x;
    
    self.leftSelectedBgColorImageView.frame = CGRectMake(0, self.leftSelectedBgColorImageView.frame.origin.y, leftSliderDistance, self.leftSelectedBgColorImageView.frame.size.height);
    
    CGFloat rightSliderDistance = self.frame.size.width - self.sliderViewMax.center.x;
    
    self.rightSelectedBgColorImageView.frame = CGRectMake(self.sliderViewMax.center.x, self.rightSelectedBgColorImageView.frame.origin.y, rightSliderDistance, self.rightSelectedBgColorImageView.frame.size.height);
    
    
}

//增加刻度点
- (void)addPointImageView:(NSInteger)allLevels isShowPoint:(BOOL)isShowPoint {
    for (int i = 0; i < allLevels; i++) {
        UIImageView * pointImageView = [[UIImageView alloc] init];

        CGFloat pointSizeWidth = NonePointSizeWidth;
        if (!isShowPoint) {
            pointSizeWidth = 1;
            pointImageView.backgroundColor = [UIColor clearColor];
        }
        else {
            pointImageView.backgroundColor = [UIColor yellowColor];
        }
        //设置pointImageView的size
        pointImageView.frame = CGRectMake(0, 0, pointSizeWidth, pointSizeWidth);
        pointImageView.tag = 3000 + i;
        
        //添加到数组中
        [self.pointViewLists addObject:pointImageView];
        
        if (isShowPoint) {
            //在背景色上面
            [self insertSubview:pointImageView aboveSubview:self.leftSelectedBgColorImageView];
        }
    }
}



#pragma mark - getter



- (UIImageView *)leftSelectedBgColorImageView {
    if (_leftSelectedBgColorImageView == nil) {
        _leftSelectedBgColorImageView = [[UIImageView alloc] init];
        _leftSelectedBgColorImageView.backgroundColor = [UIColor grayColor];
    }
    return _leftSelectedBgColorImageView;
}

- (UIImageView *)rightSelectedBgColorImageView {
    if (_rightSelectedBgColorImageView == nil) {
        _rightSelectedBgColorImageView = [[UIImageView alloc] init];
        _rightSelectedBgColorImageView.backgroundColor = [UIColor blueColor];
        _rightSelectedBgColorImageView.hidden = YES;
    }
    return _rightSelectedBgColorImageView;
}

- (NSMutableArray *)pointViewLists {
    if (_pointViewLists == nil) {
        _pointViewLists = [[NSMutableArray alloc] init];
    }
    return _pointViewLists;
}


- (UIView *)sliderView {
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = [UIColor clearColor];
        
        _sliderView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        //代理
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.001;
        [_sliderView addGestureRecognizer:longPress];
    }
    return _sliderView;
}


- (UIView *)sliderViewMax {
    if (_sliderViewMax == nil) {
        _sliderViewMax = [[UIView alloc] init];
        _sliderViewMax.backgroundColor = [UIColor clearColor];
        _sliderViewMax.hidden = YES;
        
        _sliderViewMax.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        //代理
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.001;
        [_sliderViewMax addGestureRecognizer:longPress];
        
    }
    return _sliderViewMax;
}

- (UIImageView *)sliderImageView {
    if (_sliderImageView == nil) {
        _sliderImageView = [[UIImageView alloc] init];
        _sliderImageView.backgroundColor = [UIColor redColor];
        _sliderImageView.frame = CGRectMake(0, 0, SliderWidth, SliderWidth);
        _sliderImageView.layer.cornerRadius = SliderWidth/2;
    }
    return _sliderImageView;
}

- (UIImageView *)sliderMaxImageView {
    if (_sliderMaxImageView == nil) {
        _sliderMaxImageView = [[UIImageView alloc] init];
        _sliderMaxImageView.backgroundColor = [UIColor redColor];
        _sliderMaxImageView.frame = CGRectMake(0, 0, SliderWidth, SliderWidth);
        _sliderMaxImageView.layer.cornerRadius = SliderWidth/2;
    }
    return _sliderMaxImageView;
}


- (UIView *)longTypeLineView {
    if (_longTypeLineView == nil) {
        _longTypeLineView = [[UIView alloc] init];
        _longTypeLineView.backgroundColor = [UIColor yellowColor];
        _longTypeLineView.hidden = YES;
    }
    return _longTypeLineView;
}








@end
