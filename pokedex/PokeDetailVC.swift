//
//  PokeDetailVC.swift
//  pokedex
//
//  Created by Vihang Godbole on 14/02/16.
//  Copyright © 2016 vihanggodbole. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokeIdLabel: UILabel!
    @IBOutlet weak var nextEvoLabel: UILabel!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var thirdEvoImage: UIImageView!

    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadDetails { () -> () in
            
        }
        
    }

    @IBAction func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
