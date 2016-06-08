//
//  NovaBanner.swift
//

import UIKit
import Cartography
import NovaCore

public class NovaBanner: NSObject {
    
    public struct Theme {
        public var backgroundColor: UIColor? = UIColor(white: 0.1, alpha: 0.9)
        public var titleColor: UIColor = .whiteColor()
        public var subtitleColor: UIColor = .whiteColor()
        
        public var bannerPadding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        public var textSpacing: CGFloat = 4
        public var topPadding: CGFloat = 20
        public var animateInDuration: NSTimeInterval = 0.25
        public var animateOutDuration: NSTimeInterval = 0.25
        public var titleFont: UIFont = .boldSystemFontOfSize(16)
        public var subtitleFont: UIFont = .systemFontOfSize(14)
        
        init() {
            
        }
        
        public init(_ backgroundColor: UIColor, _ textColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.titleColor = textColor
            self.subtitleColor = textColor
        }
    }
    
    // Adjust the static Default Themes
    public static var DefaultDuration: NSTimeInterval = 6
    public static var ThemeDefault = Theme()
    public static var ThemeNotify = Theme(.blackColor(), .whiteColor())
    public static var ThemeFailure = Theme(.blackColor(), .whiteColor())
    public static var ThemeSuccess = Theme(.blackColor(), .whiteColor())
    
    public enum BannerType {
        case Default
        case Notify
        case Failure
        case Success
    }
    
    public var theme: Theme = ThemeDefault
    
    public let type: BannerType
    public let title: String
    public let subtitle: String?
    public let image: UIImage?
    public let tapHandler: ((banner: NovaBanner) -> ())?
    public let dismissHandler: (() -> ())?
    
    public let viewController = NovaBannerViewController()
    
    public init(title: String, subtitle: String? = nil, type: BannerType = .Default, image: UIImage? = nil, tapped: ((banner: NovaBanner) -> ())? = nil, dismissed: (() -> ())? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.type = type
        self.tapHandler = tapped
        self.dismissHandler = dismissed
        
        switch type {
        case .Default:
            theme = NovaBanner.ThemeDefault
        case .Notify:
            theme = NovaBanner.ThemeNotify
        case .Failure:
            theme = NovaBanner.ThemeFailure
        case .Success:
            theme = NovaBanner.ThemeSuccess
        }
        super.init()
        viewController.banner = self
    }
    
    private var dismissTimer: NSTimer?
    public func show(duration duration: NSTimeInterval? = NovaBanner.DefaultDuration) -> NovaBanner {
        // Mimic the current Status Bar Style for this UIWindow / View Controller
        if let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
            statusBarStyle = rootVC.preferredStatusBarStyle()
            statusBarHidden = rootVC.prefersStatusBarHidden()
        }
        
        // Create the Alert Window if necessary
        if bannerWindow == nil {
            bannerWindow = UIWindow(frame: CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 0)))
            // Put the window under the Status Bar so it's no blurred out
            bannerWindow?.windowLevel = UIWindowLevelStatusBar + 1
            bannerWindow?.tintColor = UIApplication.sharedApplication().delegate?.window??.tintColor
            bannerWindow?.rootViewController = viewController
            bannerWindow?.makeKeyAndVisible()
        }
        
        if let duration = duration where duration > 0 {
            dismissTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(NovaBanner.autoDismissTimer(_:)), userInfo: nil, repeats: false)
        }
        
        return self
    }
    
    public func dismiss(animated: Bool = true, completion: (() -> ())? = nil) -> NovaBanner {
        dismissTimer?.invalidate()
        dismissTimer = nil
        viewController.dismiss(animated, completion: completion)
        return self
    }
    
    
    // Private
    private var bannerWindow: UIWindow?
    private var statusBarStyle: UIStatusBarStyle = .Default
    private var statusBarHidden: Bool = false
    
    private func destroy() {
        dismissHandler?()
        bannerWindow?.hidden = true
        bannerWindow?.rootViewController = nil
        bannerWindow = nil
        viewController.banner = nil
    }
    
    func autoDismissTimer(timer: NSTimer) {
        dismiss()
    }
    
    
    deinit {
        dismissTimer?.invalidate()
        print("deinit \(self.dynamicType)")
    }
}







public class NovaBannerViewController: UIViewController {

    private var banner: NovaBanner!
    
    public let bannerView = NovaBannerView()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .None
        modalTransitionStyle = .CrossDissolve
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    public override func loadView() {
        view = UIView(frame: CGRect.zero)
        view.addSubview(bannerView)
        
        tapGestureRecognizer.addTarget(self, action: #selector(NovaBannerViewController.tapGestureHandler(_:)))
        bannerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private var bannerViewContraints: ConstraintGroup?
    public override func viewDidLoad() {
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
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        banner.bannerWindow?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (banner.bannerWindow!.frame.width), height: bannerView.frame.height))
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        constrain(view, bannerView, replace: bannerViewContraints!) { view, bannerView in
            bannerView.top == view.top - banner.theme.topPadding
        }
        UIView.animateWithDuration(banner.theme.animateInDuration) {
            self.view.layoutIfNeeded()
        }
    }

    private func dismiss(animated: Bool = true, completion: (() -> ())? = nil) {
        if banner == nil {
            return
        }
        if animated {
            constrain(view, bannerView, replace: bannerViewContraints!) { view, bannerView in
                bannerView.bottom == view.top
            }
            UIView.animateWithDuration(banner.theme.animateOutDuration, animations: {
                self.view.layoutIfNeeded()
            }) { finished in
                self.banner.destroy()
                completion?()
            }
        } else {
            banner.destroy()
            completion?()
        }
    }
    
    
    func tapGestureHandler(gesture: UITapGestureRecognizer) {
        if bannerView.hitTest(gesture.locationInView(bannerView), withEvent: nil) != nil {
            gesture.enabled = false
            banner.tapHandler?(banner: banner)
            banner.dismiss()
        }
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return banner.statusBarHidden
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return banner.statusBarStyle ?? .Default
    }
    
    deinit {
        print("deinit \(self.dynamicType)")
    }
}





public class NovaBannerView: UIView {
    
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let subtitleLabel = UILabel(frame: CGRect.zero)
    private let imageView = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.textAlignment = .Left
        subtitleLabel.textAlignment = .Left
        
        imageView.contentMode = .ScaleAspectFit
        imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)

        subtitleLabel.numberOfLines = 2
    }
    
    internal func applyTheme(theme: NovaBanner.Theme) {
        
        backgroundColor = theme.backgroundColor
        
        titleLabel.font = theme.titleFont
        subtitleLabel.font = theme.subtitleFont
        
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit \(self.dynamicType)")
    }
}
