//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Kurt Walker on 7/12/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRDateChangerViewController.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)dateButton:(UIButton *)sender;

@end

@implementation BNRDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    // The contentMode of the image view in the XIB was Aspect Fit:
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // The image view was a subclass of the view
    [self.view addSubview:iv];
    
    // The image view was pointed to by the imageView property
    self.imageView = iv;
    
    // Set the vertical priorities to be less than those of the other subviews
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisHorizontal];
    
    NSDictionary *nameMap = @{@"imageView" : self.imageView,
                              @"dateLabel" : self.dateLabel,
                              @"toolbar" : self.toolbar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    
    // imageView is 8 pts from dateLabel at its top edge and 8 pts from toolbar at its bottom edge
    NSArray *verticleConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticleConstraints];
}


- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise, just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    
    self.serialNumberField.text = item.serialNumber;

    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    // You need a NSDateFormatter that will turn a date into a simple date string
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    // Use filtered NSDATE object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate: item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    
    // Get the image for its image key from the image store
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
    
    // Use that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    //Get picked image from info dictionary
    if (info[UIImagePickerControllerEditedImage]) {
        image = info[UIImagePickerControllerEditedImage];
    }
    else {
    image = info[UIImagePickerControllerOriginalImage];
    }
    
    // Store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take image picker off the screen - you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameField resignFirstResponder];
    [self.serialNumberField resignFirstResponder];
    [self.valueField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)dateButton:(UIButton *)sender
{
    BNRDateChangerViewController *dateController = [[BNRDateChangerViewController alloc] init];
    
    dateController.item = self.item;
    
    [self.navigationController pushViewController:dateController animated:YES];
}

- (IBAction)deleteImage:(id)sender
{
    [[BNRImageStore sharedStore] deleteImageForKey:self.item.itemKey];
    self.imageView.image = nil;
}

@end
