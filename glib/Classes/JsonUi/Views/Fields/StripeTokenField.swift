#if INCLUDE_STRIPE

import Foundation
import Stripe

class JsonView_Fields_StripeToken: JsonView_AbstractField, SubmittableField {
    private var delegate: Delegate?
    private var token: STPToken?
    
    var name: String?
    var value: String {
        return token?.tokenId ?? ""
    }
    
    func validate() -> Bool {
        return true
    }
    
    override func initView() -> UIView {
        Stripe.setDefaultPublishableKey(spec["publicKey"].stringValue)
        name = spec["name"].string

        let panel = GVerticalPanel().width(.matchParent).height(.wrapContent)
        let stripeTokenField = GStripeTextField()
        
        panel.addView(stripeTokenField)
        
        if let width = spec["width"].presence {
            switch width {
            case "wrapContent":
                stripeTokenField.width(.wrapContent)
            case "matchParent":
                stripeTokenField.width(.matchParent)
            default:
                stripeTokenField.width(width.intValue)
            }
        }

        self.delegate = Delegate(view: self)
        if let delegate = self.delegate {
            stripeTokenField.delegate(delegate)
        }
        
        return panel
    }
    
    class Delegate: NSObject, STPPaymentCardTextFieldDelegate {
        private let stripeTokenView: JsonView_Fields_StripeToken
        
        init(view: JsonView_Fields_StripeToken) {
            stripeTokenView = view
            super.init()
        }
        
        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            if textField.isValid {
                Generic.sharedInstance.genericIsBusy.value = true
                
                let card = STPCardParams()
                card.number = textField.cardNumber
                card.expMonth = textField.expirationMonth
                card.expYear = textField.expirationYear
                card.cvc = textField.cvc
                
                STPAPIClient.shared().createToken(withCard: card) { token, error in
                    guard let token = token else {
                        return
                    }
                    
                    self.stripeTokenView.token = token
                    Generic.sharedInstance.genericIsBusy.value = false
                }
            }
        }
    }
}

class GStripeTextField: STPPaymentCardTextField, IView {
    fileprivate var helper: ViewHelper!
    var paddings = Paddings(top: 0, left: 0, bottom: 0, right: 0)
    
    public var size: CGSize {
        return helper.size
    }
    
    public init() {
        super.init(frame: .zero)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        helper = ViewHelper(self)
        
        // Make sure that contentEdgeInsets' values is always initialized properly (i.e. non-zero)
        _ = paddings(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    @discardableResult
    public func color(bg: UIColor) -> Self {
        backgroundColor = bg
        return self
    }
    
    @discardableResult
    public func padding(_ newPadding: GPadding) -> Self {
        paddings = paddings.to(top: newPadding.top, left: newPadding.left, bottom: newPadding.bottom, right: newPadding.right)
        return self
    }
    
    @discardableResult
    public func paddings(top: Float?, left: Float?, bottom: Float?, right: Float?) -> Self {
        paddings = paddings.to(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }
    
    public func width(_ width: LayoutSize) -> Self {
//        doesn't work with STPPaymentCardTextField
//        helper.width(width)
        if (width == .matchParent) {
            snp.makeConstraints { (make) in
                if let superview = superview {
                    make.right.equalTo(superview.snp.rightMargin)
                }
            }
        }
        return self
    }
    
    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }
    
    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }
    
    public func delegate(_ delegate: STPPaymentCardTextFieldDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}

#endif
