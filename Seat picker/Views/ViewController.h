//
//  ViewController.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

static const double buttonAspectSize = 20.0;
static const double buttonDelimiter = 5.0;

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) ViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

