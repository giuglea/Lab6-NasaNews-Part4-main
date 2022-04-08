//
//  ArticleView.swift
//  NasaNews
//
//  Created by Tzy on 18.03.2022.
//

import UIKit
import WebKit

protocol ArticleViewType: AnyObject {
    func setStars(rating: Int)
}

final class ArticleView: UIViewController {
    // MARK: UI
    @IBOutlet var webView: WKWebView?
    @IBOutlet weak var starCollection: StarCollection!
    
    var presenter: ArticlePresenter?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.shouldLoadData()
        configure()
    }
    
    private func configure() {
        guard let item = presenter?.item else {
            return
        }

        title = item.title
        webView?.loadHTMLString(item.body, baseURL: nil)
        starCollection.delegate = presenter
    }
    
}


extension ArticleView: ArticleViewType {
    func setStars(rating: Int) {
        starCollection.setStars(rating)
    }
}

