//
//  MapPaintSearchViewController.m
//  BaiduMapApiDemo
//
//  Created by andy on 13-5-30.
//
//

#import "MapPaintSearchViewController.h"

@implementation MapPaintSearchViewController

@synthesize mapView, waitView, mapPaintSearchView, mapPaintOverplay, annotationArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.mapView = [[BMKMapView alloc] init];
    self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height),
    [self.view addSubview:self.mapView];

    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [locationButton setTitle:@"定位" forState:UIControlStateNormal];
    locationButton.frame = CGRectMake(650, 50, 100, 50);
    [locationButton addTarget:self action:@selector(doLocationSender:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:locationButton];
    
    
    UIButton *mapPaintSearchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mapPaintSearchButton setTitle:@"搜索" forState:UIControlStateNormal];
    mapPaintSearchButton.frame = CGRectMake(650, 150, 100, 50);
    [mapPaintSearchButton addTarget:self action:@selector(doMapPaintSearchSender:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mapPaintSearchButton];
    
    
    UIButton *mapSearchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mapSearchButton setTitle:@"地图" forState:UIControlStateNormal];
    mapSearchButton.frame = CGRectMake(650, 250, 100, 50);
    [mapSearchButton addTarget:self action:@selector(doMapSearchSender:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mapSearchButton];
    
}

-(void) viewDidLoad
{
    //mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
}


- (BOOL)shouldAutorotate{
    if (self.preferredInterfaceOrientationForPresentation == UIInterfaceOrientationMaskLandscapeLeft
        || self.preferredInterfaceOrientationForPresentation == UIInterfaceOrientationMaskLandscapeRight) {//支持横屏
        return YES;
    }
    return NO;//禁止旋转
    
}

-(void) doLocationSender:(id)sender {
    
    if (self.mapPaintSearchView) {
        self.mapPaintSearchView.hidden = YES;
    }
    
    mapView.showsUserLocation = YES;
    
    [self removeMapOverplayAndAnnotationArray];
    
    //上海 BaiduMapApiDemo[1256:907] 31.197513 121.674286
//    CLLocationCoordinate2D coor;
//	coor.latitude = 31.197513;
//	coor.longitude = 121.674286;
//    [self.mapView setCenterCoordinate:coor animated:YES];
    
      mapView.zoomLevel = 13;
    //[self addAnnotation:coor];
}


-(void) addAnnotation:(CLLocationCoordinate2D) coor{

	BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
	annotation.coordinate = coor;
	
	annotation.title = @"ME";
	annotation.subtitle = @"I am Here!";
	[mapView addAnnotation:annotation];
    
    if (self.annotationArray == nil) {
        self.annotationArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [self.annotationArray addObject:annotation];
}


-(void) removeAnnotationArray
{
    for (BMKPointAnnotation * annotation in self.annotationArray) {
        [mapView removeAnnotation:annotation];
    }
    
}

-(void) removeMapOverplay
{
    if (self.mapPaintOverplay != nil) {
        [self.mapView removeOverlay:mapPaintOverplay];
        [self.mapPaintOverplay release];
        self.mapPaintOverplay = nil;
    }
}


-(void) removeMapOverplayAndAnnotationArray
{
    [self removeMapOverplay];
    [self removeAnnotationArray];
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = YES;
		
		return newAnnotation;
	}
	return nil;
}


- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        [self addAnnotation:userLocation.location.coordinate];
	}
	self.mapView.showsUserLocation = NO;
}


- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil){
		NSLog(@"locate failed: %@", [error localizedDescription]);
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
	}else {
		NSLog(@"locate failed");
	}
    
	self.mapView.showsUserLocation = NO;	
}


-(void) doMapPaintSearchSender:(id)sender {
    if (!self.mapPaintSearchView) {
        self.mapPaintSearchView = [[MapPaintSearchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        self.mapPaintSearchView.delegate = self;
        [self.view insertSubview:self.mapPaintSearchView aboveSubview:self.mapView];
    }else{
        self.mapPaintSearchView.hidden = NO;
    }
    
    [self removeMapOverplayAndAnnotationArray];
    [self.mapPaintSearchView startMapPaintSearch];
}


-(void) doMapSearchSender:(id)sender {

    if (self.mapPaintSearchView) {
        self.mapPaintSearchView.hidden = YES;
    }

    [self removeMapOverplayAndAnnotationArray];
    
    CGRect viewRect = mapView.frame;
    //NSLog(@"doMapSearchSender viewRect === x:%f y:%f width:%f height:%f", viewRect.origin.x, viewRect.origin.y, viewRect.size.width, viewRect.size.height);
    
    NSMutableArray *pointMutableArray = [[NSMutableArray alloc]initWithCapacity:4];
    NSMutableArray *locationMutableArray = [[NSMutableArray alloc]initWithCapacity:4];
    
    [pointMutableArray addObject:NSStringFromCGPoint(viewRect.origin)];
    [pointMutableArray addObject:NSStringFromCGPoint(CGPointMake(viewRect.origin.x + viewRect.size.width, viewRect.origin.y))];
    [pointMutableArray addObject:NSStringFromCGPoint(CGPointMake(viewRect.origin.x, viewRect.origin.y + viewRect.size.height))];
    [pointMutableArray addObject:NSStringFromCGPoint(CGPointMake(viewRect.origin.x + viewRect.size.width, viewRect.origin.y + viewRect.size.height))];
    
    locationMutableArray = [self tanslateLocationFromPoint:pointMutableArray];
    //NSLog(@"mapPaintSearchPoints locationMutableArray == %@", locationMutableArray);
    
    [self doMapSearchMap:locationMutableArray mapSearchAreaType:MapSearchRect];
    
    //[self.view setNeedsDisplay];
}



-(void) mapPaintSearchImage:(UIImage*)image points:(NSMutableArray *)array isCircle:(BOOL)isCircle
{
    //NSLog(@"mapPaintSearchPoints isCircle == %d", isCircle);
    
    self.mapPaintSearchView.hidden = YES;
    
    CLLocationCoordinate2D center = [self.mapView convertPoint:self.mapPaintSearchView.center toCoordinateFromView:self.mapPaintSearchView];
    
    BMKMapRect mapRect = [self.mapView convertRect:self.mapPaintSearchView.frame toMapRectFromView:self.mapPaintSearchView];
    
    if (image != nil) {
        mapPaintOverplay = [BMKMapPaint mapPaintWithCenterCoordinate:center mapRect:mapRect image:image];
        
        [self.mapView addOverlay:mapPaintOverplay];
    }
    
    NSMutableArray *locationMutableArray = [self tanslateLocationFromPoint:array];
    //NSLog(@"mapPaintSearchPoints locationMutableArray == %@", locationMutableArray);
    
    if (isCircle) {
        [self doMapSearchMap:locationMutableArray mapSearchAreaType:MapSearchCircle];
    }else{
        [self doMapSearchMap:locationMutableArray mapSearchAreaType:MapSearchNoClosureArea];
    }
    
}


- (BMKOverlayView *)mapView:(BMKMapView *)_mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKMapPaint class]])
    {
        BMKMapPaintView* mapPaintView = [[[BMKMapPaintView alloc] initWithMapPaint:overlay mapView:_mapView] autorelease];
        mapPaintView.backgroundColor = [UIColor clearColor];
		return mapPaintView;
    }
	return nil;
}


//需要拼接报文格式
-(void) doMapSearchMap:(NSMutableArray*) locationArray mapSearchAreaType:(MapSearchAreaType)areaType
{
    NSLog(@"mapPaintSearchPoints isCircle == %@  areaType === %d", locationArray, areaType);
    [self addWaitingView];
    [self requestMapSearch:locationArray mapSearchAreaType:areaType];
}


-(void) requestMapSearch:(NSMutableArray*) locationArray mapSearchAreaType:(MapSearchAreaType)areaType
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:locationArray forKey:@"location"];
    [dict setObject:[NSString stringWithFormat:@"%d", areaType] forKey:@"searchType"];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(responseMapSearch:) userInfo:dict repeats:NO];
    [dict release];
}


-(void) responseMapSearch:(NSTimer *)timer
{
    NSMutableArray *locationArray = [[timer userInfo] objectForKey:@"location"];
    NSString *areaTypeStr = [[timer userInfo] objectForKey:@"searchType"];
    
    NSLog(@"responseMapSearch locationArray == %@  areaType === %@", locationArray, areaTypeStr);
    
    [self hideWaitView];
    
    [self addAnnotation:mapView.centerCoordinate];
}


-(void) addWaitingView
{
    if (self.waitView == nil) {
        waitView = [[UIView alloc]initWithFrame:self.view.frame];
        waitView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
        
        UIView *waitInfoView = [[UIView alloc]initWithFrame:self.view.frame];
        waitInfoView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        waitInfoView.frame = CGRectMake(300, 400, 150, 50);
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]init];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [waitInfoView addSubview:indicator];
        indicator.frame = CGRectMake(0, 0, 50, 50);
        [indicator startAnimating];
        [indicator release];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 50)];
        label.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        label.text = @"正在请求.....";
        [waitInfoView addSubview:label];
        [label release];
        
        [waitView addSubview:waitInfoView];
        [waitInfoView release];
        
        [self.view addSubview:waitView];
    }else{
        self.waitView.hidden = NO;
    }
    
}

-(void) hideWaitView
{
    if (self.waitView != nil) {
        self.waitView.hidden = YES;
    }
}


-(NSMutableArray*) tanslateLocationFromPoint:(NSMutableArray *)array
{
    NSMutableArray *locationMutableArray = [[NSMutableArray alloc]initWithCapacity:10];
    [locationMutableArray autorelease];
    
    for (NSString *str in array) {
        CGPoint point = CGPointFromString(str);
        CLLocationCoordinate2D location = [mapView convertPoint:point toCoordinateFromView:self.mapPaintSearchView];
        CLLocation *Clocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
        [locationMutableArray addObject:Clocation];
    }
    return locationMutableArray;
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    if (self.mapView != nil) {
        [self.mapView release];
    }
    
    if (self.mapPaintSearchView != nil) {
        [self.mapPaintSearchView release];
    }
    
    if (self.waitView != nil) {
        [self.waitView release];
    }
    
    if (self.mapPaintOverplay != nil) {
        [self.mapPaintOverplay release];
    }
    
    if (self.annotationArray != nil) {
        [self.annotationArray release];
    }
    
    
    [super dealloc];
}


@end


