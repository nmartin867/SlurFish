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
#import "UIColor+SlurFish.h"



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
   
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];

    
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBackgroupColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil]
                                                                                            forState:UIControlStateNormal];
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"refreshbutton.png"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(0, 0, 32, 32);
    [refreshButton addTarget:self action:@selector(getUserLocation)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshButton];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor cellTextColor];
    cell.detailTextLabel.textColor = [UIColor cellTextColor];

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
    _selectedPub = [_pubs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"PubMap" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PubMapViewController *pubLocationView = (PubMapViewController *)[segue destinationViewController];
    pubLocationView.pub = _selectedPub;
}

@end
