//
//  YUSilderView.m
//  YUSlider
//
//  Created by 于博洋 on 2017/2/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//
#import "YUSilderView.h"

//带刻度状态 刻度的宽高
static CGFloat const NonePointSizeWidth = 10;

//刻度2测的 间隔
static CGFloat const BothSidesInterval = 15;

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
 * method 上面拖动的点
 */
@property (nonatomic,strong) UIImageView * sliderImageViewMax;

/**
 * method 当前等级
 */
@property (nonatomic,assign,readonly) NSInteger allLevel;

@property (nonatomic,assign) CGFloat unitLenght;


@end


@implementation YUSilderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.selectedBgColorImageView];
        [self addSubview:self.notSelectedBgColorImageView];
        [self addSubview:self.sliderImageView];
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

- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels initialLevel:(NSInteger)initialLevel type:(YUSilderViewType)type {
    
    CGFloat sliderWidth = 20;
    CGFloat sliderHeight = 20;
    _allLevel = allLevels;
    
    
    self.selectedBgColorImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.notSelectedBgColorImageView.frame = self.selectedBgColorImageView.frame;
    self.sliderImageView.frame = CGRectMake(0, (self.frame.size.height - sliderHeight)/2, sliderWidth, sliderHeight);
    
    if (type == YUSilderViewTypeNone || type == YUSilderViewTypeLong) {
        [self setSilderViewWithTypeNone:allLevels initialLevel:initialLevel type:type];
    }
    else if (type == YUSilderViewTypeDouble) {
//        [self setSilderViewWithTypeLong:allLevels initialLevel:initialLevel ];
    }

}

//
- (void)setSilderViewWithTypeNone:(NSInteger)allLevels initialLevel:(NSInteger)initialLevel type:(YUSilderViewType)type {
    //添加刻度点
    [self addPointImageView:allLevels type:type];
    
    
    //0--0--0
    // "-" 4个等级
    UIImageView * pointImageView = self.pointViewLists[0];
    CGFloat allLenght = self.selectedBgColorImageView.frame.size.width - BothSidesInterval * 2 - pointImageView.frame.size.width;
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
            [self movePointImageView:initialLevel animation:NO];
        });
    });
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
    
    if (location.x <= 0) {
        location.x = 0;
    }
    
    if (location.x >= self.frame.size.width) {
        location.x = self.frame.size.width;
    }
    
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
    
    CGFloat touchMoveX = location.x ;
    CGFloat originX = self.selectedBgColorImageView.frame.origin.x + BothSidesInterval;
    
    //松手最大
    if (touchMoveX >= self.frame.size.width) {
        return _allLevel;
    }
    
    //松手最小
    if (touchMoveX <= 0) {
        return 1;
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

- (void)setvalueLineview {
    
    CGFloat sliderDistance = self.sliderImageView.center.x;
    
    self.selectedBgColorImageView.frame = CGRectMake(0, self.selectedBgColorImageView.frame.origin.y, sliderDistance, self.selectedBgColorImageView.frame.size.height);
    
    
    self.notSelectedBgColorImageView.frame = CGRectMake(sliderDistance, self.notSelectedBgColorImageView.frame.origin.y, self.frame.size.width - sliderDistance, self.notSelectedBgColorImageView.frame.size.height);
    
}

- (void)addPointImageView:(NSInteger)allLevels type:(YUSilderViewType)type {
    for (int i = 0; i < allLevels; i++) {
        UIImageView * pointImageView = [[UIImageView alloc] init];

        CGFloat pointSizeWidth = NonePointSizeWidth;
        if (type == YUSilderViewTypeLong) {
            pointSizeWidth = 1;
            pointImageView.backgroundColor = [UIColor clearColor];
        }
        else if (type == YUSilderViewTypeNone) {
            pointImageView.backgroundColor = [UIColor yellowColor];
        }
        //设置pointImageView的size
        pointImageView.frame = CGRectMake(0, 0, pointSizeWidth, pointSizeWidth);
        pointImageView.tag = 3000 + i;
        
        //添加到数组中
        [self.pointViewLists addObject:pointImageView];
        
        if (type == YUSilderViewTypeNone) {
            //在背景色上面
            [self insertSubview:pointImageView aboveSubview:self.notSelectedBgColorImageView];
        }
    }
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
