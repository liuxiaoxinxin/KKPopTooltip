
//
//  KKPopTooltip.m
//  KKPopTooltip
//
//  Created by 刘继新 on 2017/7/21.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import "KKPopTooltip.h"

#define KK_SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define KK_SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

static CGFloat const attached = 16.0f; /// 箭头大小
static CGFloat const radius = 10.0f;   /// 圆角半径
static CGFloat const margin = 2.0f;    /// 内部边界
static CGFloat const contentBorder = 12.0f; /// 文字到边框的距离

typedef void((^DrawCompletion)(void));

@interface KKPopTooltip()
@property (nonatomic, readwrite, assign) TooltipArrowPosition arrowPosition;
@property (nonatomic, copy) DrawCompletion drawCompletion;
@property (nonatomic, assign) CGPoint arrowPoint;
@property (nonatomic, readwrite, strong) UIView *contentView;
@end

@implementation KKPopTooltip

- (instancetype)initWithFrame:(CGRect)frame position:(TooltipArrowPosition)positin {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = CGSizeMake(200, 66);
    }
    self = [super initWithFrame:frame];
    if (self) {
        _arrowPosition = positin;
        [self configurationViews];
    }
    return self;
}

- (void)configurationViews {
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)]];
            
    switch (self.arrowPosition) {
        case TooltipArrowPositionTop:
            self.layer.shadowOffset = CGSizeMake(0, 0);
            break;
        case TooltipArrowPositionBottom:
            self.layer.shadowOffset = CGSizeMake(0, 4);
            break;
        default: break;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 0);
    CGFloat arrowX = [self calArrowX];
    switch (self.arrowPosition) {
        case TooltipArrowPositionTop:
            [self drawTopAttachedWithContext:ctx arrow:arrowX];
            break;
            case TooltipArrowPositionBottom:
            [self drawBottomAttachedWithContext:ctx arrow:arrowX];
            break;
        default: break;
    }
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    if (self.drawCompletion) {
        self.drawCompletion();
    }
}

- (CGFloat)width {
  return CGRectGetWidth([self frame]);
}

- (CGFloat)height {
  return CGRectGetHeight([self frame]);
}

// up.
- (void)drawTopAttachedWithContext:(CGContextRef )ctx arrow:(CGFloat)arrowX {
    // 开始 坐标右边开始
    CGContextMoveToPoint(ctx, self.width - margin, self.height - 20);
    // 右下角角度
    CGContextAddArcToPoint(ctx, self.width - margin, self.height - margin, self.width - 20, self.height - margin, radius);
    // 左下角角度
    CGContextAddArcToPoint(ctx, 0 + margin, self.height - margin, 0 + margin, self.height - 20, radius);
    // 左上角
    CGContextAddArcToPoint(ctx, 0 + margin, attached, self.width - 20, attached, radius);
    // 箭头开始
    if (arrowX - (attached * 3 / 2) / 2.0 < (radius + margin)) {
         CGContextAddLineToPoint(ctx, arrowX - (attached * 3 / 2) / 2.0, attached);
    }
    CGContextAddArcToPoint(ctx, arrowX - (attached * 3 / 2) / 2.0, attached, arrowX, 0.0, radius / 2.0);
    // 箭头顶点
    CGContextAddArcToPoint(ctx, arrowX, 0 + margin, arrowX + (attached * 3 / 2) / 2.0, attached, radius / 2.0);
    // 箭头结束
    CGContextAddArcToPoint(ctx, arrowX + (attached * 3 / 2) / 2.0, attached, arrowX + (attached * 3 / 2) / 2.0 + 20, attached, radius / 2.0);
    // 右上角
    CGContextAddArcToPoint(ctx, self.width - margin, attached, self.width - margin, attached + 20.0, radius);
}

// down.
- (void)drawBottomAttachedWithContext:(CGContextRef )ctx arrow:(CGFloat)arrowX {
    CGContextMoveToPoint(ctx, self.width - margin, self.height - 20);  // 开始坐标右边开始
    CGContextAddArcToPoint(ctx, self.width - margin, self.height - margin - attached, self.width - 20, self.height - margin - attached , radius);
    CGContextAddArcToPoint(ctx,
                           arrowX + attached * 3 / 4.0, self.height - margin - attached,
                           arrowX, self.height - margin,
                           radius / 2.0);
    CGContextAddArcToPoint(ctx,
                           arrowX, self.height - margin,
                           arrowX - (attached * 3 / 2) / 2.0, self.height - margin - attached,
                           radius / 2.0);
    CGContextAddArcToPoint(ctx,
                           arrowX - (attached * 3 / 2) / 2.0, self.height - margin - attached,
                           arrowX - (attached * 3 / 2) / 2.0 - 20, self.height - margin - attached,
                           radius / 2.0);
    CGContextAddArcToPoint(ctx, 0 + margin, self.height - margin - attached, 0 + margin, self.height - 20 - attached, radius);
    CGContextAddArcToPoint(ctx, 0 + margin, margin, self.width - 20, margin, radius);
    CGContextAddArcToPoint(ctx, self.width - margin, margin, self.width - margin, margin + 20.0, radius);
}

/// 计算箭头指向位置
- (CGFloat)calArrowX {
    CGFloat arrowX = self.arrowPoint.x;
    if (self.arrowPoint.x == 0) {
        arrowX = self.width/2;
    }
    if ((arrowX - attached * 3/2/2.0) < radius) {
        arrowX = radius + attached * 3/2/2.0;
    }
    if ((arrowX + attached * 3/2/2.0) > self.width - margin - radius) {
        arrowX = self.width - margin - radius - attached * 3/2/2.0;
    }
    return arrowX;
}

- (void)showInView:(UIView *)view animation:(BOOL)animation {
    self.alpha = 0;
    [view addSubview:self];
    __weak KKPopTooltip *weakSelf = self;
    self.drawCompletion = ^{
        [weakSelf startAnimation:YES];
    };
}

- (void)removeView {
    [self dismissAnimation:YES];
}

- (void)dismissAnimation:(BOOL)animation {
    [self startAnimation:NO];
    POPSpringAnimation *scaleAimation = [self.layer pop_animationForKey:@"scaleAnimation"];
    scaleAimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    };
}

- (void)startAnimation:(BOOL)flag {
    CGRect frame = self.frame;
    NSValue *sale1 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *sale2 = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = flag ? 5 : 0;
    scaleAnimation.fromValue = flag ? sale1 : sale2;
    scaleAnimation.toValue = flag ? sale2 : sale1;
    
    NSNumber *position1 = nil;
    NSNumber *position2 = nil;
    if (self.arrowPosition == TooltipArrowPositionTop) {
        position1 = [NSNumber numberWithFloat:frame.origin.y];
        position2 = [NSNumber numberWithFloat:frame.origin.y + frame.size.height/2.0];
    } else {
        position1 = [NSNumber numberWithFloat:frame.origin.y + frame.size.height];
        position2 = [NSNumber numberWithFloat:frame.origin.y + frame.size.height/2.0];
    }
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.springBounciness = 5;
    positionAnimation.fromValue = flag ? position1 : position2;
    positionAnimation.toValue = flag ? position2 : position1;
    
    CGFloat arrowX = [self calArrowX];
    POPSpringAnimation *positionXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionXAnimation.springBounciness = 5;
    positionXAnimation.fromValue = [NSNumber numberWithFloat:flag ?  frame.origin.x + arrowX : frame.origin.x + frame.size.width/2.0];
    positionXAnimation.toValue = [NSNumber numberWithFloat:flag ? frame.origin.x + frame.size.width/2.0 : frame.origin.x + arrowX];;
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.duration = flag ? 0.0 : 0.35;
    alphaAnimation.toValue = [NSNumber numberWithFloat:flag ? 1 : 0];
    
    [self pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [self.layer pop_addAnimation:positionXAnimation forKey:@"positionXAnimation"];
}

#pragma mark - Class Method

+ (KKPopTooltip *)showAtBarButtonItem:(UIBarButtonItem *)barButtonItem message:(NSString *)message arrowPosition:(TooltipArrowPosition)position {
    if (![barButtonItem isKindOfClass:[UIBarButtonItem class]]) {return nil; }
    UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
    UIView *containerView = [UIApplication sharedApplication].keyWindow;
    return [self showPointingAtView:targetView inView:containerView message:message arrowPosition:position];
}

+ (KKPopTooltip *)showAtBarButtonItem:(UIBarButtonItem *)barButtonItem contentView:(UIView *)contentView arrowPosition:(TooltipArrowPosition)position {
    if (![barButtonItem isKindOfClass:[UIBarButtonItem class]]) {return nil; }
    UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
    UIView *containerView = [UIApplication sharedApplication].keyWindow;
    return [self showPointingAtView:targetView inView:containerView contentView:contentView arrowPosition:position];
}

+ (KKPopTooltip *)showPointingAtView:(UIView *)targetView inView:(UIView *)containerView message:(NSString *)message arrowPosition:(TooltipArrowPosition)position {
    CGRect rect = [containerView convertRect:targetView.frame fromView:targetView.superview];
    CGPoint point = CGPointZero;
    if (position == TooltipArrowPositionTop) {
        point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height);
    } else if (position == TooltipArrowPositionBottom) {
        point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y);
    }
    return [self showPointing:point inView:containerView message:message arrowPosition:position];
}

+ (KKPopTooltip *)showPointingAtView:(UIView *)targetView inView:(UIView *)containerView contentView:(UIView *)contentView arrowPosition:(TooltipArrowPosition)position {
    CGRect rect = [containerView convertRect:targetView.frame fromView:targetView.superview];
    CGPoint point = CGPointZero;
    if (position == TooltipArrowPositionTop) {
        point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height);
    } else if (position == TooltipArrowPositionBottom) {
        point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y);
    }
    return [self showPointing:point inView:containerView contentView:contentView border:0 arrowPosition:position];
}

+ (KKPopTooltip *)showPointing:(CGPoint)point inView:(UIView *)containerView message:(NSString *)message arrowPosition:(TooltipArrowPosition)position {
    CGSize textSize = [message boundingRectWithSize:CGSizeMake(KK_SCREEN_WIDTH - 30 ,MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}
                                            context:nil].size;
    UILabel *textLabel = [[UILabel alloc] init];
    CGRect frame = {0, 0, textSize.width, textSize.height};
    textLabel.frame = frame;
    textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    textLabel.font = [UIFont boldSystemFontOfSize:16];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 0;
    textLabel.text = message;
    return [self showPointing:point inView:containerView contentView:textLabel arrowPosition:position];
}

+ (KKPopTooltip *)showPointing:(CGPoint)point
       inView:(UIView *)containerView
  contentView:(UIView *)contentView
                 arrowPosition:(TooltipArrowPosition)position {
    return [self showPointing:point inView:containerView contentView:contentView border:contentBorder arrowPosition:position];
}

+ (KKPopTooltip *)showPointing:(CGPoint)point
                        inView:(UIView *)containerView
                   contentView:(UIView *)contentView
                        border:(CGFloat)border
                 arrowPosition:(TooltipArrowPosition)position {
    CGSize contentSize = contentView.frame.size;
    CGRect contentRect = contentView.frame;
    contentRect.origin.x = border + margin;
    CGSize tooltipSize = CGSizeMake(contentSize.width + (border + margin) * 2, contentSize.height + (border + margin) * 2 + attached);
    CGRect rect = CGRectZero;
    CGFloat x = point.x - tooltipSize.width/2;
    if (x < 10) {
        x = 10;
    } else if ((tooltipSize.width + x) > KK_SCREEN_WIDTH - 10) {
        x = KK_SCREEN_WIDTH - 10 - tooltipSize.width;
    }
    if (position == TooltipArrowPositionTop) {
        contentRect.origin.y = border + margin + attached;
        rect = CGRectMake(x, point.y, tooltipSize.width, tooltipSize.height);
    } else if (position == TooltipArrowPositionBottom) {
        contentRect.origin.y = border + margin;
        rect = CGRectMake(x, point.y - tooltipSize.height, tooltipSize.width, tooltipSize.height);
    }
    contentView.frame = contentRect;
    KKPopTooltip *tooltip = [[KKPopTooltip alloc]initWithFrame:rect position:position];
    CGPoint arrowPoint = [containerView convertPoint:point toView:tooltip];
    tooltip.arrowPoint = arrowPoint;
    [tooltip addSubview:contentView];
    tooltip.contentView = contentView;
    [tooltip showInView:containerView animation:YES];
    return tooltip;
}

@end
