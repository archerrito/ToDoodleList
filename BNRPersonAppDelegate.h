//
//  BNRPersonAppDelegate.h
//  ToDoodleList
//
//  Created by Archer on 5/13/14.
//  Copyright (c) 2014 Oodalalee. All rights reserved.
//

#import <UIKit/UIKit.h>

//Declare a helper function that you will use to get a path
//to the location on disk where you can save the to-do list
NSString *BNRDocPath(void);

@interface BNRPersonAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Pointers to objects that user will interact with
@property (nonatomic) UITableView *taskTable;
@property (nonatomic) UITextField *taskField;
@property (nonatomic) UIButton  *insertButton;

//Mutable array, will store tasks as strings
@property (nonatomic) NSMutableArray *tasks;

- (void)addtask:(id)sender;

@end
