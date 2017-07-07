//
//  ZQPhotoModelEditorViewController.m
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/7.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "ZQPhotoModelEditorViewController.h"
#import <Masonry/Masonry.h>

@interface ZQPhotoModelEditorViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZQPhotoModelEditorViewCell

+ (CGFloat)defaultHeight
{
    return 80;
}

- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame]) {
        self.photoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            
            [self.contentView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.centerY.offset(0);
                make.left.offset(15);
            }];
            
            imageView;
        });
        
        self.textField = ({
            UITextField *textField = [UITextField new];
            
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.returnKeyType = UIReturnKeyDone;
            textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 28)];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [self.contentView addSubview:textField];
            
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.photoImageView.mas_right).offset(20);
                make.width.equalTo(@60);
                make.centerY.offset(0);
            }];
            
            textField;
        });
    }
    return self;
}

@end

@interface ZQPhotoModelEditorViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZQPhotoModelEditorViewController

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"choose" style:UIBarButtonItemStylePlain target:self action:@selector(onChoose:)];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.view addSubview:tableView];
        
        [tableView registerClass:ZQPhotoModelEditorViewCell.class forCellReuseIdentifier:@"ZQPhotoModelEditorViewCell"];
        
        tableView;
    });
}

- (void)onChoose:(id)sender
{
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQPhotoModelEditorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQPhotoModelEditorViewCell" forIndexPath:indexPath];
    
    ZQPhotoDurationModel *model = self.photoModels[indexPath.row];
    
    cell.textField.text = [NSString stringWithFormat:@"%lf", model.duration];
    
    cell.photoImageView.image = model.image;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZQPhotoModelEditorViewCell defaultHeight];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

@end
