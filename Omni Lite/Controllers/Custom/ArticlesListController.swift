//
//  ListController.swift
//  Omni Lite
//
//  Created by Konrad Uciechowski on 12/04/2019.
//  Copyright © 2019 Homeflix. All rights reserved.
//

import UIKit
import SnapKit

class ArticlesListController: ViewController {
    
    var articlesTableView: OmniTableView?
    
    var infoLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //default on start
        articles(query: "")
    }
    
    @objc func search() {
        print("start Search")
        let searchAlert = OmniSearchAlert(title: "Find articles", message: "What kind of articles are you interested in?", acceptButtonTitle: "Search", cancelButtonTitle: "Cancel", searchPhrasePlaceholder: "Article phrase...")
        searchAlert.alert.textFields![0].addTarget(self, action: #selector(executeSearch(_:)), for: .editingDidEnd)
        self.present(searchAlert.alert, animated: true, completion: nil)

    }
    
    @objc func executeSearch(_ textField: UITextField) {
            articles(query: textField.text!)
    }
    
    @objc func switchTopic() {
        let isArticleHidden = articlesTableView?.articleCell.articleWrapper.isHidden
        let isTopicHidden = articlesTableView?.articleCell.topicWrapper.isHidden
        if isArticleHidden == true {
            omniSearchNavBarLeftButton.button.setTitle("Topics", for: .normal)
        } else if isTopicHidden == true {
            omniSearchNavBarLeftButton.button.setTitle("Articles", for: .normal)
        }
        articlesTableView?.reloadData()
    }

    
    override func initBaseView() {
        super.initBaseView()
        let rootView: UIView = self.view
        omniSearchNavBarRightButton.button.addTarget(self, action: #selector(search), for: .touchUpInside)
        omniSearchNavBarLeftButton.button.addTarget(self, action: #selector(switchTopic), for: .touchUpInside)
        omniSearchNavBarLeftButton.buttonView.isHidden = true
        self.articlesTableView = OmniTableView(articles: nil, width: self.uiPreferences.getScreenSize().width, height: self.uiPreferences.getScreenSize().height, frame: nil, _omni: omni, _uiPreferences: uiPreferences)
        self.view.addSubview(self.articlesTableView!)
        self.articlesTableView?.articleCell.topicWrapper.isHidden = true
        self.articlesTableView?.articleCell.articleWrapper.isHidden = false
        self.articlesTableView!.snp.makeConstraints { make -> Void in
            let articleTableViewHeight = uiPreferences.getScreenSize().height - omniNavBar.bounds.height
            make.height.equalTo(articleTableViewHeight)
            make.width.equalTo(uiPreferences.getScreenSize().width)
            make.top.equalTo(omniNavBar.snp.bottom).offset(-70)
            make.left.equalTo(rootView.snp.left)
            make.right.equalTo(rootView.snp.right)
            make.bottom.equalTo(rootView.snp.bottom)
        }
        
        if self.articlesTableView!.isHidden {
            infoLabel = UILabel()
        }
    }
    
    func articles(query: String) {
        omni.httpGetArticlesByQuery(query: query) { articles, error in
            if articles != nil {
                self.articlesTableView?.refreshTable(articles: articles!)
                self.infoLabel!.isHidden = true
//                self.omniSearchNavBarLeftButton.buttonView.isHidden = false
            } else {
                self.infoLabel!.isHidden = false
            }
        }
    }
    
}
