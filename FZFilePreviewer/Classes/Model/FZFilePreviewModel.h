//
//  FZFilePreviewModel.h
//  FZFilePreviewer
//
//  Created by 吴福增 on 2019/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FZFilePreviewType) {
    FZFilePreviewTypePicture,
    FZFilePreviewTypeGif,
    FZFilePreviewTypeScene,
    FZFilePreviewTypeLive,//暂未实现
    FZFilePreviewTypeVideo
};

@class FZFilePreviewPicModel;
@class FZFilePreviewGifModel;
@class FZFilePreviewSceneModel;

@interface FZFilePreviewModel : NSObject

@property (nonatomic,assign) FZFilePreviewType fileType;

@property (nonatomic,strong) NSString *link;

@property (nonatomic,assign) UIViewContentMode contentMode;

@property (nonatomic,strong) FZFilePreviewPicModel *picModel;
@property (nonatomic,strong) FZFilePreviewGifModel *gifModel;
@property (nonatomic,strong) FZFilePreviewSceneModel *sceneModel;
@end

@interface FZFilePreviewPicModel : NSObject

@property (nonatomic,strong) UIImage *image;

@end

@interface FZFilePreviewGifModel : NSObject

@property (nonatomic,strong) UIImage *firstFrame;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,strong) NSArray *times;
@property (nonatomic,strong) NSArray *images;

@end

@interface FZFilePreviewSceneModel : NSObject

@property (nonatomic,strong) NSArray<NSString *> *links;

@property (nonatomic,strong) NSArray<UIImage *> *images;

@end

NS_ASSUME_NONNULL_END
