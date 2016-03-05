//
//  ViewController.swift
//  pokedex
//
//  Created by Vihang Godbole on 13/02/16.
//  Copyright © 2016 vihanggodbole. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokedexLabel: UILabel!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collection.delegate = self
        collection.dataSource = self
        
        
        collection.showsVerticalScrollIndicator = false
        searchBar.returnKeyType = UIReturnKeyType.Done
        (searchBar.valueForKey("searchField") as? UITextField)?.textColor = UIColor.whiteColor()
        parsePokemonCSV()
    }
    


    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let pokeName = row["identifier"]!
                let pokeId = Int(row["id"]!)!
                let poke = Pokemon(name: pokeName, pokedexId: pokeId)
                pokemon.append(poke)
                
            }
           
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            
            let poke: Pokemon!
            
            if isSearching {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            
            cell.configureCell(poke)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 90)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke:Pokemon!
        
         if isSearching {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegueWithIdentifier("ShowPokeDetail", sender: poke)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            searchBar.endEditing(true)
            collection.reloadData()
        } else {
            isSearching = true
            let lower = searchBar.text?.lowercaseString
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower!) != nil})
            collection.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPokeDetail" {
            if let destVC = segue.destinationViewController as? PokeDetailVC {
                if let poke = sender as? Pokemon {
                    destVC.pokemon = poke                }
            }
        }
    }

}

