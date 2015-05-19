//
//  SecondViewController.m
//  map
//
//  Created by Мариам Б. on 17.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController () {
    BOOL isCurrentLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) SingleTone * addressSingle ;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (weak, nonatomic) IBOutlet UITableView *address_tableView;
@property (strong, nonatomic) NSString * addressString;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressSingle = [SingleTone sharedSingleTone];

    isCurrentLocation = NO;
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.addressSingle = [SingleTone sharedSingleTone];
    [self addAnotations];
    [self reloadTableView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.address_tableView reloadData];
    });
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

- (void) addAnotations {
   
    for (int i = 0; i < self.addressSingle.addressArray.count; i++) {

        self.addressString = [NSString stringWithFormat:@"Город %@ \n Улица %@ \n Индекс %@", [[self.addressSingle.addressArray objectAtIndex: i] valueForKey:@"City"],[[self.addressSingle.addressArray objectAtIndex: i]valueForKey:@"Street"],[[self.addressSingle.addressArray objectAtIndex: i] valueForKey:@"ZIP"]];
        
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc]init];
        annotation.title = self.addressString;
        CLLocation * annLocation = [[self.addressSingle.addressArray objectAtIndex: i] valueForKey:@"Location"];
        annotation.coordinate = annLocation.coordinate;
        
        [self.mapView addAnnotation:annotation];
    }
    
}

#pragma mark - UITableViewDataSource

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressTableViewCell * addressCell = [tableView dequeueReusableCellWithIdentifier: @"AddressCell"];
    
    addressCell.ZIP_cellLabel.text = [[self.addressSingle.addressArray objectAtIndex:indexPath.row]valueForKey:@"ZIP"];
    addressCell.city_cellLabel.text = [[self.addressSingle.addressArray objectAtIndex:indexPath.row]valueForKey:@"City"];
    addressCell.street_cellLabel.text = [[self.addressSingle.addressArray objectAtIndex:indexPath.row]valueForKey:@"Street"];
    
    return addressCell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressSingle.addressArray.count;
    
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocation * centerLocation = [[self.addressSingle.addressArray valueForKey:@"Location" ] objectAtIndex:indexPath.row];
    MKCoordinateRegion addressRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, 500, 500);
    [self.mapView setRegion:addressRegion animated:YES];
    
}


@end
