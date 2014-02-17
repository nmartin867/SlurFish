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
    MBProgressHUD *_hud;
    LocationProvider *_locationProvider;
 }

-(void) updatePubListTable:(NSArray *)pubs;
-(void) getPubsNearUser:(CLLocation *)location;
@end

@implementation PubListViewController

__weak PubListViewController *_pubListController;


#pragma mark - User location blocks

void (^onUserLocationFound)(CLLocation *) = ^(CLLocation *userLocation){
    [_pubListController getPubsNearUser:userLocation];
};


void (^onUserLocationError)(NSError *) = ^(NSError *error){
    //show error
};

#pragma mark - Pub location blocks

void (^onPubSearchResult)(NSArray *) = ^(NSArray *pubs){
    [_pubListController updatePubListTable:pubs];
};


void (^onPubSearchError)(NSError *) = ^(NSError *error){
     //show error
};


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pubService = [[PubService alloc]initWithPubRepository:[PubRepository new]];
    _locationProvider = [LocationProvider new];
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

- (void)showHudWithStatus:(NSString *)status{
    if(_hud == nil){
         _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    [self.view addSubview:_hud];
    // Set the hud to display with a color
    _hud.color = [UIColor HudColor];
    _hud.labelText = status;
    [_hud show:YES];
}

-(void)hideHud{
    [_hud hide:YES];
};

- (void)getUserLocation
{
    [self showHudWithStatus:@"Finding Waterholes..."];
    [_locationProvider getUserLocationWithSuccess:onUserLocationFound error:onUserLocationError];
}

- (void)updatePubListTable:(NSArray *)pubs{
    NSMutableArray *sortedPubs = [pubs mutableCopy];
  
    [sortedPubs sortedArrayUsingComparator:^NSComparisonResult(id a, id b){
                                      NSNumber *distanceA = [[(Pub *)a location] distance];
                                      NSNumber *distanceB = [[(Pub *)b location] distance];
                                      return [distanceA compare:distanceB];}];
    
    _pubs = [NSArray arrayWithArray:sortedPubs];
   [self.tableView reloadData];
   [self hideHud];

}

-(void)getPubsNearUser:(CLLocation *)location
{
    [_pubService getPubsWithCoordinate:location.coordinate
                                 onSuccess:onPubSearchResult
                                   onError:onPubSearchError];
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
    
    if(pub.categoryIconUrl && cell.imageView.image == nil){
       //download image
        [self downloadImageWithURL:pub.categoryIconUrl completionBlock:^(BOOL succeeded, UIImage *image){
         if (succeeded) {
            // change the image in the cell
            cell.imageView.image = image;
            // cache the image for use later (when scrolling up)
            pub.categoryIconImage = image;
            //update cell with icon
             [self.tableView beginUpdates];
             [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
             [self.tableView endUpdates];
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
