//
//  BMKMapPaint.m
//  BaiduMapApiDemo
//
//  Created by andy on 13-6-1.
//
//

#import "BMKMapPaint.h"

@interface BMKMapPaint (Private)

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)aCoord mapRect:(BMKMapRect)mapRect image:(UIImage *)image;

@end

@implementation BMKMapPaint

@synthesize coordinate, boundingMapRect, image;


+ (BMKMapPaint *)mapPaintWithCenterCoordinate:(CLLocationCoordinate2D)aCoord mapRect:(BMKMapRect)mapRect image:(UIImage *)image
{
    return [[self alloc] initWithCenterCoordinate:aCoord  mapRect:mapRect image:image];
}


#pragma mark Private

- (id)initWithCenterCoordinate:(CLLocationCoordinate2D)aCoord  mapRect:(BMKMapRect)mapRect  image:(UIImage*)aimage
{
    if (self = [super init])
    {
        coordinate = aCoord;
        boundingMapRect = mapRect;
        image  = aimage;
    }
    return self;
}

@end
