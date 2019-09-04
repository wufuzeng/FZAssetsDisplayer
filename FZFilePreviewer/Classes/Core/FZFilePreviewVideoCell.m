//
//  FZFilePreviewVideoCell.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import "FZFilePreviewVideoCell.h"

#import "FZVideoPlayerView.h"
#import "FZAVPlayer.h"
@interface FZFilePreviewVideoCell ()

@property (nonatomic,strong) FZAVPlayerView *playerView;

@end

@implementation FZFilePreviewVideoCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.playerView.frame = nFrame;
        [self setupViews];
    }
    return self;
}

#pragma mark -- UI ----


 
-(void)setupViews{
    
}

-(void)startPlay{
    
    [self.playerView resume];
    
}

-(void)stopPlay{
    [self.playerView pause];
}


#pragma mark -- Set,Get Func ---

-(void)setUrl:(NSString *)url {
    _url = url;
    if (url) {
        NSURL *URL = nil;
        if ([url hasPrefix:@"http"]) {
            URL = [NSURL URLWithString:url];
        }else{
            URL = [NSURL fileURLWithPath:url];
        }
        if (URL) {
            [self.playerView playWithUrl:URL];
        }
    } 
}

-(void)setContentMode:(UIViewContentMode)contentMode{
    [super setContentMode:contentMode];
    if (contentMode = UIViewContentModeScaleAspectFill) {
        self.playerView.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
}

#pragma mark -- Lazy Func --

-(FZAVPlayerView *)playerView{
    if (_playerView == nil) {
        _playerView = [FZAVPlayerView new];
        _playerView.showControlView = YES;
        _playerView.showTitleBar = NO;
        _playerView.showBackBtn = NO;
        _playerView.autoReplay = YES;
        _playerView.disableFullScreen = YES;
        _playerView.disableAdjustBrightnessOrVolume = YES;
        _playerView.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerView.showInView = self;
    }
    return _playerView;
}

@end
