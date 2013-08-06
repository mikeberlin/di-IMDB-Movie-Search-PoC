//
//  NetworkingViewController.h
//  NetworkingStuff
//
//  Created by Joel Angelone on 4/9/13.
//  Copyright (c) 2013 Draken Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSArray *movies;

- (IBAction)search:(id)sender;

@end