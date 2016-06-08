//
//  ViewController.swift
//  NovaBannerDemo
//

import UIKit
import NovaBanner

class ViewController: UIViewController {
    
    @IBAction func showBannerHandler(sender: UIButton) {
        
        NovaBanner(title: "Demo Banner", subtitle: "Subtitle Text", type: NovaBanner.BannerType.Default, image: UIImage(named: "whale"), tapped: { banner in
            print("Banner Tapped")
        }) { banner in
            print("Banner Dismissed")
        }.show()
        
    }
    
}
