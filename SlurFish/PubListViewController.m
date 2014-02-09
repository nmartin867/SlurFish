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
#import "SFImageDownloader.h"
#import "SFImageRequest.h"

@interface PubListViewController () {
    NSArray *_pubs;
    Pub *_selectedPub;
    SFImageDownloader *_imageDownloader;
}
@property(nonatomic, strong)LocationProvider *locationProvider;
@property(nonatomic, strong)PubService *pubService;
@property(nonatomic, strong)UserLocationSuccess userLocationSuccessBlock;
@property(nonatomic, strong)UserLocationError userLocationErrorBlock;
@property(nonatomic, strong)PubSearchRequestSuccess pubSearchRequestSuccessBlock;
@property(nonatomic, strong)PubSearchRequestError pubSearchRequestErrorBlock;


@end

@implementation PubListViewController

@synthesize locationProvider = _locationProvider;
@synthesize pubService = _pubService;
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
        NSMutableDictionary *iconRequests = [NSMutableDictionary dictionary];
        for(int i = 0; i < [_pubs count]; ++i){
            NSURL *categoryIconUrl = [_pubs[i] categoryIconUrl];
            if(categoryIconUrl != nil){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(i + 1) inSection:0];
                [iconRequests setObject:categoryIconUrl forKey:indexPath];
            }
        }
        SFImageRequest *imageRequest = [[SFImageRequest alloc]initWithRequests:iconRequests];
        [imageRequest setCompletionBlockWithSuccess:onIconDownload failure:onIconDownloadFailure];
        _imageDownloader = [[SFImageDownloader alloc]initWithRequest:imageRequest];
        [_imageDownloader start];
        [self.tableView reloadData];
    };
}

-(PubSearchRequestError)pubSearchRequestErrorBlock{
    return ^(NSError *error){
        
    };
}

-(PubService *)pubService{
    if(_pubService == nil){
        _pubService = [[PubService alloc]init];
    }
    return _pubService;
}

-(LocationProvider *)locationProvider{
    if(_locationProvider == nil){
        _locationProvider = [[LocationProvider alloc]init];
    }
    return _locationProvider;
}

SFImageDownloadComplete onIconDownload = ^(NSSet *indexPaths, UIImage *image){
    for(NSIndexPath *indexPath in indexPaths){
        UITableViewCell *cell = [_pubListController.tableView cellForRowAtIndexPath:indexPath];
        cell.imageView.image = image;
    }
};

SFImageDownloadFailure onIconDownloadFailure = ^(NSError *error){
    
};

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)getUserLocation
{
    [self.locationProvider getUserLocationWithSuccess:self.userLocationSuccessBlock error:self.userLocationErrorBlock];
}

-(void)getPubsNearCoordinates:(CLLocation *)location
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.pubService getPubsWithCoordinate:location.coordinate
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
    float conversionFactor = 0.00062137;
    float miles = conversionFactor * meters;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f miles", miles];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedPub = [_pubs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"PubMap" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PubMapViewController *pubLocationView = (PubMapViewController *)[segue destinationViewController];
    [pubLocationView setPub:_selectedPub];
}

@end
