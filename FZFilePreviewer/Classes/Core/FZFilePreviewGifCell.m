//
//  FZFilePreviewGifCell.m
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import "FZFilePreviewGifCell.h"



@interface FZFilePreviewGifCell ()



@end

@implementation FZFilePreviewGifCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect nFrame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.gifImageView.frame = nFrame;
        [self setupViews];
    }
    return self;
}

#pragma mark -- UI ----
-(void)setupViews{
    [self gifImageView];
}
 


#pragma mark -- Lazy Func --

-(FZGifImageView *)gifImageView{
    if (_gifImageView == nil) {
        _gifImageView = [[FZGifImageView alloc]init];
        [self.contentView addSubview:_gifImageView];
    }
    return _gifImageView;
}

@end
