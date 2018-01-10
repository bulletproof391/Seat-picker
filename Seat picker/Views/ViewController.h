//
//  ViewController.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"

static const double legendLabelColorAspectSize = 30.0;
static const double legendTextLabelWidth = 70.0;
static const double legendTextLabelHeight = 21.0;
static const double buttonAspectSize = 15.0;
static const double buttonDelimiter = 5.0;

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) ViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;

@end

