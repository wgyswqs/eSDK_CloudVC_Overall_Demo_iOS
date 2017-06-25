//
//  ContactViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UITextField *emailtext;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *depttext;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *deptNumText;
@property (weak, nonatomic) IBOutlet UITextField *groupText;

@end

@implementation ContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_contact)
    {
        _nameText.text = _contact.name;
        _numText.text = _contact.account;
        _emailtext.text = _contact.email;
        _addressText.text = _contact.address;
        _depttext.text = _contact.department;
        _phoneText.text = _contact.mobilePhone;
        _deptNumText.text = _contact.officePhone;
        _groupText.text = _contact.group;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)closeBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)okBtnClick:(id)sender
{
    
    if (_nameText.text.length==0)
    {
        NSLog(@"name can not be nil");
        return;
    }
    
    switch (_flag)
    {
        case 0:
        {
            TupContact *contact_01 = [[TupContact alloc]init];
            /*contact_01.name = @"contact_01";
             contact_01.officePhone = @"1234567";
             contact_01.department = @"test contacts";*/
            contact_01.name = _nameText.text;
            contact_01.officePhone = _deptNumText.text;
            contact_01.department = _depttext.text;
            contact_01.account = _numText.text;
            contact_01.mobilePhone = _phoneText.text;
            contact_01.group = _groupText.text;
            contact_01.address = _addressText.text;
            contact_01.email = _emailtext.text;
            
            ContactsErrorId result = [[TupContactsSDK sharedInstance]addLocalContact:contact_01];
            NSLog(@"addLocalContact result :%d",result);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            _contact.name = _nameText.text;
            _contact.officePhone = _deptNumText.text;
            _contact.department = _depttext.text;
            _contact.account = _numText.text;
            _contact.mobilePhone = _phoneText.text;
            _contact.group = _groupText.text;
            _contact.address = _addressText.text;
            _contact.email = _emailtext.text;
            
            ContactsErrorId result = [[TupContactsSDK sharedInstance]modifyLocalContact:_contact];
            NSLog(@"modifyLocalContact result :%d",result);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
