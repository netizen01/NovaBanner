//
//  AppDelegate.swift
//  NovaBannerDemo
//

import UIKit
import NovaBanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Customize your NovaBanner Themes (Default, Notify, Failure, Success)
        var theme = NovaBanner.Theme(UIColor(white: 0.1, alpha: 0.9), .whiteColor())
        
        /*
        theme.backgroundColor = UIColor(white: 0.1, alpha: 0.9)  // Set via the ctor
        theme.titleColor = .whiteColor()                         // Set via the ctor
        theme.subtitleColor = .whiteColor()                      // Set via the ctor
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
        theme.backgroundColor = .yellowColor()
        NovaBanner.ThemeNotify = theme
        
        theme.backgroundColor = .redColor()
        NovaBanner.ThemeFailure = theme
        
        theme.backgroundColor = .greenColor()
        NovaBanner.ThemeSuccess = theme
        
        // If the defaults are acceptable, you could also just adjust the various Theme properties directly.
        /*
        NovaBanner.ThemeNotify.backgroundColor = .yellowColor()
        NovaBanner.ThemeFailure.backgroundColor = .redColor()
        NovaBanner.ThemeSuccess.backgroundColor = .greenColor()
        */
        
        return true
    }

}
