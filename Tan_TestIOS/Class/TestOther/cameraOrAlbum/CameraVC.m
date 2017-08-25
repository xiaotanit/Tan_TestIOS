
//
//  CameraVC.m
//  Tan_TestIOS
//
//  Created by M C on 2017/8/25.
//  Copyright © 2017年 M C. All rights reserved.
//  拍照和相册

#import "CameraVC.h"

@interface CameraVC ()<UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;  //数据源
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIImagePickerController *imgPicker;   //照相机控制器

@end

@implementation CameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArr = [NSMutableArray new];
    [self initSubControls];
}

/* 初始化子控件 */
- (void)initSubControls{
    //1、添加打开相机功能按钮
    UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 20, 80, 30)];
    [cameraBtn setTitle:@"打开相机" forState:UIControlStateNormal];
    cameraBtn.backgroundColor = [UIColor blackColor];
    cameraBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:cameraBtn];
    [cameraBtn addTarget:self action:@selector(openCameara:) forControlEvents:UIControlEventTouchUpInside];
    
    //2、添加打开相册功能
    UIButton *albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(180, 20, 120, 30)];
    [albumBtn setTitle:@"从相册中选择照片" forState:UIControlStateNormal];
    albumBtn.backgroundColor = [UIColor blackColor];
    albumBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:albumBtn];
    [albumBtn addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
    
    //2.2 其他测试按钮
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 100, 120, 30)];
    [testBtn setTitle:@"从相簿中选择照片" forState:UIControlStateNormal];
    testBtn.backgroundColor = [UIColor blackColor];
    testBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:testBtn];
    [testBtn addTarget:self action:@selector(openTest:) forControlEvents:UIControlEventTouchUpInside];
    
    //3、下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraBtn.frame) + 10, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = COLOR_LINE;
    [self.view addSubview:lineView];
    
    //4、UITableView
    CGFloat topY = CGRectGetMaxY(lineView.frame);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topY, SCREEN_WIDTH, SCREEN_HEIGHT - topY)];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    /**
     去掉UITableView的cell的分隔线的方法：
     1、tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        然后在自定义设置一条分隔线
     
     2、self.tableView.tableFooterView = [UIView new];
     3、第一步，设置：self.tableView.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
        第二步，在返回UITableViewCell的代理方法里面设置cell:
        cell.separatorInset = UIEdgeInsetMake(0, 0, 0, 0);
     */
    
    [self.view bringSubviewToFront:testBtn];
}

/* UIScrollView布局子视图 */
- (void)layoutScrollView{
    if (self.dataArr.count < 1) return;
    
    //布局，每行显示4张图片，最外边距15px, 图片之间间距10px  (imgW+imgMargin) *colCount - imgMargin + margin*2=SCREEN_WIDTH
    NSInteger colCount = 4, rowIndex = (self.dataArr.count - 1)/colCount, colIndex = (self.dataArr.count - 1)%colCount;
    float margin = 15, imgMargin = 10, imgW = (SCREEN_WIDTH - margin*2 + imgMargin)/colCount - imgMargin;
    float imgX = margin + colIndex * (imgW + imgMargin), imgY = margin + rowIndex * (imgW + imgMargin);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, imgW, imgW)];
    imgView.image = [self.dataArr lastObject];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self.scrollView addSubview:imgView];
    
    CGFloat lastImgY = CGRectGetMaxY(imgView.frame);
    CGFloat scrollViewH = self.scrollView.bounds.size.height;
    if (lastImgY > scrollViewH){
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, lastImgY);
    }
}

#pragma mark - private methods
/* 打开相机功能 */
- (void)openCameara:(UIButton *)sender{
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

/* 打开相册 */
- (void)openAlbum:(UIButton *)sender{
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //从照片库里面打开相册
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

/* 打开其他 */
- (void)openTest:(UIButton *)sender{
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //从相簿里面打开照片
    [self presentViewController:self.imgPicker animated:YES completion:nil];
}

- (UIImagePickerController *)imgPicker{
    if (_imgPicker == nil){
        _imgPicker = [UIImagePickerController new];
        _imgPicker.delegate = self;
//        _imgPicker.allowsEditing = YES;  //是否允许编辑
        _imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        /*
         UIImagePickerControllerSourceTypePhotoLibrary, //照片库
         UIImagePickerControllerSourceTypeCamera,   //相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum  //保存的照片
         */
    }
    return _imgPicker;
}

#pragma mark - UIImageViewPickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@".......1111111.....");
    NSLog(@"image: %@", image);
    NSLog(@"editinginfo: %@", editingInfo);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@".....22222222....");
    NSLog(@"info: %@", info);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]){
        UIImage *imgOri = info[@"UIImagePickerControllerOriginalImage"];
        
        if (imgOri){
            [self.dataArr addObject:imgOri];
            [self layoutScrollView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
