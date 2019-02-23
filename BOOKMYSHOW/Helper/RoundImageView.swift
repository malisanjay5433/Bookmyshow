import UIKit
@IBDesignable class RoundImageView: UIImageView {
    override var bounds: CGRect {
        didSet {
            updateCornerRadiusValue()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCornerRadiusValue()
    }
    fileprivate func updateCornerRadiusValue() {
        layer.cornerRadius = 60
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
}
@IBDesignable class CustomView:UIView {
    override var bounds: CGRect {
        didSet {
            updateCornerRadiusValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCornerRadiusValue()
    }
    
    fileprivate func updateCornerRadiusValue() {
        layer.cornerRadius = 15
        layer.borderColor = UIColor.init(red: 141/255, green: 61/255, blue: 104/255, alpha: 1).cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
        
    }
}

@IBDesignable class CustomButton:UIButton {
    override var bounds: CGRect {
        didSet {
            updateCornerRadiusValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCornerRadiusValue()
    }
    
    fileprivate func updateCornerRadiusValue() {
        layer.cornerRadius = 15
    }
}
