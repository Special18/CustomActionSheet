//
//  MRActionSheet.m
//  Wave
//
//  Created by MrXir on 2017/6/16.
//  Copyright © 2017年 LJS. All rights reserved.
//

#import "MRActionSheet.h"

#define BUTTON_H 50.0f

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define DEFAULT_TITLE_FONT  [UIFont systemFontOfSize:17.0f]

#define DEFAULT_ANIMATION_DURATION 0.2f

#define DEFAULT_BACKGROUND_OPACITY 0.3f

@interface MRActionSheet ()

@property (nonatomic, strong) NSMutableArray *buttonTitles;//所有按钮

@property (nonatomic, strong) UIView *maskView;//灰色部分的VIEW

@property (nonatomic, strong) UIView *bottomView;//所有按钮底部的VIEW

@property (nonatomic, weak) id<MRActionSheetDelegate> delegate;//代理

@property (nonatomic, strong) UIWindow *backWindow;

@end

@implementation MRActionSheet

#pragma mark - getter

- (NSString *)cancelTitle {
    if (!_cancelTitle) {
        _cancelTitle = @"取消";
    }
    return _cancelTitle;
}

- (UIFont *)textFont {
    if (!_textFont) {
        _textFont = DEFAULT_TITLE_FONT;
    }
    return _textFont;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }
    return _textColor;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = DEFAULT_ANIMATION_DURATION;
    }
    return _animationDuration;
}

- (CGFloat)backgroundOpacity {
    if (!_backgroundOpacity) {
        _backgroundOpacity = DEFAULT_BACKGROUND_OPACITY;
    }
    return _backgroundOpacity;
}

- (UIWindow *)backWindow {
    if (_backWindow == nil) {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel = UIWindowLevelStatusBar;
        _backWindow.backgroundColor = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    return _backWindow;
}

#pragma mark - Methods

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles specialButtonIndex:(NSInteger)specialButtonIndex delegate:(id<MRActionSheetDelegate>)delegate {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles specialButtonIndex:specialButtonIndex delegate:delegate];
}

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles specialButtonIndex:(NSInteger)specialButtonIndex clicked:(MRActionSheetBlock)clicked {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles specialButtonIndex:specialButtonIndex clicked:clicked];
}

- (instancetype)initWithTitle:(NSString *)title
                buttonTitles:(NSArray *)buttonTitles
                specialButtonIndex:(NSInteger)specialButtonIndex
                delegate:(id<MRActionSheetDelegate>)delegate {
    
    if (self = [super init]) {
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.specialButtonIndex = specialButtonIndex;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                buttonTitles:(NSArray *)buttonTitles
                specialButtonIndex:(NSInteger)specialButtonIndex
                clicked:(MRActionSheetBlock)clicked {
    
    if (self = [super init]) {
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.specialButtonIndex = specialButtonIndex;
        self.clickBlock = clicked;
    }
    return self;
}

- (void)configMainView {
    
    //maskView
    UIView *maskView = [[UIView alloc] init];
    maskView.alpha = 0;
    maskView.userInteractionEnabled = NO;
    maskView.frame = (CGRect){0, 0, SCREEN_SIZE};
    maskView.backgroundColor = [UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1];
    [self addSubview:maskView];
    _maskView = maskView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [maskView addGestureRecognizer:tap];
    
    //所有按钮底部的View
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    _bottomView = bottomView;
    
    if (self.title) {
        
        CGFloat vSpace = 0;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
        if (titleSize.width > SCREEN_SIZE.width - 30) {
            vSpace = 15;
        }
        
        UIView *titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor whiteColor];
        titleBgView.frame = CGRectMake(0, -vSpace, SCREEN_SIZE.width, BUTTON_H + vSpace);
        [bottomView addSubview:titleBgView];
        
        //标题
        UILabel *label = [[UILabel alloc] init];
        label.text = self.title;
        label.numberOfLines = 2;
        label.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor whiteColor];
        label.frame = CGRectMake(15, 0, SCREEN_SIZE.width - 30, titleBgView.frame.size.height);
        [titleBgView addSubview:label];
    }
    
    if (self.buttonTitles.count) {
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            //所有按钮
            UIButton *actionBtn = [[UIButton alloc] init];
            actionBtn.tag = i;
            actionBtn.backgroundColor = [UIColor whiteColor];
            [actionBtn setTitle:self.buttonTitles[i] forState:0];
            actionBtn.titleLabel.font = self.textFont;
            
            UIColor *titleColor = nil;
            if (i == self.specialButtonIndex) {
                titleColor = [UIColor colorWithRed:0.86 green:0.11 blue:0.11 alpha:1];
            }else {
                titleColor = self.textColor;
            }
            [actionBtn setTitleColor:titleColor forState:0];
            [actionBtn setBackgroundImage:[UIImage imageNamed:@"ActionSheet_HL@2x.png"] forState:UIControlStateHighlighted];
            [actionBtn addTarget:self action:@selector(didClickActionBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat actionBtnY = BUTTON_H * (i + (self.title ? 1 : 0));
            actionBtn.frame = CGRectMake(0, actionBtnY, SCREEN_SIZE.width, BUTTON_H);
            [bottomView addSubview:actionBtn];
        }
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            //所有线条
            UIImageView *line = [[UIImageView alloc] init];
            line.image = [UIImage imageNamed:@"ActionSheet_line@2x.png"];
            line.contentMode = UIViewContentModeTop;
            CGFloat lineY = BUTTON_H * (i + (self.title ? 1 : 0));
            line.frame = CGRectMake(0, lineY, SCREEN_SIZE.width, 0.5);
            [bottomView addSubview:line];
        }
    }
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = self.buttonTitles.count;
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = self.textFont;
    [cancelButton setTitle:self.cancelTitle forState:0];
    [cancelButton setTitleColor:[UIColor blackColor] forState:0];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"ActionSheet_HL@2x.png"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat cancelBtnY = BUTTON_H * (self.buttonTitles.count + (self.title ? 1 : 0)) + 5;
    cancelButton.frame = CGRectMake(0, cancelBtnY, SCREEN_SIZE.width, BUTTON_H);
    [bottomView addSubview:cancelButton];
    
    CGFloat bottomH = (self.title ? BUTTON_H : 0) + BUTTON_H * self.buttonTitles.count + BUTTON_H + 5;
    bottomView.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH);
    
    self.frame = (CGRect){0, 0, SCREEN_SIZE};
    
}

- (void)didClickActionBtn:(UIButton *)sender {
    
    [self dismiss:nil];
    
    SEL selector = @selector(actionSheet:didClickButtonAtIndex:);
    
    if ([_delegate respondsToSelector:selector]) {
        
        [_delegate actionSheet:self didClickButtonAtIndex:sender.tag];
    }
    
    if (self.clickBlock) {
        
        self.clickBlock(sender.tag);
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _maskView.alpha = 0;
        _maskView.userInteractionEnabled = NO;
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        _bottomView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (void)didClickCancelBtn:(UIButton *)sender {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        _maskView.alpha = 0;
        _maskView.userInteractionEnabled = NO;
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        _bottomView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        SEL selector = @selector(actionSheet:didClickButtonAtIndex:);
        
        if ([_delegate respondsToSelector:selector]) {
            
            [_delegate actionSheet:self didClickButtonAtIndex:self.buttonTitles.count];
        }
        
        if (self.clickBlock) {
            
            __weak typeof(self) weakSelf = self;
            self.clickBlock(weakSelf.buttonTitles.count);
        }
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
    
}

- (void)show {
    
    [self configMainView];
    self.backWindow.hidden = NO;
    
    [self addSubview:self.bottomView];
    [self.backWindow addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
        _maskView.alpha = self.backgroundOpacity;
        _maskView.userInteractionEnabled = YES;
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        _bottomView.frame = frame;
        
    } completion:NULL];
}

- (void)addButtonTitle:(NSString *)button {
    
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    
    [_buttonTitles addObject:button];
}

@end

