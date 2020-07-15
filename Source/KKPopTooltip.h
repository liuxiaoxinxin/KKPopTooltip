//
//  KKPopTooltip.h
//  KKPopTooltip
//
//  Created by 刘继新 on 2017/7/21.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>

/// 箭头位置方向
typedef NS_ENUM(NSInteger, TooltipArrowPosition) {
    TooltipArrowPositionTop,
    TooltipArrowPositionBottom
};

@interface KKPopTooltip : UIView

/// 箭头指向UIBarButtonItem
+ (KKPopTooltip *)showAtBarButtonItem:(UIBarButtonItem *)barButtonItem message:(NSString *)message arrowPosition:(TooltipArrowPosition)position;
+ (KKPopTooltip *)showAtBarButtonItem:(UIBarButtonItem *)barButtonItem contentView:(UIView *)contentView arrowPosition:(TooltipArrowPosition)position;
/// 箭头指向UIView
+ (KKPopTooltip *)showPointingAtView:(UIView *)targetView inView:(UIView *)containerView message:(NSString *)message arrowPosition:(TooltipArrowPosition)position;
+ (KKPopTooltip *)showPointingAtView:(UIView *)targetView inView:(UIView *)containerView contentView:(UIView *)contentView arrowPosition:(TooltipArrowPosition)position;
/// 箭头指向CGPoint
+ (KKPopTooltip *)showPointing:(CGPoint)point inView:(UIView *)containerView message:(NSString *)message arrowPosition:(TooltipArrowPosition)position;
+ (KKPopTooltip *)showPointing:(CGPoint)point inView:(UIView *)containerView contentView:(UIView *)contentView arrowPosition:(TooltipArrowPosition)position;

- (instancetype)initWithFrame:(CGRect)frame position:(TooltipArrowPosition)positin;

@property (nonatomic, readonly, assign) TooltipArrowPosition arrowPosition;
@property (nonatomic, readonly) UIView *contentView;

- (void)showInView:(UIView *)view animation:(BOOL)animation;
- (void)dismissAnimation:(BOOL)animation;

@end
