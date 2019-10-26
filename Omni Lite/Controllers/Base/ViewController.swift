//
//  ViewController.swift
//  Omni Lite
//
//  Created by Konrad Uciechowski on 11/04/2019.
//  Copyright © 2019 Homeflix. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var omni: Omni
    var uiPreferences: UIPreferences
    
    var omniNavBar: OmniNavBar
    var omniSearchNavBarRightButton: OmniNavButton
    var omniSearchNavBarLeftButton: OmniNavButton
    
    init(_omni: Omni, _uiPreferences: UIPreferences) {
        omni = _omni
        uiPreferences = _uiPreferences
        
        omniSearchNavBarRightButton = OmniNavButton(defaultButton: true, width: 100, height: 30, color: .gray, image: nil)
        omniSearchNavBarLeftButton = OmniNavButton(defaultButton: true, width: 100, height: 30, color: .gray, text: "Topics", image: nil)
        omniNavBar = OmniNavBar(defaultBar: true, frame: nil, navButtons: [omniSearchNavBarRightButton, omniSearchNavBarLeftButton])
        super.init(nibName: nil, bundle: nil)
        initBaseView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBaseView() {
        view.backgroundColor = .white
        initNavBar(withDefaultConstraints: true)
    }
    
    func initNavBar(withDefaultConstraints: Bool) {
        let rootView: UIView = self.view
        self.view.addSubview(omniNavBar)
        omniNavBar.snp.makeConstraints { make -> Void in
            make.height.equalTo(120)
            make.width.equalTo(uiPreferences.getScreenSize().width)
            make.top.equalTo(rootView.snp.top).offset(40)
            make.left.equalTo(rootView.snp.left)
            make.right.equalTo(rootView.snp.right)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

