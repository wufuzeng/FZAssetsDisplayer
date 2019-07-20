//
//  FZGifImageView.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FZGifImageView : UIImageView

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSData *data;

@property (nonatomic,copy) void(^animationCompletedHandler)(BOOL finished);

-(void)startGifAnimating;

-(void)stopGifAnimating;

@end

NS_ASSUME_NONNULL_END
