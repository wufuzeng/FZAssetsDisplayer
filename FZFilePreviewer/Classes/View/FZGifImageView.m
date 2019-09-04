//
//  FZGifImageView.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import "FZGifImageView.h"
#import <ImageIO/ImageIO.h>


@interface FZGifImageView ()
<
CAAnimationDelegate
>

/** 小菊花 */
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) CAKeyframeAnimation *animation;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) FZFilePreviewGifModel *gifModel;

@end

@implementation FZGifImageView

-(void)configWithModel:(FZFilePreviewModel *)model{
    self.contentMode = model.contentMode;
    self.gifModel = model.gifModel;
    self.url = model.link;
    self.image = model.gifModel.firstFrame;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
}

-(void)startGifAnimating{
    if (self.gifModel.times.count == 0 ||
        self.gifModel.images.count == 0 ||
        self.gifModel.duration == 0) {
        if (self.url) {
            [self.indicatorView stopAnimating];
            [self parseGifImageWithURL:self.url];
        }
    }else{
        [self.animation setKeyTimes:self.gifModel.times];
        [self.animation setValues:self.gifModel.images];
        self.animation.duration = self.gifModel.duration;
        //self.animation.repeatCount= MAXFLOAT;
        //self.animation.autoreverses = YES;
        self.animation.removedOnCompletion = NO;
        self.animation.fillMode = kCAFillModeBoth;
        [self.animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [self.layer addAnimation:self.animation forKey:@"GifAnimation"];
        [self.indicatorView stopAnimating];
    }
    
}

-(void)stopGifAnimating{
    if ([self.layer animationForKey:@"GifAnimation"]) {
        [self.layer removeAnimationForKey:@"GifAnimation"];
    }
}

#pragma mark -- CAAnimationDelegate ---

- (void)animationDidStart:(CAAnimation *)anim{
     NSLog(@"动画启动");
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画停止:%ld",(long)flag);
    if (self.animationCompletedHandler) {
        self.animationCompletedHandler(flag);
    }
    if (flag) {
        [self startGifAnimating];
    }
}

#pragma mark -- private function ---

-(CGImageSourceRef)imageSourceRefWithUrl:(NSURL *)url{
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    return source;
}
// 解析Gif详细信息
-(void)parseGifImageWithURL:(NSString *)url{
    NSURL *URL;
    if ([url hasPrefix:@"http"]) {
       URL = [NSURL URLWithString:url];
    }else{
        URL = [NSURL fileURLWithPath:url];
    }
    if (URL) {
        [self parseGifImageWithSource:[self imageSourceRefWithUrl:URL]];
//        [self performSelector:@selector(parseGifImageWithSource:)
//                   withObject:(__bridge id)[self imageSourceRefWithUrl:URL]
//                   afterDelay:0
//                      inModes:@[
//                                NSDefaultRunLoopMode,
//                                UITrackingRunLoopMode
//                                ]];
    }
}

-(void)parseGifImageWithSource:(CGImageSourceRef)source{
    if (source == nil) return;
    size_t count = CGImageSourceGetCount(source);
    CGFloat duration = 0;
    NSMutableArray *frameTimes = [NSMutableArray array];
    NSMutableArray *times = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    
    for (size_t i=0; i<count; i++){
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        UIImage * newImage = [self thumbnailImage:image size:self.frame.size];
        if (i == 0) {
            self.gifModel.firstFrame  = newImage;
            self.image = newImage;
        }
        [images addObject:(__bridge UIImage *)(newImage.CGImage)];
        
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        CFRelease((__bridge CFTypeRef)(info));
        
        duration+=time;
        [frameTimes addObject:[NSNumber numberWithFloat:time]];
    }
    
    CGFloat currentTime = 0;
    for (int i=0; i<images.count; i++){
        if (duration >0) {
            NSNumber *keyTime = [NSNumber numberWithFloat:currentTime/duration];
            [times addObject:keyTime];
            currentTime += [frameTimes[i] floatValue];
        }
    }
    self.gifModel.times = times.copy;
    self.gifModel.images = images.copy;
    self.gifModel.duration = duration;
    
    if (source){
        CFRelease(source);
    }
    [self startGifAnimating];
}

/** 动画图片 缩放裁剪为指定尺寸 */
- (UIImage *)thumbnailImage:(UIImage *)image size:(CGSize)size {
   
    if (CGSizeEqualToSize(image.size, size) || CGSizeEqualToSize(size, CGSizeZero)) {
        return image;
    }
    
    CGPoint thumbnailPoint = CGPointZero;
    CGSize scaledSize = size;
    
    CGFloat widthFactor = size.width / image.size.width;
    CGFloat heightFactor = size.height / image.size.height;
    
 
    if (self.contentMode == UIViewContentModeScaleAspectFill) {

        CGFloat scaleMaxFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
        scaledSize.width = image.size.width * scaleMaxFactor;
        scaledSize.height = image.size.height * scaleMaxFactor;

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
        }
    } else if (self.contentMode == UIViewContentModeScaleAspectFit){
        CGFloat scaleMinFactor = (widthFactor > heightFactor) ? heightFactor : widthFactor;
        scaledSize.width = image.size.width * scaleMinFactor;
        scaledSize.height = image.size.height * scaleMinFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
        }
    } else {
        //UIViewContentModeScaleToFill
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -- Set,Get Func ---



-(void)setUrl:(NSString *)url{
    _url = url; 
}



#pragma mark -- Lazy Func --

-(CAKeyframeAnimation *)animation{
    if (_animation == nil) {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        _animation.delegate = self;
    }
    return _animation;
}

-(UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_indicatorView startAnimating];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}


@end
