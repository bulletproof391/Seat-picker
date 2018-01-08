//
//  Networking.h
//  Seat picker
//
//  Created by Дмитрий Вашлаев on 05.01.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Networking : NSObject <NSURLSessionDelegate>

@property (nonatomic, strong) NSURL *URL;

- (instancetype)initWithURL:(NSString *)URLString;
- (void)downloadData:(void (^)(NSData *))completionBlock;

@end
