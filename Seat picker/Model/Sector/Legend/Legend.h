//
//  Legend.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 07.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Legend : NSObject

@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) UIColor *color;
@property NSInteger sort;
@property NSInteger price;

@end
