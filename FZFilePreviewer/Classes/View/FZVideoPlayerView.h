//
//  FZVideoPlayerView.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZVideoPlayerView : UIView

@property (nonatomic,strong) NSURL *URL;

@property (nonatomic,copy) void(^playCompletedHandler)(void);

-(void)play;
-(void)stop;

@end

NS_ASSUME_NONNULL_END
