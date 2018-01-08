//
//  Seat.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 07.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Seat : NSObject

@property (strong, nonatomic) NSString *identifier;
@property NSInteger row;
@property NSInteger column;
@property NSInteger rowInSector;
@property NSInteger columnInSector;
@property BOOL enabled;
@property (strong, nonatomic) UIColor *color;
@property NSInteger price;
@property BOOL isAvailable;

@end
