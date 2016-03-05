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
    @IBOutlet weak var baseHpLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!

    @IBOutlet weak var bioStackView: UIStackView!
    @IBOutlet weak var evoStackView: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var evoChainImage1: UIImageView!
    @IBOutlet weak var evoChainImage2: UIImageView!
    @IBOutlet weak var evoChainText1: UILabel!
    @IBOutlet weak var evoChainText2: UILabel!
    
    @IBOutlet weak var evoChainImage3: UIImageView!
    @IBOutlet weak var evoChainText3: UILabel!
    
    var isLoading = true
    var pokemon: Pokemon!
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        setupActivityIndicator()
        
        pokemon.downloadDetails { () -> () in
            self.isLoading = false
            self.updateUI(self.segmentedControl)
            self.updateBioUI()
            self.updateEvoUI()
        }
        
    }
    
    func updateUI(segmentedControl: UISegmentedControl){
        if isLoading == false {
            activityIndicator.stopAnimating()
        }
        if segmentedControl.selectedSegmentIndex == 0 && isLoading == false {
            evoStackView.hidden = true
            bioStackView.hidden = false
        } else if segmentedControl.selectedSegmentIndex == 1 && isLoading == false {
            bioStackView.hidden = true
            evoStackView.hidden = false
        }
        

    }
    
    func updateBioUI(){
        typeLabel.text = pokemon.type
        attackLabel.text = String(pokemon.stats["attack"]!)
        defenseLabel.text = String(pokemon.stats["defense"]!)
        heightLabel.text = String(pokemon.stats["height"]!)
        weightLabel.text = String(pokemon.stats["weight"]!)
        pokeIdLabel.text = String(pokemon.pokedexId)
        baseHpLabel.text = String(pokemon.stats["baseHp"]!)
        speedLabel.text = String(pokemon.stats["speed"]!)
        specialAttackLabel.text = String(pokemon.stats["specialAttack"]!)
        specialDefenseLabel.text = String(pokemon.stats["specialDefense"]!)
    }
    
    func updateEvoUI(){
        switch (pokemon.evolutionChain.count) {
        case 1:
            evoChainText1.text = pokemon.evolutionChain[0].capitalizedString
            evoChainImage1.image = UIImage(named: pokemon.evolutionChainId[0])
        case 2:
            evoChainText1.text = pokemon.evolutionChain[0].capitalizedString
            evoChainImage1.image = UIImage(named: pokemon.evolutionChainId[0])
            evoChainText2.text = pokemon.evolutionChain[1].capitalizedString
            evoChainImage2.image = UIImage(named: pokemon.evolutionChainId[1])
        case 3:
            evoChainText1.text = pokemon.evolutionChain[0].capitalizedString
            evoChainImage1.image = UIImage(named: pokemon.evolutionChainId[0])
            evoChainText2.text = pokemon.evolutionChain[1].capitalizedString
            evoChainImage2.image = UIImage(named: pokemon.evolutionChainId[1])
            evoChainText3.text = pokemon.evolutionChain[2].capitalizedString
            evoChainImage3.image = UIImage(named: pokemon.evolutionChainId[2])
        default: print("Don't know how to handle more than 3 evolutions!")
        }
    }
    
    func setupActivityIndicator(){
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @IBAction func goBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func segmentChanged(sender: UISegmentedControl) {
        updateUI(sender)
    }
    
}
