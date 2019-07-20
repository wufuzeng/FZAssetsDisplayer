//
//  FZVideoPlayerView.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import "FZVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>


@interface FZVideoPlayerView ()

@property (nonatomic,strong) id playerObserve;

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@end

@implementation FZVideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.playerLayer.frame = nFrame;
        
        
        
        [self reset];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver];
}

-(void)reset{
    [self addObserver];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];
}

-(void)addObserver{
    [self addObserver:self forKeyPath:@"playerItem.status" options:NSKeyValueObservingOptionNew context:nil];
    __weak __typeof(self) weakSelf = self;
    self.playerObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                           queue:dispatch_get_main_queue()
                                                      usingBlock:^(CMTime time) {
                                                   
      AVPlayerItem *item = weakSelf.playerItem;
      __unused NSTimeInterval currentTime = item.currentTime.value/item.currentTime.timescale;
      __unused NSTimeInterval totalSecond = item.duration.timescale ? item.duration.value / weakSelf.playerItem.duration.timescale : 0;
                                                          
      if (CMTimeGetSeconds(time) >= totalSecond) {
          [weakSelf.player seekToTime:kCMTimeZero];
      } else {
           //更新进度条
      }
  }];
}

-(void)removeObserver{
    [self removeObserver:self forKeyPath:@"playerItem.status"];
    [self.player removeTimeObserver:self.playerObserve];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        if ([keyPath isEqualToString:@"status"]) {
            switch (_playerItem.status) {
                case AVPlayerItemStatusReadyToPlay:
                    //推荐将视频播放放在这里
                    [self.player play];
                    break;
                    
                case AVPlayerItemStatusUnknown:
                    NSLog(@"AVPlayerItemStatusUnknown");
                    break;
                case AVPlayerItemStatusFailed:
                    NSLog(@"AVPlayerItemStatusFailed");
                    break;
                default:
                    break;
            }
        }
    }
}
    





-(void)play{
    if (self.URL) {
        self.playerItem = [[AVPlayerItem alloc] initWithURL:self.URL];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.player play];
    }
}

-(void)stop{
    [self.player pause];
    [self.playerItem cancelPendingSeeks];
    [self.playerItem.asset cancelLoading];
    self.playerItem = nil;
}


#pragma mark -- Set,Get Func ---

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    self.playerLayer.frame = nFrame;
}
 
#pragma mark -- Lazy Func --


-(AVPlayer *)player{
    if (_player == nil) {
        _player = [AVPlayer new];
    }
    return _player;
}

-(AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:_playerLayer];
    }
    return _playerLayer;
}


@end
