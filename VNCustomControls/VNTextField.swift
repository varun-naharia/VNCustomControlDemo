//
//  VNTextField.swift
//  VNCustomControlDemo
//
//  Created by Varun Naharia on 16/08/17.
//  Copyright © 2017 Varun Naharia. All rights reserved.
//

import UIKit

@IBDesignable
class VNTextField: UITextField,UITextFieldDelegate,UIPopoverPresentationControllerDelegate {
    
    enum ValidationType:String {
        case Inside = "inside"
        case Outside = "outside"
        case Popup = "popup"
    }
    
    @IBOutlet weak var validationLabel:VNLabel!
    var placeholdertext: String?
    @IBInspectable
    public var cornerRadius :CGFloat {
        
        set { layer.cornerRadius = newValue }
        
        get {
            return layer.cornerRadius
        }
        
    }
    
    var validationType:ValidationType = ValidationType.Inside
   
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'validationType' instead.")
    @IBInspectable var validationName: String? {
        willSet {
            // Ensure user enters a valid shape while making it lowercase.
            // Ignore input if not valid.
            if let newType = ValidationType(rawValue: newValue?.lowercased() ?? "") {
                validationType = newType
            }
        }
    }
    
    @IBInspectable var validationImage:UIImage = #imageLiteral(resourceName: "alert.png")

    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isUnderLine:Bool = false
        {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    var errorLable:VNLabel = VNLabel()
    func setError(error:String?){
        if(error != nil)
        {
            self.text = ""
            if(validationType == ValidationType.Inside)
            {
                self.attributedPlaceholder = NSAttributedString(string: error!, attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
            else if(validationType == ValidationType.Outside)
            {
                validationLabel.text = error!
                validationLabel.textColor = UIColor.red
                validationLabel.leftImage = validationImage
                self.delegate = self
                //let heightConstraint = validationLabel.heightAnchor.constraint(equalToConstant: 23)
                //NSLayoutConstraint.activate([heightConstraint])
                for constraint in validationLabel.constraints {
                    if(constraint.firstAttribute == NSLayoutAttribute.height)
                    {
                        
                        validationLabel.alpha = 0.5
                        self.validationLabel.center.y = self.validationLabel.center.y-25
                        constraint.constant = 25
                        UIView.animate(withDuration: 0.5,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions.transitionCurlDown,
                                       animations: { () -> Void in
                                        self.validationLabel.alpha = 1.0
                                        self.validationLabel.center.y = self.validationLabel.center.y + 25
                                        
                        }, completion: { (finished) -> Void in
                            if(finished)
                            {
                            }
                        })
                        
                    }
                }
            }
            else if(validationType == ValidationType.Popup)
            {
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ErrorController")
                
                vc.modalPresentationStyle = UIModalPresentationStyle.popover
                vc.preferredContentSize = CGSize(width: self.frame.width, height: 300)
                
                
                
                vc.popoverPresentationController?.delegate = self
                vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
                
                
                // in case we don't have a bar button as reference
                vc.popoverPresentationController?.sourceView = self
                vc.popoverPresentationController?.sourceRect = self.frame
                let temp : UIViewController = (self.superview?.window?.rootViewController)!
                temp.present(vc, animated: true, completion: nil)
                
                return
                
                let errorLabel = VNLabel()
                errorLabel.lineBreakMode = .byWordWrapping
                errorLabel.text = error!
                errorLabel.numberOfLines = 0
                
                self.rightImage = validationImage
                
                let popup:UIView = UIView()
                let innerView:UIView = UIView()
                
                innerView.backgroundColor = UIColor.black
                popup.backgroundColor = UIColor.red
                errorLabel.textColor = UIColor.white
                errorLabel.backgroundColor = UIColor.black
                
                popup.addSubview(innerView)
                innerView.addSubview(errorLabel)
                self.superview?.addSubview(popup)
                
                var viewWidth = errorLabel.intrinsicContentSize.width
                if(viewWidth > UIScreen.main.bounds.width)
                {
                    viewWidth = UIScreen.main.bounds.width
                }
                
                // Calculate frame of error label according to text
                let rect = errorLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: self.frame.size.width - 5, height: CGFloat(MAXFLOAT)), limitedToNumberOfLines: 0)
                print(rect)
                    
                errorLabel.frame = CGRect(x: 2.5, y: 0, width: self.frame.size.width - 5, height: rect.size.height+10)
                innerView.frame = CGRect(x: 0, y: 5, width: self.frame.size.width, height: rect.size.height+10)
                
                popup.frame = CGRect(x:self.frame.origin.x , y: self.frame.maxY+5, width: self.frame.size.width, height: rect.size.height+10)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var textLeftPadding:CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var underlineColor:UIColor = UIColor.black
        {
        didSet{
            self.updateView()
        }
    }
    private var placeholderColorValue:UIColor = UIColor.lightGray
    @IBInspectable public var placeholderColor:UIColor
        {
        set{
            self.attributedPlaceholder = NSAttributedString(string:placeholder!, attributes: [NSForegroundColorAttributeName: newValue])
            placeholderColorValue = newValue
        }
        get{
            return placeholderColorValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func setUpView() {
        if(rightImage != nil)
        {
            self.leftViewMode = UITextFieldViewMode.always
            let rightImageView:UIImageView = UIImageView(image: rightImage)
            rightImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height)
            self.rightView = rightImageView
        }
        else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
    }
    
    func updateView() {
        if let imageLeft = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = imageLeft
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        if let imageRight = rightImage {
            rightViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = imageRight
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: color])
        if(self.isUnderLine)
        {
            let underline:UIView = UIView()
            underline.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
            underline.backgroundColor = underlineColor
            self.addSubview(underline)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: textLeftPadding, y: 0, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(validationLabel != nil && validationLabel.alpha > 0.0)
        {
            for constraint in validationLabel.constraints {
                if(constraint.firstAttribute == NSLayoutAttribute.height)
                {
                    
                    validationLabel.alpha = 0.5
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.transitionCurlDown,
                                   animations: { () -> Void in
                                    self.validationLabel.alpha = 0.0
                                    self.validationLabel.center.y = self.validationLabel.center.y - 25
                                    
                    }, completion: { (finished) -> Void in
                        if(finished)
                        {
                            constraint.constant = 0
                        }
                    })
                    
                }
            }
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
