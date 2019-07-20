//
//  FZFilePreviewSceneCell.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import "FZFilePreviewSceneCell.h"

#import <CoreMotion/CoreMotion.h>

@interface FZFilePreviewSceneCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSOperationQueue *deviceMotionQueue;
@property (nonatomic,strong) CMMotionManager *motionManager;

@property (nonatomic,assign) NSInteger currentIndex;
/** 最大摆动范围 */
@property (nonatomic,assign) double maxRollRange;
/** -0.3 0.3 */
@property (nonatomic,assign) double currentRoll;
/** 是否在摆动 */
@property (nonatomic,assign) BOOL isWaggling;

@end

@implementation FZFilePreviewSceneCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.imageView.frame = nFrame;
        [self reset];
        [self setupViews];
    }
    return self;
}

-(void)reset{
    self.maxRollRange = 0.3;
    self.currentRoll  = 0;
    self.currentIndex = -1;
    self.imageView.image = nil;
}

-(void)setupViews{
    [self imageView];
}

- (void)dealloc{
    [self stopWaggle];
}


#pragma mark -- Custom Func ----


- (void)startWaggle{
    if(self.motionManager.isDeviceMotionAvailable == NO ||
       self.isWaggling == YES ||
       self.images.count == 0 ||
        self.images.count == 1){
        return;
    } else {
        self.isWaggling = YES;
        self.motionManager.deviceMotionUpdateInterval = 0.01;
        __weak __typeof(self) weakSelf = self;
        [self.motionManager startDeviceMotionUpdatesToQueue:self.deviceMotionQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error == nil) {
                double roll = motion.attitude.roll;
                weakSelf.currentRoll = roll;
                NSInteger index = [ weakSelf indexOfRoll:roll];
                weakSelf.currentIndex = index;
                [weakSelf setImageViewImageWithIndex:index];
            }
        }];
    }
}

- (void)stopWaggle{
    if (self.isWaggling == NO) {
        return;
    }else{
        [self.motionManager stopDeviceMotionUpdates];
        [self.deviceMotionQueue cancelAllOperations];
        self.isWaggling = NO;
    }
}

- (NSInteger)indexOfRoll:(double)roll{
    if (self.images.count == 0) {
        return -1;
    }
    if (roll > self.maxRollRange) {
        roll = self.maxRollRange;
    }
    if (roll < -1 * self.maxRollRange) {
        roll = -1 * self.maxRollRange;
    }
    //百分比
    double percent = (roll + self.maxRollRange) / (2.0 * self.maxRollRange);
    //索引
    NSInteger index = index = lround(percent * (self.images.count - 1));
    return index;
}

-(void)setImageViewImageWithIndex:(NSInteger)index{
    UIImage *image = index< self.images.count ? self.images[index] : nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}

#pragma mark -- Set,Get Func ---

- (void)setImages:(NSArray *)images{
    [self stopWaggle];
    [self reset];
    
    if (images.count % 2 == 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:images];
        if (images.lastObject) {
            [temp addObject:images.lastObject];
        }
        _images = temp.copy;
    }else{
        _images = images;
    }
    NSInteger index = [self indexOfRoll:self.currentRoll];
    [self setImageViewImageWithIndex:index];
    [self startWaggle];
}

#pragma mark -- Lazy Func --

-(CMMotionManager *)motionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc]init];
    }
    return _motionManager;
}

- (NSOperationQueue *)deviceMotionQueue{
    if (_deviceMotionQueue == nil) {
        _deviceMotionQueue = [[NSOperationQueue alloc]init];
    }
    return _deviceMotionQueue;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}


@end
