//
//  YUSilderView.h
//  YUSlider
//
//  Created by 于博洋 on 2017/2/28.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YUSilderViewDelegate <NSObject>

- (void)selectSilderViewWithLeve:(NSInteger)leve;

@end

@interface YUSilderView : UIView


@property (nonatomic,weak) id<YUSilderViewDelegate> silderViewDelegate;

/**
 * method 初始化等级方法
 * parameter 一共分为多少个等级 必传参数
 * parameter 初始等级 必传参数 等级1开始
 */
- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels initialLevel:(NSInteger)initialLevel;


/**
 * method 移动滑块方法
 * leve 移动到第几级 1级开始
 * animation 是否显示动画效果
 */
- (void)movePointImageView:(NSInteger)leve animation:(BOOL)animation;





















@end
