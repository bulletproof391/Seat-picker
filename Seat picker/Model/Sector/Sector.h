//
//  Sector.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 07.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Legend.h"
#import "Seat.h"

@interface Sector : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *caption;
@property NSInteger rowsCount;
@property NSInteger columnsCount;
@property NSInteger ticketsCount;

@property (strong, nonatomic) NSMutableArray<Legend *> *legend;
@property (strong, nonatomic) NSMutableArray<Seat *> *seats;

- (instancetype)init;
@end
