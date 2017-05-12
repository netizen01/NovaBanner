//
//  AppDelegate.swift
//  NovaBannerDemo
//

import UIKit
import NovaBanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Customize your NovaBanner Themes (Default, Notify, Failure, Success)
        var theme = NovaBanner.Theme(UIColor(white: 0.1, alpha: 0.9), .white)
        
        /*
        theme.backgroundColor = UIColor(white: 0.1, alpha: 0.9) // Set via the ctor
        theme.titleColor = .white                               // Set via the ctor
        theme.subtitleColor = .white                            // Set via the ctor
        */
        
        // These are all the options (with default values displayed) you can adjust for your NovaBanner Theme
        /*
        theme.animateInDuration = 0.25
        theme.animateOutDuration = 0.25
        theme.bannerPadding = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        theme.titleFont = .boldSystemFontOfSize(16)
        theme.subtitleFont = .systemFontOfSize(14)
        theme.textSpacing = 4
        theme.topPadding = 20
        */
        
        // Assign this theme as the Default
        NovaBanner.ThemeDefault = theme
        
        // Make adjustments for the various themes
        theme.backgroundColor = .yellow
        NovaBanner.ThemeNotify = theme
        
        theme.backgroundColor = .red
        NovaBanner.ThemeFailure = theme
        
        theme.backgroundColor = .green
        NovaBanner.ThemeSuccess = theme
        
        // If the defaults are acceptable, you could also just adjust the various Theme properties directly.
        /*
        NovaBanner.ThemeNotify.backgroundColor = .yellow
        NovaBanner.ThemeFailure.backgroundColor = .red
        NovaBanner.ThemeSuccess.backgroundColor = .green
        */
        
        return true
    }

}
