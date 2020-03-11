//
//  BMKMapPaintView.m
//  BaiduMapApiDemo
//
//  Created by andy on 13-6-3.
//
//

#import "BMKMapPaintView.h"

@implementation BMKMapPaintView

@synthesize mapPaint, mapView, imageView;

- (id)initWithMapPaint:(BMKMapPaint *)_mapPaint mapView:(BMKMapView *)_mapView
{
    self = [super init];
    
    if (self) {
    
        self.mapPaint = _mapPaint;
        self.mapView =_mapView;
        
        imageView = [[UIImageView alloc] initWithImage:mapPaint.image];
    
        imageView.center = [mapView convertCoordinate:mapPaint.coordinate toPointToView:self];
        
        [self addSubview:imageView];
                
        self.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
     }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    imageView.center = [mapView convertCoordinate:mapPaint.coordinate toPointToView:self];
    imageView.bounds = [mapView convertMapRect:mapPaint.boundingMapRect toRectToView:self];
}


-(void) dealloc{
    
    [self.imageView release];
    
    [super dealloc];
}

@end
