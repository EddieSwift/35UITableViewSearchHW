//
//  EGBStudent.h
//  35UITableViewSearchHW
//
//  Created by Eduard Galchenko on 2/11/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGBStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *dateOfBirth;

+ (EGBStudent* ) randomStudent;

@end

NS_ASSUME_NONNULL_END
