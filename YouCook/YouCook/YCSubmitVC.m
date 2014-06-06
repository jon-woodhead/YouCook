//
//  YCSubmit.m
//  YouCook
//
//  Created by Jon Woodhead on 18/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCSubmitVC.h"

#import "YCRecipeVC.h"
#import "UIImagePickerController+OrientationFix.h"
#import "YCImageUploadService.h"



#define kCameraShift 100


@interface YCSubmitVC(){
    
  
    YCImageUploadService *uploadService;
}
@end
@implementation YCSubmitVC


-(void)viewDidLoad{
    [self checkIfShouldShowCopyrightWarning];
    [_ai startAnimating];
    
    if (! _recipe){
        _recipe = [YCRecipe new];
        [_recipe.ingredients addObject:kNewIngredient];
        _ai.hidden = YES;
    }
    else
        [self configureWithRecipe];
    
    [_ingredients setEditing:YES animated:NO];
    
    _previewBtn = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(preview:)];
    self.navigationItem.rightBarButtonItem = _previewBtn;
    
    
    self.photoBtn.enabled = [UIImagePickerController isSourceTypeAvailable:
                             UIImagePickerControllerSourceTypeCamera];
    
    
    //set up the placeholder text
    if ([_outline.text isEqualToString:@""]) _outline.text = kOutlinePlaceholder;
    if ([_instructions.text isEqualToString:@""]) _instructions.text = kInstructionsPlaceholder;
    
    
    //get a notification if the keyboard is shown or not
    //so we can shift the view up if necessary
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //add a border around the textViews
    _outline.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _outline.layer.borderWidth = 1.0;
    _outline.layer.cornerRadius = 8;
    _instructions.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _instructions.layer.borderWidth = 1.0;
    _instructions.layer.cornerRadius = 8;
}
-(void)setRecipe:(YCRecipe *)recipe{
    _recipe = recipe;
    [self configureWithRecipe];
}
-(void)configureWithRecipe{
    _recipeTitle.text = _recipe.title;
    _outline.text = _recipe.outline;
    _chef.text = _recipe.chef;
    _instructions.text = _recipe.instructions;
    [_ingredients reloadData];
    _ai.hidden = YES;
    _photo.image = _recipe.photo;
}

#pragma mark - ingredient table delegate calls
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SubmitCell";
    static NSString * CellNib = @"YCSubmitCell";
    YCSubmitCell *cell = (YCSubmitCell *)[_ingredients dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (YCSubmitCell *)[nib objectAtIndex:0];
        cell.editingDelegate = self;
    }
    NSUInteger row =[indexPath row];
    //NSString *ing = _recipe.ingredients[row];
    [cell displayDataForRecipe:_recipe onRow:row];
    cell.row = row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recipe.ingredients.count;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _recipe.ingredients.count-1) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleInsert){
        [_recipe.ingredients addObject:kNewIngredient];
        [tableView reloadData];
    }
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [_recipe.ingredients removeObjectAtIndex:indexPath.row];
        NSArray *paths = @[indexPath];
        [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"");
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _recipe.ingredients.count -1) // Don't move the last row
        return NO;
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *stringToMove = [_recipe.ingredients objectAtIndex:sourceIndexPath.row];
    [_recipe.ingredients removeObjectAtIndex:sourceIndexPath.row];
    [_recipe.ingredients insertObject:stringToMove atIndex:destinationIndexPath.row];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSUInteger row = proposedDestinationIndexPath.row;
    if (row < _recipe.ingredients.count -1) return proposedDestinationIndexPath;
    else
        return [NSIndexPath indexPathForRow:_recipe.ingredients.count -2 inSection:sourceIndexPath.section];
}


-(void)preview:(id)sender{
    [self updateRecipe];
    YCRecipeVC *recipeVC = [YCRecipeVC new];
    recipeVC.recipe = self.recipe;
    [self.navigationController pushViewController:recipeVC animated:YES];
    
}
-(void)updateRecipe{
    _recipe.title = _recipeTitle.text;
    _recipe.chef = _chef.text;
    _recipe.outline = _outline.text;
    _recipe.instructions = _instructions.text;
    YCUserData *user = [self userData];
    _recipe.chefCode = [user getUUID];
    //no need to set the ingredients here, they have been updated as we've gone along
    if (_newPhoto) [_recipe makeURL];
}

-(YCUserData*)userData{
    if (_userData) return _userData;
    else _userData =  [YCUserData new];
    return _userData;
}
#pragma mark - submission process
-(IBAction)submit:(id)sender{
    //check whether all the required data is in place
    if ([_recipeTitle.text isEqualToString:@""])
        [self submissionAlert:NSLocalizedString(@"SUBMIT_NO_TITLE", @"No title")];
    else if ([_chef.text isEqualToString:@""])
        [self submissionAlert:NSLocalizedString(@"SUBMIT_NO_CHEF", @"No user name")];
    else if ([_outline.text isEqualToString:@"Brief Description"])
        [self submissionAlert:NSLocalizedString(@"SUBMIT_NO_OUTLINE", @"No description")];
    else if ([_instructions.text isEqualToString:@"Instructions"])
        [self submissionAlert:NSLocalizedString(@"SUBMIT_NO_INSTRUCTIONS", @"No instructions")];
    else if (_recipe.ingredients.count<2)
        [self submissionAlert:NSLocalizedString(@"SUBMIT_NO_INGREDIENTS", @"No ingredients")];
    else [self actionSubmit];
    
}
-(void)submissionAlert:(NSString*)message{
    self.alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SUBMIT_WARNING", @"Warning") message:[NSString stringWithFormat:@"%@ - %@",message,NSLocalizedString(@"SUBMIT_REALLY", @"Really submit")] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
    [self.alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alert = nil;
    if(buttonIndex == 1)
        [self actionSubmit];
    else{
        _ai.hidden = YES;
        [_ai stopAnimating];
    }
}
-(void)actionSubmit{
    //we count the number of submissions since a copyright warning was given, so it is shown regularly
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int currentSubmissions = [[defaults objectForKey:kSubmissionsSinceCopyrightWarning] intValue];
    [defaults setObject:[NSNumber numberWithInt: currentSubmissions + 1] forKey:kSubmissionsSinceCopyrightWarning];
    [defaults synchronize];
    
    
    
    _ai.hidden = NO;
    [_ai startAnimating];
    [self updateRecipe];

     self.submitBtn.enabled = NO;
    __block YCSubmitVC *blockSelf = self;
    [[self dataService] submitRecipe:_recipe completionBlock:^(BOOL success) {
        if (success){
            if (self.newPhoto){
                self.newPhoto = NO;
                NSData *jpgData = UIImageJPEGRepresentation(self.photo.image, 0.8);
                uploadService = [YCImageUploadService new];
                
                [uploadService uploadImage:jpgData forRecipe:_recipe withCompletionBlock:^{
                    blockSelf.submitBtn.enabled = YES;
                    self.ai.hidden = YES;
                    [self.ai stopAnimating];
                    self.alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SUBMIT_SUCCESS_TITLE", @"Submit Success") message:NSLocalizedString(@"SUBMIT_SUCCESS_MESSAGE", @"Submit Success") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [self.alert show];

                }];
                
            }
            else{
                self.ai.hidden = YES;
                [self.ai stopAnimating];
                blockSelf.submitBtn.enabled = YES;
                self.alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SUBMIT_SUCCESS_TITLE", @"Submit Success") message:NSLocalizedString(@"SUBMIT_SUCCESS_MESSAGE", @"Submit Success") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [self.alert show];
            }
            
        }else{
            self.alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SUBMIT_FAILED_TITLE", @"Submit Failed") message:NSLocalizedString(@"SUBMIT_FAILED_MESSAGE", @"No Connection") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [self.alert show];
            self.ai.hidden = YES;
            [self.ai stopAnimating];
            blockSelf.submitBtn.enabled = YES;
        }
        blockSelf.dataService = nil;
        
    }];
     
   
}
-(YCSubmitRecipeService*) dataService{
    if (_dataService) return _dataService;
    else return [YCSubmitRecipeService new];
}
#pragma mark - take the photo
-(IBAction)takePhoto:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:NO completion:nil];
        //Present a view over the top
        //Take a snapshot of the current View
        _submitBtn.hidden = YES;
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:context];
        UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
        //cut a hole in that view to represent the place where the photo will appear
        
        UIBezierPath *currentPath = [UIBezierPath bezierPathWithRect:_photo.frame];
        CGContextAddPath(context,currentPath.CGPath);
        CGContextClip(context);
        CGContextClearRect(context,self.view.bounds);
        UIImage *snapShotImageWithHole = UIGraphicsGetImageFromCurrentImageContext();
        
        //present the overlay over the camera view
        UIImageView *overlay = [[UIImageView alloc] initWithImage:snapShotImage];
        
        UIGraphicsEndImageContext();
        _submitBtn.hidden = NO;
        overlay.alpha = 1.0;
        CGRect frame = overlay.frame;
        //frame.origin.x -= kCameraShift;
        //overlay.frame = frame;
        UIView *blackOverlay = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - kCameraShift,0,kCameraShift,frame.size.height)];
        blackOverlay.backgroundColor = [UIColor whiteColor];
        blackOverlay.alpha = 0.5;
        blackOverlay.userInteractionEnabled = NO;
        [imagePicker.view addSubview:blackOverlay];
        
        [imagePicker.view addSubview:overlay];
       
        
        
        [UIView animateWithDuration:0.25 delay:1.0 options:0
                         animations:^{
                              overlay.alpha = 0.5;
                             CGRect frame = overlay.frame;
                             frame.origin.x -= kCameraShift;
                             overlay.frame = frame;
                         }
                         completion:^(BOOL finished){
                             overlay.image = snapShotImageWithHole;
                         }];

     
    }
}
-(UIImage*)croppedImage:(UIImage*)inputImage{
    
    int w = inputImage.size.width;
    int h = inputImage.size.height;
    //this may look odd but its because the screen assumes its always in portrait
    int sw = [UIScreen mainScreen].bounds.size.height;
    int sh = [UIScreen mainScreen].bounds.size.width;
    //calculating the multiplying factors
    float mfw = w/(float)sw;
    float mfh = h/(float)sh;
    CGRect pf = _photo.frame;
    pf.origin.x -= kCameraShift;
    int pw = _photo.frame.size.width;
    int ph = _photo.frame.size.height;
    CGRect cropRect;
    cropRect = CGRectMake(mfw*pf.origin.x, mfw*pf.origin.y, mfh*pf.size.width, mfh*pf.size.height);
    
    UIImage *cropImg;
    CGImageRef imageRef = CGImageCreateWithImageInRect([inputImage CGImage], cropRect);
    
    cropImg = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:inputImage.imageOrientation];
    
    CGImageRelease(imageRef);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(pw,ph), NO, 0.0);
    
    [cropImg drawInRect:CGRectMake(0,0,pw,ph)];
    
    UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
    _recipe.photo = thumb;
    return thumb;
}
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.photo.image = [self croppedImage:image];
    }
    _newPhoto = YES;
}
#pragma mark - textView delegate calls to deal with placeholder (from outline and instructions)
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString *placeholder;
    if (textView == _outline)placeholder = kOutlinePlaceholder;
    else if (textView == _instructions)placeholder = kInstructionsPlaceholder;
    else {
         [textView becomeFirstResponder];
       return;
    }
    if ([textView.text isEqualToString:placeholder])
        textView.text = @"";
    
    
   }

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *placeholder;
    if (textView == _outline)placeholder = kOutlinePlaceholder;
    else if (textView == _instructions)placeholder = kInstructionsPlaceholder;
    else {
        [textView resignFirstResponder];
        return;
    }
    if ([textView.text isEqualToString:@""])
        textView.text = placeholder;
    [textView resignFirstResponder];
    if (textView == _outline)
         [_instructions becomeFirstResponder];
}
#pragma mark -textField delegate calls (from recipeTitle and chef)
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == _recipeTitle) [_chef becomeFirstResponder];
    if (textField == _chef) [_outline becomeFirstResponder];
    return YES;
}


#pragma mark - submitCell delegate calls to deal with scrolling ingredients table when its editing
- (void)cellStartedEditing:(YCSubmitCell*)cell atRow:(NSInteger)row{
   // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
   // [_ingredients scrollToRowAtIndexPath:indexPath
   //                      atScrollPosition:UITableViewScrollPositionTop
   //                              animated:YES];
    //The approach above does not work if the table is not full. So set the contentOffset instead.
    int offset = row * _ingredients.rowHeight;
    [_ingredients setContentOffset:CGPointMake(0,offset) animated:YES];
    
}
- (void)cellEndedEditing:(YCSubmitCell*)cell atRow:(NSInteger)row{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
     [_ingredients scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:YES];

}

-(void)cellShouldReturn:(YCSubmitCell*)cell atRow:(NSInteger)row{
     [cell.title resignFirstResponder];
    //if this is the last row in the list then we will add aother one and make that the one to edit
    if(row == _recipe.ingredients.count -1){
        [_recipe.ingredients addObject:kNewIngredient];
        [_ingredients reloadData];
        int offset = row * _ingredients.rowHeight;
        [_ingredients setContentOffset:CGPointMake(0,offset) animated:NO];
        YCSubmitCell *newCell = (YCSubmitCell*)[_ingredients cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row+1 inSection:0]];
        [newCell.title becomeFirstResponder];
    }
}
#pragma mark keyboard notifications 
//so we can shift the view if it's the instructions field
-(void)keyboardWasShown:(NSNotification *)notification{
    if ([_instructions isFirstResponder]){
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        [UIView animateWithDuration:0.25 delay:0.0 options:0
                         animations:^{
                             CGRect frame = self.view.frame;
                             //we have to use the width because we're in landscape
                             frame.origin.y = -keyboardSize.width;
                             self.view.frame = frame;
                         }
                         completion:nil];
    }
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.25 delay:0.0 options:0
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = 0;
                         self.view.frame = frame;
                     }
                     completion:nil];
}
#pragma mark - copyrightwarning
//show a warning message first time and every 5 times afterwards as a reminder
-(void)checkIfShouldShowCopyrightWarning{
    BOOL shouldShowWarning = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (! [defaults objectForKey:kSubmissionsSinceCopyrightWarning]){
        shouldShowWarning = YES;
    }
    else{
        if ([[defaults objectForKey:kSubmissionsSinceCopyrightWarning] intValue] >=5)
             shouldShowWarning = YES;
    }
    if (shouldShowWarning){
        [defaults setObject:[NSNumber numberWithInt:0] forKey:kSubmissionsSinceCopyrightWarning];
        [defaults synchronize];
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COPYRIGHT_TITLE", @"Copyright title") message:NSLocalizedString(@"COPYRIGHT_MESSAGE", @"Copyright message") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
