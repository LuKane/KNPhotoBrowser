//
//  IMTableViewCell.m
//  KNPhotoBrowser
//
//  Created by LuKane on 2019/2/1.
//  Copyright © 2019 LuKane. All rights reserved.
//

#import "IMTableViewCell.h"
#import "IMModel.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Extension.h"
#import <Photos/Photos.h>

@interface IMTableViewCell()

@property (nonatomic,weak  ) UIImageView *iconView;

@end

@implementation IMTableViewCell

+ (instancetype)imTableViewCellWithTableView:(UITableView *)tableView{
    static NSString *const ID = @"IMTableViewCell";
    IMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[IMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:(CGRect){{20,20},{50,50}}];
    iconView.layer.cornerRadius = iconView.frame.size.height * 0.5;
    iconView.layer.borderColor = [UIColor cyanColor].CGColor;
    iconView.layer.borderWidth = 0.4;
    _iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UIImageView *picImgView = [[UIImageView alloc] initWithFrame:(CGRect){{CGRectGetMaxX(iconView.frame) + 20,20},{100,100}}];
    picImgView.userInteractionEnabled = true;
    [picImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action: @selector(imageViewDidClick)]];
    picImgView.backgroundColor = [UIColor greenColor];
    _picImgView = picImgView;
    [self.contentView addSubview:picImgView];
}

- (void)setImModel:(IMModel *)imModel{
    _imModel = imModel;
    
    if(imModel.isLeft){
        _iconView.frame = CGRectMake(20, 20, 50, 50);
        _iconView.backgroundColor = [UIColor orangeColor];
    }else{
        _iconView.frame = CGRectMake(ScreenWidth - 20 - 50, 20, 50, 50);
        _iconView.backgroundColor = [UIColor lightGrayColor];
    }
    
    __block CGRect rect = _picImgView.frame;
    rect.size = CGSizeMake(100, 100);
    _picImgView.frame = rect;
    
    if(imModel.url){
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:imModel.url];
        if(image && imModel.isVideo == false ){
            if(image.size.width >= image.size.height){ // 横图
                rect.size = CGSizeMake(100, image.size.height * 100 / image.size.width);
                _picImgView.frame = rect;
            }else{ // 竖图
                rect.size = CGSizeMake(image.size.width * 100 / image.size.height, 100);
                _picImgView.frame = rect;
            }
            if(imModel.isLeft){
                _picImgView.x = CGRectGetMaxX(_iconView.frame) + 20;
            }else{
                _picImgView.x = ScreenWidth - 40 - rect.size.width - 50;
            }
            imModel.cellHeight = CGRectGetMaxY(self->_picImgView.frame) + 20;
            _picImgView.image = image;
        }else{
            if (imModel.isVideo) {
                if(imModel.isLeft){
                    self->_picImgView.x = CGRectGetMaxX(self->_iconView.frame) + 20;
                }else{
                    self->_picImgView.x = ScreenWidth - 40 - rect.size.width - 50;
                }
                if (imModel.rate > 1) { // 横图
                    self.picImgView.size = CGSizeMake(100 * imModel.rate, 100);
                }else{ // 竖图 || 正方形
                    self.picImgView.size = CGSizeMake(100, 100 / imModel.rate);
                }
                imModel.cellHeight = CGRectGetMaxY(_picImgView.frame) + 20;
                
                AVURLAsset *avAsset = nil;
                if ([imModel.url hasPrefix:@"http"]) {
                    avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:imModel.url]];
                    if (avAsset) {
                        CGFloat padding = 5, imageViewLength = ([UIScreen mainScreen].bounds.size.width - padding * 2) / 3 - 10, scale = [UIScreen mainScreen].scale;
                        CGSize imageViewSize = CGSizeMake(imageViewLength * scale, imageViewLength * scale);
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                            generator.appliesPreferredTrackTransform = YES;
                            generator.maximumSize = imageViewSize;
                            NSError *error = nil;
                            CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self->_picImgView.image = [UIImage imageWithCGImage:cgImage];
                            });
                        });
                    }
                }else{
                    avAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:imModel.url]];
                    if (avAsset) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
                            generator.appliesPreferredTrackTransform = YES;
                            NSError *error = nil;
                            CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:NULL error:&error];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self->_picImgView.image = [UIImage imageWithCGImage:cgImage];
                            });
                        });
                    }
                }
            }else{
                [_picImgView sd_setImageWithURL:[NSURL URLWithString:imModel.url] placeholderImage:[self createImageWithUIColor:[UIColor lightGrayColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if(!error && image){
                        if(image.size.width >= image.size.height){ // 横图
                            rect.size = CGSizeMake(100, image.size.height * 100 / image.size.width);
                            self->_picImgView.frame = rect;
                        }else{ // 竖图
                            rect.size = CGSizeMake(image.size.width * 100 / image.size.height, 100);
                            self->_picImgView.frame = rect;
                        }
                        
                        if(imModel.isLeft){
                            self->_picImgView.x = CGRectGetMaxX(self->_iconView.frame) + 20;
                        }else{
                            self->_picImgView.x = ScreenWidth - 40 - rect.size.width - 50;
                        }
                        
                        imModel.cellHeight = CGRectGetMaxY(self->_iconView.frame) + 20;
                        
                        if([self->_delegate respondsToSelector:@selector(reloadCellWithModel:)]){
                            [self->_delegate reloadCellWithModel:imModel];
                        }
                    }
                }];
            }
        }
    }else if(imModel.locImage){
        _picImgView.image = imModel.locImage;
        if(imModel.locImage.size.width >= imModel.locImage.size.height){ // 横图
            rect.size = CGSizeMake(100, imModel.locImage.size.height * 100 / imModel.locImage.size.width);
            _picImgView.frame = rect;
        }else{ // 竖图
            rect.size = CGSizeMake(imModel.locImage.size.width * 100 / imModel.locImage.size.height, 100);
            _picImgView.frame = rect;
        }
        
        if(imModel.isLeft){
            _picImgView.x = CGRectGetMaxX(self->_iconView.frame) + 20;
        }else{
            _picImgView.x = ScreenWidth - 40 - rect.size.width - 50;
        }
        
        imModel.cellHeight = CGRectGetMaxY(self->_picImgView.frame) + 20;
    }
}

- (UIImage *)createImageWithUIColor:(UIColor *)imageColor{
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)imageViewDidClick{
    if ([_delegate respondsToSelector:@selector(imImageViewDidClick:)]) {
        [_delegate imImageViewDidClick:_imModel];
    }
}

@end
