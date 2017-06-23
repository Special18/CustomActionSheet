//
//  MRActionSheet.h
//  Wave
//
//  Created by MrXir on 2017/6/16.
//  Copyright © 2017年 LJS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRActionSheet;

typedef void(^MRActionSheetBlock)(NSInteger selectedIndex);


@protocol MRActionSheetDelegate <NSObject>

@optional
/**
 *  点击了 buttonIndex 处的按钮
 */
- (void)actionSheet:(MRActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)selectedIndex;

@end

@interface MRActionSheet : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger specialButtonIndex;

@property (nonatomic, copy) MRActionSheetBlock clickBlock;

@property (nonatomic, copy) NSString *cancelTitle;

/**
 *  Default is 18
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  Default is Black
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  Default is 0.3 seconds
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 *  Default is 0.3f
 */
@property (nonatomic, assign) CGFloat backgroundOpacity;


#pragma mark - Methods Delegate
/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title              提示标题
 *  @param buttonTitles       所有按钮的标题
 *  @param specialButtonIndex 特殊按钮的 index
 *  @param delegate           代理
 *
 *  Tip: 如果没有特殊按钮, specialButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)buttonTitles
                specialButtonIndex:(NSInteger)specialButtonIndex
                      delegate:(id<MRActionSheetDelegate>)delegate;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title              提示标题
 *  @param buttonTitles       所有按钮的标题
 *  @param specialButtonIndex 特殊按钮的 index
 *  @param delegate           代理
 *
 *  Tip: 如果没有特殊按钮, specialButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)buttonTitles
            specialButtonIndex:(NSInteger)specialButtonIndex
                      delegate:(id<MRActionSheetDelegate>)delegate;


#pragma mark - Methods Block
/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title              提示标题
 *  @param buttonTitles       所有按钮的标题
 *  @param specialButtonIndex 特殊按钮的 index
 *  @param clicked            点击按钮的 block 回调
 *
 *  Tip: 如果没有特殊按钮, specialButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)buttonTitles
                specialButtonIndex:(NSInteger)specialButtonIndex
                       clicked:(MRActionSheetBlock)clicked;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title              提示标题
 *  @param buttonTitles       所有按钮的标题
 *  @param specialButtonIndex 特殊按钮的 index
 *  @param clicked            点击按钮的 block 回调
 *
 *  Tip: 如果没有特殊按钮, specialButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)buttonTitles
            specialButtonIndex:(NSInteger)specialButtonIndex
                       clicked:(MRActionSheetBlock)clicked;


#pragma mark - Methods Custom
/**
 *  根据不同条件展示某个按钮
 */
- (void)addButtonTitle:(NSString *)button;

#pragma mark - Show
/**
 *  显示 ActionSheet
 */
- (void)show;

@end
