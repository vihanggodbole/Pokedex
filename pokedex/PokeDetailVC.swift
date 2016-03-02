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


    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadDetails { () -> () in
            self.updateUI()
        }
        
    }
    func updateUI(){
        typeLabel.text = pokemon.type
        attackLabel.text = String(pokemon.stats["attack"]!)
        defenseLabel.text = String(pokemon.stats["defense"]!)
        heightLabel.text = String(pokemon.stats["height"]!)
        weightLabel.text = String(pokemon.stats["weight"]!)
        pokeIdLabel.text = String(pokemon.pokedexId)

        print(pokemon.nextEvolutionText)
    }

    @IBAction func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
