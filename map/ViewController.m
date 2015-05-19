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
@property (weak, nonatomic) IBOutlet MKMapView * mapView;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) NSString * addressString;
@property (strong, nonatomic) NSMutableArray * addressArray;
@property (strong, nonatomic) SingleTone * addressSingle ;

@property (weak, nonatomic) IBOutlet UILabel *addedAddress_lable;

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
    self.addedAddress_lable.alpha = 0;
    self.addressSingle = [SingleTone sharedSingleTone];
    self.addressArray = [[NSMutableArray alloc] init];    
    isCurrentLocation = NO;
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"];
    if (!isFirstLaunch) {
        [self firstLaunch];
    }
    self.addressSingle = [SingleTone sharedSingleTone];
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

- (void) lableAnimation : (int) alpha View : (UIView*) view {
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    [animation setFillMode:kCAFillModeBoth];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [view.layer addAnimation:animation forKey:@"Fade"];
    view.alpha = alpha;
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


- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CLLocationCoordinate2D coordinateScreenPoint = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
        CLLocation * tapLocation = [[CLLocation alloc]initWithLatitude:coordinateScreenPoint.latitude longitude:coordinateScreenPoint.longitude];
        
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        
        [geocoder reverseGeocodeLocation:tapLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark * place = [placemarks objectAtIndex:0];
            
            __block NSMutableDictionary * addressDict = [[NSMutableDictionary alloc] init];
            
            void (^blockWithAddressArguments)(NSString*, NSString*, NSString*,CLLocation*) = ^(NSString * stringZIP, NSString * stringCity, NSString * stringStreet, CLLocation * location) {
                
                [addressDict setObject: stringZIP forKey:@"ZIP"];
                [addressDict setObject: stringCity forKey:@"City"];
                [addressDict setObject: stringStreet forKey:@"Street"];
                [addressDict setObject:location forKey:@"Location"];
                
            };
            
            blockWithAddressArguments ([place.addressDictionary valueForKey:@"ZIP"], [place.addressDictionary valueForKey:@"City"],[place.addressDictionary valueForKey:@"Street"], tapLocation);
            
            [self.addressSingle makeAddressArray];
            [self.addressSingle.addressArray addObject:addressDict];
            
        }];
    }
    [self lableAnimation:1 View:self.addedAddress_lable];
    [self lableAnimation:0 View:self.addedAddress_lable];

}




@end
