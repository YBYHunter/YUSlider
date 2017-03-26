//
//  YUSilderView.h
//  YUSlider
//
//  Created by 于博洋 on 2017/2/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YUSilderViewDelegate <NSObject>

//只要值改变就会执行
- (void)silderViewValuesChangeWithMinleve:(NSInteger)minLeve silderView:(UIView *)silderView;

- (void)silderViewValuesChangeWithMaxleve:(NSInteger)maxLeve silderView:(UIView *)silderView;

@end

@interface YUSilderView : UIView


@property (nonatomic,weak) id<YUSilderViewDelegate> silderViewDelegate;

/**
 * isOpenClickSlide 是否开启点击滑动功能
 * 单个滑块默认开启
 * 2个滑块不可开启
 */
@property (nonatomic,assign) BOOL isOpenClickSlide;

/**
 * method 初始化等级方法
 * allLevels 一共分为多少个等级 必传参数
 * isShowPoint 是否显示刻度
 * initialLevel 初始等级 必传参数 等级1开始
 */
- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels isShowPoint:(BOOL)isShowPoint initialLevel:(NSInteger)initialLevel;



- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels isShowPoint:(BOOL)isShowPoint initialLevel:(NSInteger)initialLevel maxInitialLevel:(NSInteger)maxInitialLevel;























@end
