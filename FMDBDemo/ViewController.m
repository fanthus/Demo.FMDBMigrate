//
//  ViewController.m
//  FMDBDemo
//
//  Created by Fan's iMac  on 2018/4/19.
//  Copyright © 2018年 Fan's iMac. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <FMDB.h>
#import "Student.h"

@interface ViewController () {
    FMDatabaseQueue *queue;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *home = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [home stringByAppendingPathComponent:@"tmp.db"];
    queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"create table Student(stuID integer, name text,age integer, desc text);"];
    }];
    //
    NSMutableArray *btnArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor purpleColor]];
        [self.view addSubview:btn];
        [btnArr addObject:btn];
    }

    [(UIButton *)[btnArr objectAtIndex:0] setTitle:@"INSERT" forState:UIControlStateNormal];
    [(UIButton *)[btnArr objectAtIndex:0] addTarget:self action:@selector(insertStu:) forControlEvents:UIControlEventTouchUpInside];

    [(UIButton *)[btnArr objectAtIndex:1] setTitle:@"DELETE" forState:UIControlStateNormal];
    [(UIButton *)[btnArr objectAtIndex:1] addTarget:self action:@selector(deleteStu:) forControlEvents:UIControlEventTouchUpInside];

    [(UIButton *)[btnArr objectAtIndex:2] setTitle:@"UPDATE" forState:UIControlStateNormal];
    [(UIButton *)[btnArr objectAtIndex:2] addTarget:self action:@selector(updateStu:) forControlEvents:UIControlEventTouchUpInside];

    [(UIButton *)[btnArr objectAtIndex:3] setTitle:@"SELECT" forState:UIControlStateNormal];
    [(UIButton *)[btnArr objectAtIndex:3] addTarget:self action:@selector(selectStu:) forControlEvents:UIControlEventTouchUpInside];

    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.top.equalTo(@50);
    }];
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:30 tailSpacing:30];
}

- (void)insertStu:(id)sender {
    Student *student = [[Student alloc] init];
    student.name = @"fan";
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Student(stuID,name,age,desc) values(?,?,?,?);"];
        NSArray *values = @[@1,@"fanxiushan",@28,@"perfect"];
        NSError *error = nil;
        [db executeUpdate:insertSQL values:values error:&error];
        NSLog(@"insert error = %@",error);
    }];
}

- (void)deleteStu:(id)sender {
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *delSql = [NSString stringWithFormat:@"delete from Student;"];
        [db executeUpdate:delSql];
    }];
}

- (void)updateStu:(id)sender {
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *updateSQL = @"update Student set name = '2222' where stuID = 1;";
        NSError *error = nil;
        [db executeUpdate:updateSQL values:nil error:&error];
        NSLog(@"update error = %@",error);
    }];
}

- (void)selectStu:(id)sender {
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *selectSQL = @"select * from Student where stuID = 1;";
        NSError *error = nil;
        FMResultSet *resultSet = [db executeQuery:selectSQL values:nil error:&error];
        while ([resultSet next]) {
            NSDictionary * dict = [resultSet resultDictionary];
            NSLog(@"dict = %@",dict);
            break;
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
