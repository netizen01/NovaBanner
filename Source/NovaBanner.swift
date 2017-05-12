//
//  NovaBanner.swift
//

import UIKit
import Cartography
import NovaCore

open class NovaBanner: NSObject {
    
    public struct Theme {
        public var backgroundColor: UIColor? = UIColor(white: 0.1, alpha: 0.9)
        public var titleColor: UIColor = .white
        public var subtitleColor: UIColor = .white
        
        public var bannerPadding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        public var textSpacing: CGFloat = 4
        public var topPadding: CGFloat = 20
        public var animateInDuration: TimeInterval = 0.25
        public var animateOutDuration: TimeInterval = 0.25
        public var titleFont: UIFont = .preferredFont(forTextStyle: UIFontTextStyle.headline)
        public var subtitleFont: UIFont = .preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        
        init() {
            
        }
        
        public init(_ backgroundColor: UIColor, _ textColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.titleColor = textColor
            self.subtitleColor = textColor
        }
    }
    
    // Adjust the static Default Themes
    open static var DefaultDuration: TimeInterval = 6
    open static var ThemeDefault = Theme()
    open static var ThemeNotify = Theme(.black, .white)
    open static var ThemeFailure = Theme(.black, .white)
    open static var ThemeSuccess = Theme(.black, .white)
    
    public enum BannerType {
        case `default`
        case notify
        case failure
        case success
    }
    
    open var theme: Theme = ThemeDefault
    
    open let type: BannerType
    open let title: String
    open let subtitle: String?
    open let image: UIImage?
    open let tapHandler: ((_ banner: NovaBanner) -> ())?
    open let dismissHandler: (() -> ())?
    
    public init(title: String, subtitle: String? = nil, type: BannerType = .default, image: UIImage? = nil, tapped: ((_ banner: NovaBanner) -> ())? = nil, dismissed: (() -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
        self.tapHandler = tapped
        self.dismissHandler = dismissed
        
        switch type {
        case .default:
            theme = NovaBanner.ThemeDefault
        case .notify:
            theme = NovaBanner.ThemeNotify
        case .failure:
            theme = NovaBanner.ThemeFailure
        case .success:
            theme = NovaBanner.ThemeSuccess
        }
        super.init()
        viewController.banner = self
    }
    
    fileprivate let viewController = NovaBannerViewController()
    fileprivate var dismissTimer: Timer?
    @discardableResult open func show(duration: TimeInterval? = NovaBanner.DefaultDuration) -> NovaBanner {
        // Mimic the current Status Bar Style for this UIWindow / View Controller
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            statusBarStyle = rootVC.preferredStatusBarStyle
            statusBarHidden = rootVC.prefersStatusBarHidden
        }
        
        // Create the Alert Window if necessary
        if bannerWindow == nil {
            bannerWindow = UIWindow(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: 0)))
            // Put the window under the Status Bar so it's no blurred out
            bannerWindow?.windowLevel = UIWindowLevelStatusBar + 1
            bannerWindow?.tintColor = UIApplication.shared.delegate?.window??.tintColor
            bannerWindow?.rootViewController = viewController
            bannerWindow?.isHidden = false
        }
        
        if let duration = duration, duration > 0 {
            dismissTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(NovaBanner.autoDismissTimer(_:)), userInfo: nil, repeats: false)
        }
        
        return self
    }
    
    @discardableResult open func dismiss(_ animated: Bool = true, completion: (() -> ())? = nil) -> NovaBanner {
        dismissTimer?.invalidate()
        dismissTimer = nil
        viewController.dismiss(animated, completion: completion)
        return self
    }
    
    
    // Private
    fileprivate var bannerWindow: UIWindow?
    fileprivate var statusBarStyle: UIStatusBarStyle = .default
    fileprivate var statusBarHidden: Bool = false
    
    fileprivate func destroy() {
        dismissHandler?()
        bannerWindow?.isHidden = true
        bannerWindow?.rootViewController = nil
        bannerWindow = nil
        viewController.banner = nil
    }
    
    func autoDismissTimer(_ timer: Timer) {
        dismiss()
    }
    
    deinit {
        dismissTimer?.invalidate()
    }
}







class NovaBannerViewController: UIViewController {

    fileprivate var banner: NovaBanner!
    
    fileprivate let bannerView = NovaBannerView()
    
    fileprivate let tapGestureRecognizer = UITapGestureRecognizer()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .none
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: CGRect.zero)
        view.addSubview(bannerView)
        
        tapGestureRecognizer.addTarget(self, action: #selector(NovaBannerViewController.tapGestureHandler(_:)))
        bannerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate var bannerViewContraints: ConstraintGroup!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constrain(bannerView, view) { bannerView, view in
            bannerView.left == view.left
            bannerView.right == view.right
        }
        
        bannerViewContraints = constrain(view, bannerView) { view, bannerView in
            bannerView.bottom == view.top
        }
        
        bannerView.imageView.image = banner.image
        bannerView.titleLabel.text = banner.title
        bannerView.subtitleLabel.text = banner.subtitle
        
        bannerView.applyTheme(banner.theme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        banner.bannerWindow?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (banner.bannerWindow!.frame.width), height: bannerView.frame.height))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bannerViewContraints = constrain(view, bannerView, replace: bannerViewContraints) { view, bannerView in
            bannerView.top == view.top - banner.theme.topPadding
        }
        UIView.animate(withDuration: banner.theme.animateInDuration, animations: {
            self.view.layoutIfNeeded()
        }) 
    }

    fileprivate func dismiss(_ animated: Bool = true, completion: (() -> ())? = nil) {
        if banner == nil {
            return
        }
        if animated {
            bannerViewContraints = constrain(view, bannerView, replace: bannerViewContraints) { view, bannerView in
                bannerView.bottom == view.top
            }
            UIView.animate(withDuration: banner.theme.animateOutDuration, animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.banner?.destroy()
                completion?()
            }) 
        } else {
            banner.destroy()
            completion?()
        }
    }
    
    
    func tapGestureHandler(_ gesture: UITapGestureRecognizer) {
        if bannerView.hitTest(gesture.location(in: bannerView), with: nil) != nil {
            gesture.isEnabled = false
            banner.tapHandler?(banner)
            banner.dismiss()
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return banner.statusBarHidden
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return banner.statusBarStyle
    }
    
}





class NovaBannerView: UIView {
    
    fileprivate let titleLabel = UILabel(frame: CGRect.zero)
    fileprivate let subtitleLabel = UILabel(frame: CGRect.zero)
    fileprivate let imageView = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.textAlignment = .left
        subtitleLabel.textAlignment = .left
        
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        subtitleLabel.numberOfLines = 2
    }
    
    internal func applyTheme(_ theme: NovaBanner.Theme) {
        
        backgroundColor = theme.backgroundColor
        titleLabel.font = theme.titleFont
        subtitleLabel.font = theme.subtitleFont
        
        imageView.tintColor = theme.titleColor
        titleLabel.textColor = theme.titleColor
        subtitleLabel.textColor = theme.subtitleColor

        constrain(titleLabel, subtitleLabel, imageView, self) { titleLabel, subtitleLabel, imageView, view in
            
            imageView.top == view.top + theme.bannerPadding.top + theme.topPadding
            imageView.left == view.left + theme.bannerPadding.left
            imageView.bottom == view.bottom - theme.bannerPadding.bottom
            
            if self.imageView.image == nil {
                imageView.width == 0
            }
            
            titleLabel.left == imageView.right + theme.bannerPadding.left
            titleLabel.right == view.right - theme.bannerPadding.right
            titleLabel.top == view.top + theme.bannerPadding.top + theme.topPadding
            
            if self.subtitleLabel.text != nil {
                titleLabel.bottom == subtitleLabel.top - theme.textSpacing
            } else {
                titleLabel.bottom == subtitleLabel.top
            }
            
            subtitleLabel.bottom == view.bottom - theme.bannerPadding.bottom
            
            subtitleLabel.left == imageView.right + theme.bannerPadding.left
            subtitleLabel.right == view.right - theme.bannerPadding.right
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
