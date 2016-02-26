 //
//  Pokemon.swift
//  pokedex
//
//  Created by Vihang Godbole on 13/02/16.
//  Copyright © 2016 vihanggodbole. All rights reserved.
//

import Foundation
import Alamofire
 
class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: Int!
    private var _attack: Int!
    private var _height: Int!
    private var _weight: Int!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadDetails(completed: DownloadCompleted) {
        let url = NSURL(string: self._pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success(let data):
                let result = data
                print(result.debugDescription)
                if let dict = result as? Dictionary<String,AnyObject> {
                    if let weight = dict["weight"] as? Int {
                        self._weight = weight
                        print(self._weight)
                        print("found weight")
                    }
                    
                    if let height = dict["height"] as? Int {
                        self._height = height
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        self._attack = attack
                    }
                    
                    if let def = dict["defense"] as? Int {
                        self._defense = def
                    }
                    
                    if let types = dict["types"] as? [Dictionary<String,AnyObject>] {
                        if let type = types[0]["type"] {
                            if let name = type["name"] {
                                self._type = name as! String
                            }
                        }
                        if types.count > 1 {
                            for var x = 1; x < types.count; x++ {
                                if let type = types[x]["type"] {
                                    if let name = type["name"] {
                                        self._type! += "/\(name as! String)"
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        self._type = ""
                    }
                   print(self._type)
                }
                

            case .Failure(let error):
                print("Request failed with error: \(error)")

            }
        }
    }
 
 }