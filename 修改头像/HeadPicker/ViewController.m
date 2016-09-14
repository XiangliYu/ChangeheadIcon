//
//  ViewController.m
//  HeadPicker
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 LoveSpending. All rights reserved.
//

#import "ViewController.h"
#import "NSString.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong) UIImageView *pic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pic = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, 100, 100))];
    self.pic.center = CGPointMake(s_v_width/2, 200);
    self.pic.userInteractionEnabled = YES;
    
    //加载首先访问本地沙盒是否存在相关图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headIcon.jpg"];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    
    if (!savedImage){
        //默认头像
        self.pic.image = [UIImage imageNamed:@"icon_head"];
    }else{
        //本地缓存头像
        self.pic.image = savedImage;
    }

    [self.view addSubview:self.pic];
    
    UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picAction:)];
    [self.pic addGestureRecognizer:picTap];
}

//图片点击动作
- (void)picAction:(UITapGestureRecognizer *)sender{
    
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //通过相册（呈现全部相册）
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.pic.image = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //保存头像到本地
    [self saveImage:newPhoto withName:@"headIcon.jpg"];
}

#pragma mark - 保存图片至本地沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
