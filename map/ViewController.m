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
@property (strong, nonatomic) MakeAdressList * addressList;
@property (strong, nonatomic) CLLocation * tapLocation;
@property (strong, nonatomic) NSString * addressString;
@property (assign, nonatomic) CLLocationCoordinate2D coordinateScreenPoint;

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
    self.touchNumber = 0;
    self.addressList = [MakeAdressList new];
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

#pragma mark - UITableViewDelegate

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressTableViewCell * adressCell = [tableView dequeueReusableCellWithIdentifier: @"AddressCell"];
   
    adressCell.ZIP_cellLabel.text = [[self.addressList.addressArray objectAtIndex:indexPath.row]valueForKey:@"ZIP"];
    adressCell.city_cellLabel.text = [[self.addressList.addressArray objectAtIndex:indexPath.row]valueForKey:@"City"];
    adressCell.street_cellLabel.text = [[self.addressList.addressArray objectAtIndex:indexPath.row]valueForKey:@"Street"];
   
    
    return adressCell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocation * centerLocation = [self.addressList location:indexPath.row];
    MKCoordinateRegion addressRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, centerLocation.coordinate.latitude, centerLocation.coordinate.longitude);
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

- (void) geoCoderVoid {
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:_tapLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark * place = [placemarks objectAtIndex:0];
        self.addressString = [NSString stringWithFormat:@"Город %@ \n Улица %@ \n Индекс %@", [place.addressDictionary valueForKey:@"City"],[place.addressDictionary valueForKey:@"Street"],[place.addressDictionary valueForKey:@"ZIP"]];
        self.addressList.stringZIP = [place.addressDictionary valueForKey:@"ZIP"];
        self.addressList.stringCity = [place.addressDictionary valueForKey:@"City"];
        self.addressList.stringStreet = [place.addressDictionary valueForKey:@"Street"];
        [self.addressList makeAddressDictionary];
        [self.addressList makeCoordinatesArray:_tapLocation];
        
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
        annotation.title = self.addressString;
        annotation.coordinate = self.coordinateScreenPoint;
        [self.mapView addAnnotation:annotation];
    }];

}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {        
        self.touchNumber = self.touchNumber+1; //при каждом длинном нажатии прибавляется единица
        self.coordinateScreenPoint = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        _tapLocation = [[CLLocation alloc]initWithLatitude:self.coordinateScreenPoint.latitude longitude:self.coordinateScreenPoint.longitude];
        [self geoCoderVoid];
    
    }
    
}
- (IBAction)buton_TableView:(id)sender {
    if (self.address_tableView.alpha == 0) {        
        //[self reloadTableView];
        self.address_tableView.alpha = 1;
        
    } else {
        self.address_tableView.alpha = 0;
    }
}
@end
