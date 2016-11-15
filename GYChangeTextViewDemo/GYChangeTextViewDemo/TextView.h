//
//  TextView.h
//  GYChangeTextViewDemo
//
//  Created by lovechocolate on 2016/11/15.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didTouch)(NSInteger index);

@interface TextView : UIView

@property (strong, nonatomic) didTouch        didTouchLabel;
@property (strong, nonatomic) NSMutableArray  *textArr;

@end
