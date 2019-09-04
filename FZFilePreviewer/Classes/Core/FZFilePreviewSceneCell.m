//
//  FZFilePreviewSceneCell.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import "FZFilePreviewSceneCell.h"

#import <CoreMotion/CoreMotion.h>

#import "FZFilePreviewerBundle.h"
@interface FZFilePreviewSceneCell ()
/** 小菊花 */
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIImageView *imageIcon;
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

@property (nonatomic,strong) FZFilePreviewSceneModel *sceneModel;

@end

@implementation FZFilePreviewSceneCell

-(void)configWithModel:(FZFilePreviewModel *)model{
    self.imageView.contentMode = model.contentMode;
    self.sceneModel = model.sceneModel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.imageView.frame = nFrame;
        [self reset];
        [self setupViews];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    
    CGRect rectIcon = CGRectMake(
                                 CGRectGetWidth(self.frame)-40-20,
                                 CGRectGetHeight(self.frame)-40-20,
                                 40,
                                 40);
    self.imageIcon.frame = rectIcon;
    
}

-(void)reset{
    self.maxRollRange = 0.3;
    self.currentRoll  = 0;
    self.currentIndex = -1;
    self.imageView.image = nil;
}

-(void)setupViews{
    [self imageView];
    [self imageIcon];
}

- (void)dealloc{
    [self stopWaggle];
}

#pragma mark -- Download Func ----
-(void)downloadImagesWithUrls:(NSArray *)urls{
    NSMutableArray *images = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < urls.count; i++) {
        NSString *imageUrlStr = urls[i];
        dispatch_group_enter(group);
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSError *error;
            NSData *responseData = [NSData dataWithContentsOfURL:url
                                                         options:NSDataReadingMappedIfSafe
                                                           error:&error];
            UIImage * image = [UIImage imageWithData:responseData];
            if (error == nil && image != nil) {
                images[i] = image;
            }
            dispatch_group_leave(group);
        });
      
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (images.count != urls.count) {
            return;
        }
        if (images.count % 2 == 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:images];
            if (images.lastObject) {
                [temp addObject:images.lastObject];
            }
            self.sceneModel.images = temp.copy;
        }else{
            self.sceneModel.images = images;
        }
        NSInteger index = [self indexOfRoll:self.currentRoll];
        [self setImageViewImageWithIndex:index];
        [self startWaggle];
    });
    
    
}

#pragma mark -- Custom Func ----


- (void)startWaggle{
    if (self.motionManager.isDeviceMotionAvailable == NO || self.isWaggling) return;
    
    if(self.sceneModel.images.count == 0 && self.sceneModel.links.count ){
        [self.indicatorView startAnimating];
        [self downloadImagesWithUrls:self.sceneModel.links];
    }else {
        [self.indicatorView stopAnimating];
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
    if (self.sceneModel.images.count == 0) {
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
    NSInteger index = index = lround(percent * (self.sceneModel.images.count - 1));
    return index;
}

-(void)setImageViewImageWithIndex:(NSInteger)index{
    UIImage *image = index< self.sceneModel.images.count ? self.sceneModel.images[index] : nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
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

-(UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_indicatorView startAnimating];
        [self.imageView addSubview:_indicatorView];
    }
    return _indicatorView;
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

-(UIImageView *)imageIcon{
    if (_imageIcon == nil) {
        _imageIcon = [UIImageView new];
        _imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _imageIcon.image = [FZFilePreviewerBundle fz_imageNamed:@"shake"];
        [self.contentView addSubview:_imageIcon];
    }
    return _imageIcon;
}

@end
