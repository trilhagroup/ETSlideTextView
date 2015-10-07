//
//  ETSlideTextView.h
//  InEvent
//
//  Created by Pedro Góes on 7/29/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@class ETSlideTextView;

@protocol ETSlideTextViewDelegate <NSObject>

@optional
- (void)slideTextView:(ETSlideTextView *)slideTextView confirmedText:(NSString *)text;
- (void)slideTextViewConfirmedText:(ETSlideTextView *)slideTextView;
- (void)slideTextViewWillAppear:(ETSlideTextView *)slideTextView;
- (void)slideTextViewDidAppear:(ETSlideTextView *)slideTextView;
- (void)slideTextViewWillDisappear:(ETSlideTextView *)slideTextView;
- (void)slideTextViewDidDisappear:(ETSlideTextView *)slideTextView;

@end

@interface ETSlideTextView : UIView

@property (strong, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *inputTextView;
@property (strong, nonatomic) IBOutlet UIView *addButtonsView;
@property (strong, nonatomic) IBOutlet UIButton *removeViewButton;
@property (strong, nonatomic) IBOutlet UIButton *addViewButton;

@property (assign, nonatomic) BOOL *validateEmptyView;
@property (strong, nonatomic) id<ETSlideTextViewDelegate> delegate;

- (id)initWithMasterView:(UIView *)masterView delegate:(id<ETSlideTextViewDelegate>)delegate;
- (id)initWithMasterView:(UIView *)masterView withCustomView:(UIView*)customView delegate:(id<ETSlideTextViewDelegate>)delegate;
- (id)initWithMasterView:(UIView *)masterView delegate:(id<ETSlideTextViewDelegate>)delegate validatingEmptyText:(BOOL)emptyText withConfirmationTitle:(NSString *)confirmationTitle;
- (id)initWithMasterView:(UIView *)masterView withCustomView:(UIView*)customView delegate:(id<ETSlideTextViewDelegate>)delegate validatingEmptyText:(BOOL)emptyText withConfirmationTitle:(NSString *)confirmationTitle;


- (void)show;
- (void)hide;

@end
