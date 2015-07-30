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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

#pragma mark - Configuration Methods

- (void)configureView {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"ETSlideTextView" owner:self options:nil] objectAtIndex:0]];
    
    // Text field
    [_inputTextView setTextColor:[ColorThemeController tableViewCellTextColor]];
    [_inputTextView configureWrapper];
    
    // Message Button
    [_removeViewButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_addViewButton setTitle:[NSString stringWithFormat:@"%@!", NSLocalizedString(@"Send", nil)] forState:UIControlStateNormal];
}

#pragma mark - Initialization Methods

- (id)initWithMasterView:(UIView *)masterView delegate:(id<ETSlideTextViewDelegate>)delegate {
    return [self initWithMasterView:masterView delegate:delegate validatingEmptyText:NO withPlaceholderAppendix:nil];
}

- (id)initWithMasterView:(UIView *)masterView delegate:(id<ETSlideTextViewDelegate>)delegate validatingEmptyText:(BOOL)emptyText withPlaceholderAppendix:(NSString *)placeholderAppendix {

    self = [self initWithFrame:CGRectZero];
    self.autoresizingMask = _addView.autoresizingMask;
    
    self.delegate = delegate;
    
    self.validateEmptyView = emptyText;
    
    // Change placeholder
    if (placeholderAppendix) {
        [_inputTextView setPlaceholder:[NSString stringWithFormat:@"%@ %@?", NSLocalizedString(@"What's your", nil), placeholderAppendix]];
        [_addViewButton setTitle:[NSString stringWithFormat:@"%@ %@!", NSLocalizedString(@"Send", nil), placeholderAppendix] forState:UIControlStateNormal];
    }
    
    // Add the frame
    [self setFrame:CGRectMake(_addView.frame.origin.x, -(_addView.frame.size.height), _addView.frame.size.width, _addView.frame.size.height)];
    
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
    
    // Send confirmation action
    if ([_delegate respondsToSelector:@selector(slideTextView:confirmedText:)]) {
        [_delegate slideTextView:self confirmedText:_inputTextView.text];
    }
    
    // Remove view
    [self hide];
}

@end
