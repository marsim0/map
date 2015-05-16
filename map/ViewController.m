//
//  ViewController.m
//  map
//
//  Created by Мариам Б. on 13.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    BOOL isCurrentLocation;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) NSString * addressString;
@property (strong,nonatomic) NSMutableArray * addressArray;
@property (strong,nonatomic) NSMutableDictionary * addressDictionary;

@end

@implementation ViewController

- (void) firstLaunch {

    NSString * version = [[UIDevice currentDevice]systemVersion];
    if ([version integerValue]>=8) {
        [self.locationManager requestAlwaysAuthorization];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressArray = [[NSMutableArray alloc] init];
    self.address_tableView.alpha = 0;
    isCurrentLocation = NO;
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"];
    if (!isFirstLaunch) {
        [self firstLaunch];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupMapView : (CLLocationCoordinate2D) coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (![annotation isKindOfClass: MKUserLocation.class]) {
         MKAnnotationView * annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        annView.canShowCallout = NO;
        annView.image = [UIImage imageNamed:@"pin_map"];
        [annView addSubview:[self getCalloutView:annotation.title]];
        return annView;
    }
   
    return nil;
}

- (UIView *) getCalloutView : (NSString *) title {
    UIView * callView = [[UIView alloc]initWithFrame:CGRectMake(-100, -105, 250, 100)];
    callView.backgroundColor = [UIColor whiteColor];
    callView.tag = 1000;
    callView.alpha = 0;
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 240, 90)];
    lable.numberOfLines = 0;
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor blackColor];
    lable.text = title;
    [callView addSubview:lable];
    return callView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation isKindOfClass:MKUserLocation.class]) {
        for (UIView * subview in view.subviews) {
            if (subview.tag == 1000) {
                subview.alpha = 1;
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView * subview in view.subviews) {
        if (subview.tag == 1000) {
            subview.alpha = 0;
        }
    }

}

- (void) reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.address_tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressTableViewCell * addressCell = [tableView dequeueReusableCellWithIdentifier: @"AddressCell"];
   
    addressCell.ZIP_cellLabel.text = [[self.addressArray objectAtIndex:indexPath.row]valueForKey:@"ZIP"];
    addressCell.city_cellLabel.text = [[self.addressArray objectAtIndex:indexPath.row]valueForKey:@"City"];
    addressCell.street_cellLabel.text = [[self.addressArray objectAtIndex:indexPath.row]valueForKey:@"Street"];
    
    return addressCell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressArray.count;
    
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocation * centerLocation = [[self.addressArray valueForKey:@"Location" ] objectAtIndex:indexPath.row];
    MKCoordinateRegion addressRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, 500, 500);
    [self.mapView setRegion:addressRegion animated:YES];
    
}

#pragma mark - MKMapViewDelegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if (fullyRendered) {
        [self.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!isCurrentLocation) {
        isCurrentLocation = YES;
        [self setupMapView:newLocation.coordinate];
    }
}


#pragma mark - IBActions

- (IBAction)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {        
        
        CLLocationCoordinate2D coordinateScreenPoint = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        CLLocation * tapLocation = [[CLLocation alloc]initWithLatitude:coordinateScreenPoint.latitude longitude:coordinateScreenPoint.longitude];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:tapLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark * place = [placemarks objectAtIndex:0];
            
            self.addressString = [NSString stringWithFormat:@"Город %@ \n Улица %@ \n Индекс %@", [place.addressDictionary valueForKey:@"City"],[place.addressDictionary valueForKey:@"Street"],[place.addressDictionary valueForKey:@"ZIP"]];
            
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
            annotation.title = self.addressString;
            annotation.coordinate = coordinateScreenPoint;
            [self.mapView addAnnotation:annotation];
            
            self.addressDictionary = [[NSMutableDictionary alloc] init];
            [self.addressDictionary setObject: [place.addressDictionary valueForKey:@"ZIP"] forKey:@"ZIP"];
            [self.addressDictionary setObject: [place.addressDictionary valueForKey:@"City"] forKey:@"City"];
            [self.addressDictionary setObject: [place.addressDictionary valueForKey:@"Street"] forKey:@"Street"];
            [self.addressDictionary setObject:tapLocation forKey:@"Location"];
            
            [self.addressArray addObject:self.addressDictionary];
        }];
    }    
}


- (IBAction)buton_TableView:(id)sender {
    
    if (self.address_tableView.alpha == 0) {
        [self reloadTableView];
        self.address_tableView.alpha = 1;
    } else {
        self.address_tableView.alpha = 0;
    }
    
}

@end
