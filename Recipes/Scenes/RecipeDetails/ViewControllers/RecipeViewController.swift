//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    var recipe: Recipe!
    
    lazy var button: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        btn.setImage(UIImage(named: "unfavorite"), for: .normal)
        btn.setImage(UIImage(named: "favorite"), for: .selected)
        btn.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var viewModel: RecipeViewModel = {
        let vm = RecipeViewModel(recipe: self.recipe)
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        viewModel.displayRecipe()
        button.isSelected = viewModel.isFavorite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func favoriteButtonTapped() {
        if button.isSelected == true {
            viewModel.removeFromFavorite()
            button.isSelected = false
        } else {
            viewModel.addToFavorite()
            button.isSelected = true
        }
    }
}

extension RecipeViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.isHidden = true
    }
}

extension RecipeViewController: RecipeViewModelDelegate {
    func displayRecipe(_ viewModel: RecipeViewModel, urlRequest: URLRequest) {
        activityIndicatorView.isHidden = false
        webView.loadRequest(urlRequest)
    }
}
