//
//  FavoriteListViewModel.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit

protocol FavoriteListViewModelDelegate: class {
    func displayFavoriteList(_ viewModel: FavoriteListViewModel)
}

class FavoriteListViewModel: NSObject {
    weak var delegate: FavoriteListViewModelDelegate?
    var favorites: [Recipe] = []
    
    override init() {
        super.init()
    }
    
    func displayFavorites() {
        favorites = Utility.retrive()
        self.delegate?.displayFavoriteList(self)
    }
}
