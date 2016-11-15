//
//  GYChangeTextView.m
//  GYShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYChangeTextView.h"
#import "TextView.h"

#define DEALY_WHEN_TITLE_IN_MIDDLE  2.0
#define DEALY_WHEN_TITLE_IN_BOTTOM  0.0

typedef NS_ENUM(NSUInteger, GYTitlePosition) {
    GYTitlePositionTop    = 1,
    GYTitlePositionMiddle = 2,
    GYTitlePositionBottom = 3
};

@interface GYChangeTextView ()

@property (strong, nonatomic) TextView *textView;
@property (nonatomic, strong) NSArray *contentsAry;
@property (nonatomic, assign) CGPoint topPosition;
@property (nonatomic, assign) CGPoint middlePosition;
@property (nonatomic, assign) CGPoint bottomPosition;
/*
 *1.控制延迟时间，当文字在中间时，延时时间长一些，如5秒，这样可以让用户浏览清楚内容；
 *2.当文字隐藏在底部的时候，不需要延迟，这样衔接才流畅；
 *3.通过上面的宏定义去更改需要的值
 */
@property (nonatomic, assign) CGFloat needDealy;
@property (nonatomic, assign) NSInteger currentIndex;  /*当前播放到那个标题了*/
@property (nonatomic, assign) BOOL shouldStop;         /*是否停止*/

@end

@implementation GYChangeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.topPosition    = CGPointMake(self.frame.size.width/2, -self.frame.size.height/2);
        self.middlePosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.bottomPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height/2*3);
        self.shouldStop = NO;

        NSArray *detailNib = [[NSBundle mainBundle] loadNibNamed:@"TextView" owner:self options:nil];
        self.textView = detailNib.lastObject;
        _textView.frame = self.bounds;
        [self addSubview:_textView];

        __weak typeof (self) weakSelf = self;
        _textView.didTouchLabel = ^(NSInteger index){
            [weakSelf touchesBegan:index];
        };
        self.clipsToBounds = YES;   /*保证文字不跑出视图*/
        self.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;    /*控制第一次显示时间*/
        self.currentIndex = 0;
    }
    return self;
}

- (void)animationWithTexts:(NSArray *)textAry {
    _contentsAry = textAry;
    _textView.textArr = [NSMutableArray arrayWithArray:textAry];
    if (textAry.count > 2) {
       [self startAnimation];
    }
}

- (void)startAnimation {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_needDealy * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if ([weakSelf currentTitlePosition] == GYTitlePositionMiddle) {
                weakSelf.textView.layer.position = weakSelf.topPosition;
            } else if ([weakSelf currentTitlePosition] == GYTitlePositionBottom) {
                weakSelf.textView.layer.position = weakSelf.middlePosition;
            }
        } completion:^(BOOL finished) {
            NSMutableArray *temArr = [[NSMutableArray alloc]init];
            NSInteger index = [weakSelf realCurrentIndex];
            if (index < weakSelf.contentsAry.count) {
                NSString *indexText = [weakSelf.contentsAry objectAtIndex:index];
                [temArr addObject:indexText];
            }

            if (index + 1 < weakSelf.contentsAry.count) {
                [temArr addObject:[weakSelf.contentsAry objectAtIndex:index + 1]];
            } else {
              [temArr addObject:[weakSelf.contentsAry objectAtIndex:0]];
            }
            _textView.textArr = temArr;
            if ([weakSelf currentTitlePosition] == GYTitlePositionTop) {
                weakSelf.textView.layer.position = weakSelf.bottomPosition;
                weakSelf.needDealy = DEALY_WHEN_TITLE_IN_BOTTOM;
                weakSelf.currentIndex ++;
            } else {
                weakSelf.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;
            }
            if (!weakSelf.shouldStop) {
                [weakSelf startAnimation];
            } else { //停止动画后，要设置label位置和label显示内容
                weakSelf.textView.layer.position  = weakSelf.bottomPosition;
            }
        }];
    });
}

- (void)touchesBegan:(NSInteger)realCurrentIndex
{
    realCurrentIndex = [self realCurrentIndex] + realCurrentIndex;
    if (realCurrentIndex >= _contentsAry.count) {
        realCurrentIndex = 0;
    }
    if ([self.delegate respondsToSelector:@selector(gyChangeTextView:didTapedAtIndex:)]) {
        [self.delegate gyChangeTextView:self didTapedAtIndex:realCurrentIndex];
    }
}

- (void)stopAnimation {
    self.shouldStop = YES;
}

- (NSInteger)realCurrentIndex {
    return self.currentIndex % [self.contentsAry count];
}

- (GYTitlePosition)currentTitlePosition {
    if (self.textView.layer.position.y == self.topPosition.y) {
        return GYTitlePositionTop;
    } else if (self.textView.layer.position.y == self.middlePosition.y) {
        return GYTitlePositionMiddle;
    }
    return GYTitlePositionBottom;
}

@end
