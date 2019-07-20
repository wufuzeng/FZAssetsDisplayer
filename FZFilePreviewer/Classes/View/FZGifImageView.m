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

@property (nonatomic,strong) CAKeyframeAnimation *animation;
@property (nonatomic,assign) CGFloat duration;

@property (nonatomic,strong) NSMutableArray<NSNumber *> *keyTimes;
@property (nonatomic,strong) NSMutableArray<UIImage  *> *images;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *frameTimes;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *widths;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *heights;

@end

@implementation FZGifImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self reset];
    }
    return self;
}

-(void)reset{
    self.duration = 0;
    [self.keyTimes removeAllObjects];
    [self.images removeAllObjects];
    [self.frameTimes removeAllObjects];
    [self.widths removeAllObjects];
    [self.heights removeAllObjects];
}


-(void)startGifAnimating{
    if (self.keyTimes.count == 0 ||
        self.images.count == 0 ||
        self.duration == 0) {
        return;
    }
    [self.animation setKeyTimes:self.keyTimes];
    [self.animation setValues:self.images];
    [self.animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    //self.animation.repeatCount= MAXFLOAT;
    //self.animation.autoreverses = YES;
    self.animation.duration = self.duration;
    self.animation.removedOnCompletion = NO;
    self.animation.fillMode = kCAFillModeBoth;
    
    [self.layer addAnimation:self.animation forKey:@"GifAnimation"];
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

-(CGImageSourceRef)imageSourceRefWithData:(NSData *)data{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    return source;
}

// 解析Gif详细信息
-(void)parseGifImageWithURL:(NSString *)url{
    NSURL *URL = [NSURL URLWithString:url];
    if (URL) {
        [self parseGifImageWithSource:[self imageSourceRefWithUrl:URL]];
    }
}
-(void)parseGifImageWithData:(NSData *)data {
    if (data) {
        [self parseGifImageWithSource:[self imageSourceRefWithData:data]];
    }
}
-(void)parseGifImageWithSource:(CGImageSourceRef)source{
    [self reset];
    size_t count = CGImageSourceGetCount(source);
    CGFloat totalTime = 0;
    for (size_t i=0; i<count; i++){
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [self.images addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        CFRelease((__bridge CFTypeRef)(info));
        
        totalTime+=time;
        
        [self.widths addObject:[NSNumber numberWithFloat:width]];
        [self.heights addObject:[NSNumber numberWithFloat:height]];
        [self.frameTimes addObject:[NSNumber numberWithFloat:time]];
    }
    self.duration = totalTime;
    
    float currentTime = 0;
    for (int i=0; i<self.images.count; i++){
        if (totalTime >0) {
            NSNumber *keyTime = [NSNumber numberWithFloat:currentTime/totalTime];
            [self.keyTimes addObject:keyTime];
            currentTime += [self.frameTimes[i] floatValue];
        }
    }
    if (source){
        CFRelease(source);
    }
    [self startGifAnimating];
}

#pragma mark -- Set,Get Func ---

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    //[self parseGifImageWithData:UIImagePNGRepresentation(image)];
}

-(void)setName:(NSString *)name{
    _name = name;
    if ([UIScreen mainScreen].scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        [self parseGifImageWithData:data];
        if (data) {
            [self parseGifImageWithData:data];
        }else{
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
            data = [NSData dataWithContentsOfFile:path];
            return [self parseGifImageWithData:data];
        }
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self parseGifImageWithData:data];
    }
    
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [self parseGifImageWithURL:url];
}

-(void)setData:(NSData *)data{
    _data = data;
    [self parseGifImageWithData:data];
}

#pragma mark -- Lazy Func --

-(CAKeyframeAnimation *)animation{
    if (_animation == nil) {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        _animation.delegate = self;
    }
    return _animation;
}

-(NSMutableArray<NSNumber *> *)keyTimes{
    if (_keyTimes == nil) {
        _keyTimes = [NSMutableArray array];
    }
    return _keyTimes;
}
-(NSMutableArray<UIImage  *> *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(NSMutableArray<NSNumber *> *)frameTimes{
    if (_frameTimes == nil) {
        _frameTimes = [NSMutableArray array];
    }
    return _frameTimes;
}
-(NSMutableArray<NSNumber *> *)widths{
    if (_widths == nil) {
        _widths = [NSMutableArray array];
    }
    return _widths;
}
-(NSMutableArray<NSNumber *> *)heights{
    if (_heights == nil) {
        _heights = [NSMutableArray array];
    }
    return _heights;
}


@end
