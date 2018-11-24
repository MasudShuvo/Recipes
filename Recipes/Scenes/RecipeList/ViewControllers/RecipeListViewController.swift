//
//  RecipeListViewController.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit
import Moya

class RecipeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var searchCancelButton: UIButton!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    lazy var viewModel: RecipeListViewModel = {
        let recipeService = RecipeListService(provider:MoyaProvider<RecipeListServiceTarget>())
        let vm = RecipeListViewModel(recipeService: recipeService)
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite List", style: .plain, target: self, action: #selector(favoriteButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Recipe", style: .plain, target: self, action: #selector(addRecipeButtonTapped))
        viewModel.fetchRecipes()
    }
    
    @objc func favoriteButtonTapped() {
        displayFavoriteList()
    }
    
    @objc func addRecipeButtonTapped() {
        let alert = UIAlertController(title: nil, message: "Under Construction", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchCancelButtonTapped(_ sender: Any) {
        searchCancelButton.isHidden = true
        searchResultLabel.text = ""
        tableViewTop.constant = 0
        viewModel.updateRecipeList(searchString: "")
        searchBar.text = ""
    }
    
    private func displayDetailsFor(recipe: Recipe) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let recipeViewController = storyboard.instantiateViewController(withIdentifier: "recipeViewController") as! RecipeViewController
        recipeViewController.recipe = recipe
        self.navigationController?.pushViewController(recipeViewController, animated: true)
    }
    
    private func displayFavoriteList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favoriteViewController = storyboard.instantiateViewController(withIdentifier: "favoriteViewController") as! FavoriteListViewController
        self.navigationController?.pushViewController(favoriteViewController, animated: true)
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! RecipeTableViewCell
        let recipe = viewModel.recipes[indexPath.row]
        cell.configureWith(recipe: recipe)
        return cell
    }
}

extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        displayDetailsFor(recipe: viewModel.recipes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.recipes.count - 2 {
            viewModel.fetchRecipes()
        }
    }
}

extension RecipeListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        if searchText.count > 0 {
            tableViewTop.constant = 40
            searchCancelButton.isHidden = false
            searchResultLabel.text = String("Search result for '\(searchText)'")
            viewModel.updateRecipeList(searchString: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension RecipeListViewController: RecipeListViewModelDelegate {
    func updateRecipeList(_ viewModel: RecipeListViewModel) {
        tableView.reloadData()
    }
}
