//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func configureWith(recipe: Recipe) {
        self.recipeTitle?.text = String("Title: \(recipe.title)")
        self.recipeIngredients?.text = String("Ingredients: \(recipe.ingredients)")
        self.activityIndicatorView.isHidden = false
        self.recipeImageView.sd_setImage(with: URL(string: recipe.thumbnail), placeholderImage: UIImage(named: "recipePlaceholder")) { (_, _, _, _) in
            self.activityIndicatorView.isHidden = true
        }
    }
}
