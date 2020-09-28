//
//  OpenCVWrapper.m
//  scannerecg
//
//  Created by Francisco Gago on 20/02/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

#ifdef __cplusplus
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <opencv2/opencv.hpp>
#pragma clang pop
#import "OpenCVWrapper.hpp"
#pragma clang pop
#endif

using namespace std;
using namespace cv;

#pragma mark - Private Declarations

@interface OpenCVWrapper ()

#ifdef __cplusplus

+ (Mat)_grayFrom:(Mat)source;
+ (Mat)_matFrom:(UIImage *)source;
+ (UIImage *)_imageFrom:(Mat)source;

#endif

@end

#pragma mark - OpenCVWrapper

@implementation OpenCVWrapper

#pragma mark Public

+ (UIImage *)toGray:(UIImage *)source {
    cout << "OpenCV: ";
    return [OpenCVWrapper _imageFrom:[OpenCVWrapper _grayFrom:[OpenCVWrapper _matFrom:source]]];
}

+ (UIImage *)im2bw:(UIImage *)source {
    cout << "OpenCV: ";
    return [OpenCVWrapper _imageFrom:[OpenCVWrapper _thresholdFrom:[OpenCVWrapper _matFrom:source]]];
}

#pragma mark Private

+ (Mat)_grayFrom:(Mat)source {
    cout << "-> grayFrom ->";
    
    Mat result;
    
    // Punto n1:
    // pasar de color rgb a hsv
    cvtColor(source, result, COLOR_RGB2HSV);
    
    // Punto n2:
    // Se deben determinar los determinar rangos de HSV
    float rangeHmin = 0.000;
    float rangeSmin = 0.000;
    float rangeVmin = 165;
    float rangeHmax = 254;
    float rangeSmax = 168;
    float rangeVmax = 255;
    
    // Punto n2:
    // Aplicar rangos
    inRange(result, Scalar(rangeHmin, rangeSmin, rangeVmin), Scalar(rangeHmax, rangeSmax, rangeVmax), result);
    
    // Punto n3:
    // Invertimos la mascara
    result = 255 - result;
    
    // Punto intermedio aun por determinar
    threshold(result, result, 127, 255, 0);
    
    // Punto n4:
    // Limpiar la mascara: bwareaopen(BW,1260) en Matlab
    int erosion_type = 0;
    int erosion_size = 0;
    cv::Point p = cv::Point(erosion_size,erosion_size);
    cv::Size s = cv::Size(2*erosion_size + 1, 2*erosion_size+1);

    morphologyEx(result, result, MORPH_OPEN, getStructuringElement(erosion_type,s,p));

    // Punto n5:
    // Voltear verticalmente la imagen
    flip(result, result, 1);
    
    // Punto n6:
    // Invertir: de fondo negro a fondo blanco limpio
    result = 255 - result;
    
    // Punto n7:
    // thinning
    //result = cv2::ximgproc::thinning(cv2.cvtColor(image, cv2.COLOR_RGB2GRAY))
    
    //result = cv2::ximgproc::thinning(cv::cvtColor(result, result, cv::COLOR_RGB2GRAY))
    
    // Punto n8:
    // Recorrer la imagen para transformar los pixeles en coordenadas
    
    
    
    return result;
}

+ (Mat)_thresholdFrom:(Mat)source {
    cout << "-> grayFrom ->";
    
    Mat result;
    //cvtColor(source, result, COLOR_BGR2GRAY);
    threshold(source, result, 127, 255, 0);
    
    return result;
}

+ (Mat)_matFrom:(UIImage *)source {
    cout << "matFrom ->";
    
    CGImageRef image = CGImageCreateCopy(source.CGImage);
    CGFloat cols = CGImageGetWidth(image);
    CGFloat rows = CGImageGetHeight(image);
    Mat result(rows, cols, CV_8UC4);
    
    CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = result.step[0];
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    
    CGContextRef context = CGBitmapContextCreate(result.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
    CGContextRelease(context);
    
    return result;
}

+ (UIImage *)_imageFrom:(Mat)source {
    cout << "-> imageFrom\n";
    
    NSData *data = [NSData dataWithBytes:source.data length:source.elemSize() * source.total()];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    CGBitmapInfo bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = source.step[0];
    CGColorSpaceRef colorSpace = (source.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());
    
    CGImageRef image = CGImageCreate(source.cols, source.rows, bitsPerComponent, bitsPerComponent * source.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:image];
    
    CGImageRelease(image);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return result;
}

@end
