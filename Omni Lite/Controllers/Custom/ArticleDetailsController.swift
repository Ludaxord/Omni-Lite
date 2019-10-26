//
//  ArticleDetailsController.swift
//  Omni Lite
//
//  Created by Konrad Uciechowski on 12/04/2019.
//  Copyright © 2019 Homeflix. All rights reserved.
//

import UIKit
import SnapKit

class ArticleDetailsController: ViewController {
    
    var article: Article
    var mainView: UIScrollView
    var imageView: UIImageView
    
    init(_omni: Omni, _uiPreferences: UIPreferences, _article: Article) {
        article = _article
        mainView = UIScrollView()
        imageView = UIImageView()
        super.init(_omni: _omni, _uiPreferences: _uiPreferences)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissDetails() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    override func initBaseView() {
        super.initBaseView()
        let rootView = self.view
        omniNavBar.navBarItem.leftBarButtonItem = nil
        omniNavBar.navBarItem.rightBarButtonItem = nil
        omniNavBar.navBarItem.title = article.titleValue
        let backButton = OmniNavButton(defaultButton: false, width: 30, height: 30, color: .clear, text: "", image: UIImage(named: "chevron-left.png"))
        backButton.button.addTarget(self, action: #selector(dismissDetails), for: .touchUpInside)
        omniNavBar.addNewItem(from: 1, item: backButton)
        self.view.addSubview(mainView)
        let imageId = article.mainResourceImageAssetsId
        var urlString: String?
        if (imageId != nil) {
            mainView.addSubview(imageView)
            urlString = "\(Statics.imagesUrl)/\(imageId!)"
            let imageUrl = URL(string: urlString!)
            imageView.kf.setImage(with: imageUrl!)
            imageView.isHidden = false
            imageView.snp.makeConstraints { make -> Void in
                make.width.equalTo((mainView.snp.width))
                make.left.equalTo((mainView.snp.left))
                make.right.equalTo((mainView.snp.right))
                make.top.equalTo(mainView.snp.top)
            }
            mainView.snp.makeConstraints { make -> Void in
                make.width.equalTo((rootView?.snp.width)!)
                make.left.equalTo((rootView?.snp.left)!)
                make.right.equalTo((rootView?.snp.right)!)
                make.bottom.equalTo((rootView?.snp.bottom)!)
                make.top.equalTo(omniNavBar.snp.bottom).offset(-70)
            }
        } else {
            imageView.isHidden = true
            mainView.snp.makeConstraints { make -> Void in
                make.width.equalTo((rootView?.snp.width)!)
                make.left.equalTo((rootView?.snp.left)!)
                make.right.equalTo((rootView?.snp.right)!)
                make.bottom.equalTo((rootView?.snp.bottom)!)
                make.top.equalTo(omniNavBar.snp.bottom).offset(-70)
            }
        }
    }
    
    func initLabels(mainView: UIScrollView, imageView: UIImageView) {
        let paragraphs = article.mainTextParagraphs
        var yposition: CGFloat = imageView.frame.size.height
        var scrollContent: CGFloat = imageView.frame.size.height
        for (paragraph, type) in paragraphs! {
            if type! == "paragraph" {
                let label = UILabel()
                label.text = paragraph
                mainView.addSubview(label)
                label.sizeToFit()
                label.textAlignment = .center
                label.numberOfLines = 0;
                label.lineBreakMode = .byWordWrapping;
                label.frame = CGRect(x: 30,y: yposition,width: uiPreferences.getScreenSize().width / 1.2, height: uiPreferences.getScreenSize().width / 4)
                yposition += label.frame.size.height + 10
                scrollContent += label.frame.size.height
            }
        }
        if scrollContent > uiPreferences.getScreenSize().height {
            scrollContent += 100
        }
        mainView.contentSize = CGSize(width: uiPreferences.getScreenSize().width, height: scrollContent)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if imageView.frame.size.height != 0.0 {
            initLabels(mainView: mainView, imageView: imageView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
