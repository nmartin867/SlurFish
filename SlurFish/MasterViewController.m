//
//  MasterViewController.m
//  SlurFish
//
//  Created by Nick Martin on 1/12/14.
//  Copyright (c) 2014 org.monkeyman. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "LocationProvider.h"
#import <CoreLocation/CLLocation.h>
#import "PubService.h"
#import "Pub.h"
#import "MBProgressHUD.h"

@interface MasterViewController () {
    NSMutableArray *_pubs;
}
@property(nonatomic, strong)LocationProvider *locationProvider;
@property(nonatomic, strong)PubService *pubService;
@property(nonatomic, strong)UserLocationSuccess userLocationSuccessBlock;
@property(nonatomic, strong)UserLocationError userLocationErrorBlock;
@property(nonatomic, strong)PubSearchRequestSuccess pubSearchRequestSuccessBlock;
@property(nonatomic, strong)PubSearchRequestError pubSearchRequestErrorBlock;

@end

@implementation MasterViewController

@synthesize locationProvider = _locationProvider;
@synthesize pubService = _pubService;
@synthesize userLocationSuccessBlock = _userLocationSuccessBlock;
@synthesize userLocationErrorBlock = _userLocationErrorBlock;
@synthesize pubSearchRequestSuccessBlock = _pubSearchRequestSuccessBlock;
@synthesize pubSearchRequestErrorBlock = _pubSearchRequestErrorBlock;

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
        _pubs = [NSMutableArray arrayWithArray:pubSearchResults];
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



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(getUserLocation)];
    self.navigationItem.rightBarButtonItem = addButton;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Pub *pub = _pubs[indexPath.row];
    cell.textLabel.text = [pub name];
    NSNumber *meters = (NSNumber *)pub.location[@"distance"];
    NSNumber *conversionFactor = @(0.00062137);
    NSNumber *miles = @([conversionFactor floatValue] * [meters integerValue]);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ miles", miles];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_pubs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Pub *pub = _pubs[indexPath.row];
        [[segue destinationViewController] setPub:pub];
    }
}

@end
