//
//  PubListViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "PubListViewController.h"
#import "PubMapViewController.h"
#import "LocationProvider.h"
#import <CoreLocation/CLLocation.h>
#import "PubService.h"
#import "Pub.h"
#import "SFPubLocation.h"
#import "MBProgressHUD.h"
#import "NSNumber+SFMileConverstions.h"
#import "PubRepository.h"



@interface PubListViewController () {
    NSArray *_pubs;
    Pub *_selectedPub;
    PubService *_pubService;
 }
@property(nonatomic, strong)LocationProvider *locationProvider;
@property(nonatomic, strong)UserLocationSuccess userLocationSuccessBlock;
@property(nonatomic, strong)UserLocationError userLocationErrorBlock;
@property(nonatomic, strong)PubSearchRequestSuccess pubSearchRequestSuccessBlock;
@property(nonatomic, strong)PubSearchRequestError pubSearchRequestErrorBlock;


@end

@implementation PubListViewController

@synthesize locationProvider = _locationProvider;
@synthesize userLocationSuccessBlock = _userLocationSuccessBlock;
@synthesize userLocationErrorBlock = _userLocationErrorBlock;
@synthesize pubSearchRequestSuccessBlock = _pubSearchRequestSuccessBlock;
@synthesize pubSearchRequestErrorBlock = _pubSearchRequestErrorBlock;
  __weak PubListViewController *_pubListController;



-(UserLocationSuccess)userLocationSuccessBlock{
    return ^(CLLocation *location){
        [self getPubsNearCoordinates:location];
    };
}

-(UserLocationError)userLocationErrorBlock{
    return ^(NSError *error){
        
    };
}

-(PubSearchRequestSuccess)pubSearchRequestSuccessBlock{
    return ^(NSMutableArray *pubSearchResults){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _pubs = [[NSMutableArray arrayWithArray:pubSearchResults] sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
            NSNumber *distanceA = [[(Pub *)a location] distance];
            NSNumber *distanceB = [[(Pub *)b location] distance];
            return [distanceA compare:distanceB];
        }];
        [self.tableView reloadData];
    };
}

-(PubSearchRequestError)pubSearchRequestErrorBlock{
    return ^(NSError *error){
        
    };
}


-(LocationProvider *)locationProvider{
    if(_locationProvider == nil){
        _locationProvider = [[LocationProvider alloc]init];
    }
    return _locationProvider;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pubService = [[PubService alloc]initWithPubRepository:[PubRepository new]];
    _pubListController = self;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getUserLocation)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"tableBackground.png"];
    self.tableView.backgroundView = imageView;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(61/255.0) green:(61/255.0) blue:(61/255.0) alpha:1.0];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)getUserLocation
{
    [self.locationProvider getUserLocationWithSuccess:self.userLocationSuccessBlock error:self.userLocationErrorBlock];
}

-(void)getPubsNearCoordinates:(CLLocation *)location
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_pubService getPubsWithCoordinate:location.coordinate
                                 onSuccess:self.pubSearchRequestSuccessBlock
                                   onError:self.pubSearchRequestErrorBlock];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pubs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"PubCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    Pub *pub = _pubs[indexPath.row];
    cell.textLabel.text = [pub name];
    float meters = [pub.location.distance floatValue];   
    float miles = [NSNumber milesWithMeters:meters];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f miles", miles];
    
    if(pub.categoryIconUrl){
       //download image
        [self downloadImageWithURL:pub.categoryIconUrl completionBlock:^(BOOL succeeded, UIImage *image){
         if (succeeded) {
            // change the image in the cell
            cell.imageView.image = image;
            
            // cache the image for use later (when scrolling up)
             pub.categoryIconImage = image;
         }
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setHidden:YES];
    _selectedPub = [_pubs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"PubMap" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PubMapViewController *pubLocationView = (PubMapViewController *)[segue destinationViewController];
    [pubLocationView setPub:_selectedPub];
}

@end
