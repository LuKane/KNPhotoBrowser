//
//  AddImageViewController.m
//  KNPhotoBrowser
//
//  Created by jmcl on 2020/10/14.
//  Copyright © 2020 LuKane. All rights reserved.
//

#import "AddImageViewController.h"
#import "QYPersonalCenterAlbumCell.h"
#import "ImageModel.h"


#import <TZImagePickerController.h>
#import <Photos/Photos.h>
#import "KNPhotoBrowser.h"

#import "KNAnimatedImage.h"
#import "KNAnimatedImageView.h"

#import "SDAnimatedImage.h"


@interface AddImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *datas;
@end

@implementation AddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.bounds;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count + 1;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QYPersonalCenterAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    if (indexPath.row == 0 || self.datas.count == 0) {
        cell.isHiddenAddIcon = NO;
        cell.imageIconView.hidden = YES;
    }else{
        ImageModel *model = self.datas[indexPath.row -1];
        cell.isHiddenAddIcon = YES;
        cell.imageIconView.hidden = NO;
        cell.imageIconView.image = model.image;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 || self.datas.count == 0) {
        [self showPickerViewWithImageMaxCount:1 allowImage:YES allowGif:YES allowVideo:YES];
    }else{
        [self mediaBrowserWithDatas:self.datas selectIndex:indexPath.row -1];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return  CGSizeMake(70, 70);
}

-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[QYPersonalCenterAlbumCell class] forCellWithReuseIdentifier:@"cellid"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}


#pragma mark--图片选择器
- (void)showPickerViewWithImageMaxCount:(NSInteger)maxCount
                             allowImage:(BOOL)allowImage
                               allowGif:(BOOL)allowGif
                             allowVideo:(BOOL)allowVideo{
    
    
    
    TZImagePickerController *pickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount
                                                                                        columnNumber:3
                                                                                            delegate:nil];

    pickerVc.allowPickingImage = allowImage;
    pickerVc.allowPickingVideo = allowVideo;
    pickerVc.allowPickingGif   = allowGif;
    pickerVc.videoMaximumDuration = 30;
    pickerVc.sortAscendingByModificationDate = NO;
    
    pickerVc.allowPickingOriginalPhoto = NO;
    pickerVc.isSelectOriginalPhoto = YES;
    
    pickerVc.iconThemeColor = UIColor.blackColor;
    pickerVc.oKButtonTitleColorNormal = UIColor.blackColor;
    pickerVc.oKButtonTitleColorDisabled = UIColor.blackColor;

    ///预览普通图片时，改变Done颜色
    pickerVc.photoPreviewPageDidRefreshStateBlock = ^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
        [doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    };
    
    ///预览gif时，改变Done颜色
    pickerVc.gifPreviewPageDidLayoutSubviewsBlock = ^(UIView *toolBar, UIButton *doneButton) {
        [doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    };
    
    ///预览video时，改变Done颜色
    pickerVc.videoPreviewPageUIConfigBlock = ^(UIButton *playButton, UIView *toolBar, UIButton *doneButton) {
        [doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    };
    
    
    
    pickerVc.showSelectedIndex = YES;

    
    __weak __typeof(self) ws = self;
    pickerVc.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos,
                                                            NSArray *assets,
                                                            BOOL isSelectOriginalPhoto,
                                                            NSArray<NSDictionary *> *infos) {

        for (UIImage *image in photos) {
            ImageModel *model = [ImageModel new];
            model.image = image;
            model.type = 1;
            [ws.datas addObject:model];
        }
        [ws.collectionView reloadData];
    };
    //选择gif
    pickerVc.didFinishPickingGifImageHandle = ^(UIImage *animatedImage, id sourceAssets) {

        if ([sourceAssets isMemberOfClass:[PHAsset class]]) {
            
            PHAsset *asset = (PHAsset *)sourceAssets;
            if (asset.mediaType == PHAssetMediaTypeImage)
            {
                [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {

                    ImageModel *model = [ImageModel new];
                    model.image = animatedImage;
                    model.type = 2;
                    model.path = contentEditingInput.fullSizeImageURL.relativePath;;
                    [ws.datas addObject:model];
                    
                    [ws.collectionView reloadData];
                    
                }];
            }
        }
        
        
    };
    //选择视频
    pickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {

        [[TZImageManager manager] getVideoOutputPathWithAsset:asset
                                                   presetName:AVAssetExportPresetMediumQuality
                                                      success:^(NSString *outputPath) {
            
            ImageModel *model = [ImageModel new];
            model.path = outputPath;
            model.image = coverImage;
            model.type = 3;
            [ws.datas addObject:model];
            
            [ws.collectionView reloadData];
            
        } failure:^(NSString *errorMessage, NSError *error) {
   
            NSLog(@"视频导出失败");
        }];
    };

    pickerVc.naviBgColor = UIColor.whiteColor;
    pickerVc.statusBarStyle = UIStatusBarStyleDefault;
    pickerVc.naviTitleColor = UIColor.blackColor;
    pickerVc.barItemTextColor = UIColor.redColor;
    pickerVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:pickerVc animated:YES completion:nil];
}



#pragma mark--KN
-(void)mediaBrowserWithDatas:(NSArray *)datas selectIndex:(NSInteger)selectIndex{
    
    NSMutableArray *itemArr = [NSMutableArray array];
    for (ImageModel *obj in datas) {
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
   
        if (obj.type == 3) {
            items.url = obj.path;
            items.isVideo = YES;
        }else if (obj.type == 2){
            
//            NSData *data = [NSData dataWithContentsOfFile:obj.path];
//            SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:data];
//            items.sourceImage = animatedImage;
            
            items.sourceImage = obj.image;
            items.isLocateGif = YES;
        }else{
            items.sourceImage = (SDAnimatedImage *)obj.image;
        }
        [itemArr addObject:items];
    }

    KNPhotoBrowser *photoBrowser = [self creatPhotoBrowser];
    photoBrowser.itemsArr = itemArr;
    photoBrowser.currentIndex = selectIndex;
    [photoBrowser present];
   
}

-(KNPhotoBrowser *)creatPhotoBrowser{
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.isNeedRightTopBtn = NO;///隐藏自带的，使用自定义的rightButton
    photoBrowser.isNeedPageNumView = YES;
    photoBrowser.isNeedAutoPlay = YES;
    photoBrowser.isNeedPictureLongPress = YES;
    photoBrowser.isNeedPanGesture = YES;
    photoBrowser.isNeedPrefetch = YES;
    return photoBrowser;
}
@end
