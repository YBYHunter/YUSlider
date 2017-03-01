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
 * method
 * parameter 一共分为多少个等级 必传参数
 * parameter 初始等级 必传参数 等级1开始
 */
- (void)setupSilderViewWithAllLevels:(NSInteger)allLevels initialLevel:(NSInteger)initialLevel;


- (void)movePointImageView:(NSInteger)leve animation:(BOOL)animation;







@end
