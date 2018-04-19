//
//  Student.h
//  FMDBDemo
//
//  Created by Fan's iMac  on 2018/4/19.
//  Copyright © 2018年 Fan's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic,assign) NSInteger stuID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,strong) NSString *desc;


@end
