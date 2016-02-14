//
//  PokeCell.swift
//  pokedex
//
//  Created by Vihang Godbole on 13/02/16.
//  Copyright © 2016 vihanggodbole. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokeImg: UIImageView!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLabel.text = self.pokemon.name.capitalizedString
        pokeImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 43
    }

}
