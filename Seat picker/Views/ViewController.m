//
//  ViewController.m
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import "ViewController.h"
#import <libextobjc/EXTScope.h>

@interface ViewController ()
@property (strong, nonatomic) UIColor *selectedSeatColor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.totalAmount.text = @"";
    self.selectedSeatColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    
    [self scrollViewInitalSetup];
    [self bindViewModel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel {
    @weakify(self);
    [[RACObserve(self.viewModel, hasUpdatedContent) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self addButtonsToContentView];
    }];
}


#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}


#pragma mark - Scaling
- (void)scrollViewInitalSetup {
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.delegate = self;
}

- (void)setViewsWidth:(NSInteger)width height:(NSInteger)height {
    CGRect newFrame = self.contentView.frame;
    
    newFrame.size.width = width;
    newFrame.size.height = height;
    
    self.scrollView.contentSize = CGSizeMake(width, height);
//    [self.scrollView setFrame:newFrame];
    [self.contentView setFrame:newFrame];
}


#pragma mark - Buttons
- (void)addButtonsToContentView {
    NSInteger rowsCount = [self.viewModel rowsCount];
    NSInteger columnsCount = [self.viewModel columnsCount];
    NSInteger currentCellIndex = 0;
    
    if (rowsCount == 0 || columnsCount == 0)
        return;
    
    NSInteger width = columnsCount * buttonAspectSize + columnsCount * buttonDelimiter + buttonDelimiter;
    NSInteger height = rowsCount * buttonAspectSize + rowsCount * buttonDelimiter + buttonDelimiter;
    [self setViewsWidth:width height:height];
    
    
    for (int i = 0; i < rowsCount; i++) {
        for (int j = 0; j < columnsCount; j++, currentCellIndex++) {
            UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            newButton.bounds = CGRectMake(0, 0, buttonAspectSize, buttonAspectSize);
            newButton.center = CGPointMake(buttonAspectSize / 2 + buttonDelimiter + (buttonAspectSize + buttonDelimiter) * j,
                                           buttonAspectSize / 2 + buttonDelimiter + (buttonAspectSize + buttonDelimiter) * i);

            [newButton setTag:currentCellIndex];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonTapGestureHandler:)];
            
            if ([self.viewModel isEnabled:currentCellIndex]) {
                [newButton setEnabled:YES];
                [newButton setBackgroundColor:[self.viewModel getBackgroundColor:currentCellIndex]];
                [newButton addGestureRecognizer:tapGesture];
            } else {
                [newButton setEnabled:NO];
            }
            
            [self.contentView addSubview:newButton];
        }
    }
}

- (void)buttonTapGestureHandler:(UIGestureRecognizer *)gestureRecognizer {
    UIButton *tappedButton = (UIButton *)gestureRecognizer.view;
    NSInteger buttonTag = tappedButton.tag;
    UIColor *seatColor = [self.viewModel getBackgroundColor:buttonTag];
    
    if ([self.viewModel availableSeat:buttonTag]) {
        if ([tappedButton.backgroundColor isEqual:self.selectedSeatColor]) {
            [tappedButton setBackgroundColor:seatColor];
        } else {
            [tappedButton setBackgroundColor:self.selectedSeatColor];
        }
    }
    
    NSLog(@"%li", tappedButton.tag);
}
@end
