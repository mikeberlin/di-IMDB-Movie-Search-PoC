//
//  NetworkingViewController.m
//  NetworkingStuff
//
//  Created by Joel Angelone on 4/9/13.
//  Copyright (c) 2013 Draken Design. All rights reserved.
//

#import <objc/runtime.h>
#import "NetworkingViewController.h"
#import "AFNetworking.h"
#import "MovieCell.h"

@implementation NetworkingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];

	self.title = @"IMDB Search";
}

- (IBAction)search:(id)sender {
	[self.view endEditing:YES];
	[self.activityIndicator startAnimating];
	
	NSString *encodedString = [self.searchField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *searchString = [NSString stringWithFormat:@"http://imdbapi.org/?type=json&limit=20&title=%@", encodedString];
	
	NSURL *url = [NSURL URLWithString:searchString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		self.movies = JSON;
		[self.tableView reloadData];
		[self.activityIndicator stopAnimating];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[self.activityIndicator stopAnimating];
	}];
	
	
	[operation start];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UINib *movieCellNib = [UINib nibWithNibName:@"MovieCell" bundle:[NSBundle mainBundle]];
	MovieCell *cell = [[movieCellNib instantiateWithOwner:nil options:nil] lastObject];

	NSDictionary *movie = [self.movies objectAtIndex:indexPath.row];
	NSString *title = [movie valueForKey:@"title"];
	id year = [movie valueForKey:@"year"];
    
    cell.titleLabel.text = title;
	cell.yearLabel.text = [NSString stringWithFormat:@"%@", year];
	
	NSURL *posterUrl = [NSURL URLWithString:[movie valueForKey:@"poster"]];
	NSURLRequest *request = [NSURLRequest requestWithURL:posterUrl];
	
	NSLog(@"about to load image");
	
	AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
		cell.posterImage.image = image;
		[cell layoutSubviews];
	}];

	[operation start];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posterTapped:)];
    tapRecognizer.numberOfTapsRequired = 2;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(posterSwiped:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [cell.posterImage addGestureRecognizer:tapRecognizer];
    cell.posterImage.userInteractionEnabled = YES;
    [cell addGestureRecognizer:swipeRecognizer];

	return cell;
}

- (void)posterTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    MovieCell *firstCell = (MovieCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if (firstCell)
    {
        [UIView animateWithDuration:1.0 animations:^{
            gestureRecognizer.view.alpha = 0.0;
        }];
    }
}

- (void)posterSwiped:(UISwipeGestureRecognizer *)gestureRecognizer
{
    MovieCell *firstCell = (MovieCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if (firstCell)
    {
        [UIView animateWithDuration:1.0 animations:^{
            MovieCell *movieCell = (MovieCell *)gestureRecognizer.view;
            movieCell.posterImage.transform = CGAffineTransformRotate(movieCell.posterImage.transform, -M_PI_2);
        }];
    }
}

@end