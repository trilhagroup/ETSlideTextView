//
//  ETSlideTextView.m
//  InEvent
//
//  Created by Pedro Góes on 7/29/15.
//  Copyright (c) 2015 Pedro G√≥es. All rights reserved.
//

#import "ETSlideTextView.h"
#import "UIView+Wrapper.h"
#import "ColorThemeController.h"

@implementation ETSlideTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        // Initialization code
        [self configureView];
    }
}

#pragma mark - Configuration Methods

- (void)configureView {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ETSlideTextView" owner:self options:nil] objectAtIndex:0]];
    
    // Text field
    [_inputTextView setTextColor:[ColorThemeController tableViewCellTextColor]];
    [_inputTextView configureWrapper];
    
    // Buttons view
    [_addButtonsView setBackgroundColor:_addView.backgroundColor];
    [_removeViewButton setTitle:NSLocalizedStringFromTable(@"Cancel", @"ETSlideTextView", nil) forState:UIControlStateNormal];
    [_addViewButton setTitle:[NSString stringWithFormat:@"%@!", NSLocalizedStringFromTable(@"Send", @"ETSlideTextView", nil)] forState:UIControlStateNormal];
}

#pragma mark - Initialization Methods

- (id)initWithMasterView:(UIView *)masterView delegate:(id<ETSlideTextViewDelegate>)delegate {
    return [self initWithMasterView:masterView withCustomView:nil delegate:delegate validatingEmptyText:NO withConfirmationTitle:nil];
}

- (id)initWithMasterView:(UIView *)masterView withCustomView:(UIView*)customView delegate:(id<ETSlideTextViewDelegate>)delegate {
    return [self initWithMasterView:masterView withCustomView:customView delegate:delegate validatingEmptyText:NO withConfirmationTitle:nil];
}


- (id)initWithMasterView:(UIView *)masterView delegate:(id<ETSlideTextViewDelegate>)delegate validatingEmptyText:(BOOL)emptyText withConfirmationTitle:(NSString *)confirmationTitle {
    return [self initWithMasterView:masterView withCustomView:nil delegate:delegate validatingEmptyText:emptyText withConfirmationTitle:confirmationTitle];
}

- (id)initWithMasterView:(UIView *)masterView withCustomView:(UIView*)customView delegate:(id<ETSlideTextViewDelegate>)delegate validatingEmptyText:(BOOL)emptyText withConfirmationTitle:(NSString *)confirmationTitle {

    self = [self initWithFrame:CGRectZero];
    
    if (customView) {
        // Replace view and assign as the default
        [self.inputTextView removeFromSuperview];
        self.inputTextView = nil;
        [self.addView addSubview:customView];
        self.addView.frame = CGRectMake(_addView.frame.origin.x, _addView.frame.origin.y, _addView.frame.size.width, customView.frame.size.height + _addButtonsView.frame.size.height);
        self.addButtonsView.frame = CGRectMake(_addButtonsView.frame.origin.x, _addView.frame.size.height - _addButtonsView.frame.size.height, _addButtonsView.frame.size.width, _addButtonsView.frame.size.height);
    }

    // Set and hide our view before animating
    self.addView.frame = CGRectMake(_addView.frame.origin.x, _addView.frame.origin.y, masterView.frame.size.width, _addView.frame.size.height);
    self.frame = CGRectMake(_addView.frame.origin.x, -(_addView.frame.size.height), masterView.frame.size.width, _addView.frame.size.height);
    
    // Change autoresizing mask
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.addView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // Assign delegates
    self.delegate = delegate;
    self.validateEmptyView = emptyText;
    
    // Change placeholder
    if (confirmationTitle) [_addViewButton setTitle:confirmationTitle forState:UIControlStateNormal];
    
    // Add to controller's view
    [masterView addSubview:self];
    
    return self;
}

#pragma mark - User Methods

- (void)show {
    
    if ([_delegate respondsToSelector:@selector(slideTextViewWillAppear:)]) {
        [_delegate slideTextViewWillAppear:self];
    }
    
    // Animate the transition
    [UIView animateWithDuration:0.7f animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL completion){
        if ([_delegate respondsToSelector:@selector(slideTextViewDidAppear:)]) {
            [_delegate slideTextViewDidAppear:self];
        }
    }];
}

- (void)hide {
    
    if ([_delegate respondsToSelector:@selector(slideTextViewWillDisappear:)]) {
        [_delegate slideTextViewWillDisappear:self];
    }
    
    // Resign the text field responders
    [_inputTextView resignFirstResponder];
    
    // Animate the transition
    [UIView animateWithDuration:0.7f animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, -(self.frame.size.height), self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL completion){
        [self removeFromSuperview];
        if ([_delegate respondsToSelector:@selector(slideTextViewDidDisappear:)]) {
            [_delegate slideTextViewDidDisappear:self];
        }
    }];
}

- (IBAction)cancelBox:(id)sender {
    [self hide];
}

- (IBAction)sendText:(id)sender {
    
    if (_validateEmptyView) {
        // Check if input is empty, return with true
        if ([[_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) return;
    }
    
    // See if our input is available
    if (_inputTextView != nil) {
        // Send confirmation action with text
        if ([_delegate respondsToSelector:@selector(slideTextView:confirmedText:)]) {
            [_delegate slideTextView:self confirmedText:_inputTextView.text];
        }
    } else {
        // Send confirmation action
        if ([_delegate respondsToSelector:@selector(slideTextViewConfirmedText:)]) {
            [_delegate slideTextViewConfirmedText:self];
        }
    }
    
    // Remove view
    [self hide];
}

@end
