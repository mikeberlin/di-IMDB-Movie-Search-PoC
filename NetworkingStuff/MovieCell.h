//
//  MovieCell.h
//  NetworkingStuff
//
//  Created by Joel Angelone on 4/10/13.
//  Copyright (c) 2013 Draken Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end