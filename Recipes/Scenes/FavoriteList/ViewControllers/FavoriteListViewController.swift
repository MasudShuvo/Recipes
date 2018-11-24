//
//  FavoriteListViewController.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: FavoriteListViewModel = {
        let vm = FavoriteListViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.displayFavorites()
    }
    
    private func displayDetailsFor(recipe: Recipe) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let recipeViewController = storyboard.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController
        recipeViewController.recipe = recipe
        self.navigationController?.pushViewController(recipeViewController, animated: true)
    }
}

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! RecipeTableViewCell
        let recipe = viewModel.favorites[indexPath.row]
        cell.configureWith(recipe: recipe)
        return cell
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        displayDetailsFor(recipe: viewModel.favorites[indexPath.row])
    }
}

extension FavoriteListViewController: FavoriteListViewModelDelegate {
    func displayFavoriteList(_ viewModel: FavoriteListViewModel) {
        tableView.reloadData()
    }
}
