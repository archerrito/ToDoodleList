//
//  BNRPersonAppDelegate.m
//  ToDoodleList
//
//  Created by Archer on 5/13/14.
//  Copyright (c) 2014 Oodalalee. All rights reserved.
//

#import "BNRPersonAppDelegate.h"

//Helper function to fetch the path to our to-do data stored in disk
NSString *BNRDocPath()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    return [pathList[0] stringByAppendingPathComponent:@"data.td"];
}

@implementation BNRPersonAppDelegate

#pragma mark - Application delegate callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Create an empty array to get us started
    //self.tasks = [NSMutableArray array];
    
    //Load an existing dataset or create a new one
    NSArray *plist = [NSArray arrayWithContentsOfFile:BNRDocPath()];
    if (plist) {
        //We have a dataset; copy it into tasks
        self.tasks = [plist mutableCopy];
    } else {
        //there is no dataset; create an empty array
        self.tasks = [NSMutableArray array];
    }
    
    //Create and configure the UIWindow instance
    //A CGRect is a struct with an origin (x,y) and a size (width, height)
    CGRect winFrame = [[UIScreen mainScreen] bounds];
    UIWindow *theWindow = [[UIWindow alloc] initWithFrame:winFrame];
    self.window = theWindow;
    
    //Define the frame rectangles of the three UIelements
    //CGRectMake() create a CGRect from (x, y, width, height)
    CGRect tableFrame = CGRectMake(0,80, winFrame.size.width, winFrame.size.height -100);
    
    CGRect fieldFrame = CGRectMake(20, 40, 200, 31);
    CGRect buttonFrame = CGRectMake(228, 40, 72, 31);
    
    //Create and configure the UITableView instance
    self.taskTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Make the BNRPersonAppDelegate the table views datasource
    self.taskTable.dataSource = self;
    
    //Tell the table view which class to instantiate whenever it
    //needs to create a new cell
    [self.taskTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //Create and configure the UITextField instance where new tasks will be entered
    self.taskField = [[UITextField alloc] initWithFrame:fieldFrame];
    self.taskField.borderStyle = UITextBorderStyleRoundedRect;
    self.taskField.placeholder = @"Type a task, tap insert";
    
    //Create and configure the UIButton Instance
    self.insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.insertButton.frame = buttonFrame;
    
    //give the button a title
    [self.insertButton setTitle:@"Insert" forState:UIControlStateNormal];
    
    //Set the target and action for the insert button
    [self.insertButton addTarget:self action:@selector(addtask:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add our three UI elements to the window
    [self.window addSubview:self.taskTable];
    [self.window addSubview:self.taskField];
    [self.window addSubview:self.insertButton];
    
    //Finalize the window and putit on the screen
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Actions

- (void)addtask:(id)sender
{
    //Get the task
    NSString *text = [self.taskField text];
    
    //Quit here if taskfield is empty
    if ([text length] == 0) {
        return;
    }
    
    //Log text to console
    //NSLog(@"Task entered:%@", text);
    
    //Add it to the working array
    [self.tasks addObject:text];
    
    //refresh the table so that the new item shows up
    [self.taskTable reloadData];
    
    //Clear out the text field
    [self.taskField setText:@""];
    //dismiss the keyboard
    [self.taskField resignFirstResponder];
}

#pragma mark - Table view management

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    //Because this table view only has one section,
    //the number of rows in it is equal to the number
    //of items it the tasks array
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //To improve performance, this method first checks
    //for an existing cell object that we can reuse
    //If there isnt one, then a new cell is created
    UITableViewCell *c = [self.taskTable dequeueReusableCellWithIdentifier:@"Cell"];
    
    //then we (re)configure the cell based on the model object,
    //in this case the tasks array, ...
    NSString *item = [self.tasks objectAtIndex:indexPath.row];
    c.textLabel.text = item;
    
    //...and hand the properly configured cell back to the table view
    return c;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //Save our tasks array to disk
    [self.tasks writeToFile:BNRDocPath() atomically:YES];
}

@end
