//
//  ViewController.swift
//  NovaBannerDemo
//

import UIKit
import NovaBanner

class ViewController: UIViewController {
    
    @IBAction func showBannerHandler(_ sender: UIButton) {
        
        NovaBanner(title: "Demo Banner", subtitle: "Subtitle Text", type: NovaBanner.BannerType.default, image: UIImage(named: "whale"), tapped: { banner in
            print("Banner Tapped")
        }) {
            print("Banner Dismissed")
        }.show()
        
    }
    
}
