//
//  ViewController.swift
//  VNCustomControlDemo
//
//  Created by Varun Naharia on 16/08/17.
//  Copyright © 2017 Varun Naharia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtFirstName: VNTextField!
    @IBOutlet weak var txtLastName: VNTextField!
    @IBOutlet weak var txtEmail: VNTextField!
    @IBOutlet weak var txtPhone: VNTextField!
    @IBOutlet weak var txtPassword: VNTextField!
    @IBOutlet weak var txtConfirmPassword: VNTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitAction(_ sender: UIButton) {
        if(formValid())
        {
        
        }
        
    }
    
    func formValid() -> Bool {
        var isValid = false
        if(txtFirstName.text == "")
        {
            isValid = false
            txtFirstName.setError(error: "Please enter first Name!Please enter first Name!Please enter first Name!Please enter first Name! ")
        }
        if(txtEmail.text == "")
        {
            txtEmail.setError(error: "Please enter Email")
        }
        
        if(txtPhone.text == "")
        {
            txtPhone.setError(error: "Please enter Phone")
        }
        
        if(txtLastName.text == "")
        {
            txtLastName.setError(error: "Please enter last name")
        }
        
        return isValid
    }

}

