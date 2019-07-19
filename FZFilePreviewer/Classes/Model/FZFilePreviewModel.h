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
    FZFilePreviewTypeLive,
    FZFilePreviewTypeVideo
};

@interface FZFilePreviewModel : NSObject

@property (nonatomic,assign) FZFilePreviewType fileType;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) NSString *videoUrl;

@property (nonatomic,strong) UIImage *image;


@end

NS_ASSUME_NONNULL_END
