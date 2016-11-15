//
//  TextView.m
//  GYChangeTextViewDemo
//
//  Created by lovechocolate on 2016/11/15.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "TextView.h"

@interface TextView()

@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerYFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;

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

@implementation TextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.firstLabel.userInteractionEnabled = YES;
    self.secondLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstTapAc:)];
    UITapGestureRecognizer *sendTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoTapAc:)];
    [_firstLabel addGestureRecognizer:firstTap];
    [_secondLabel addGestureRecognizer:sendTap];
//    self.clipsToBounds = YES;
}

- (void)setTextArr:(NSMutableArray *)textArr
{
    if (textArr.count < 2) {
        _secondLabel.hidden = YES;
        _centerYFirstLabel.constant = 0;
    }
    if (textArr.count > 0) {
        _firstLabel.text = [textArr objectAtIndex:0];
    }
    if (textArr.count > 1) {
        _secondLabel.hidden = NO;
        _centerYFirstLabel.constant = -10;
        _secondLabel.text = [textArr objectAtIndex:1];
    }
}

- (void)firstTapAc:(UITapGestureRecognizer *)sender
{
    if (self.didTouchLabel) {
        _didTouchLabel(0);
    }
}

- (void)twoTapAc:(UITapGestureRecognizer *)sender
{
    if (self.didTouchLabel) {
        _didTouchLabel(1);
    }
}


@end
