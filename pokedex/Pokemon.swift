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
    private var _pokemonURL: String!
    private var _evolutionChain: String!
    private var _evolutionChainId = [String]()
    private var _stats = [String:Int]()
    private var _didFinishDownloadingBio = false
    private var _didFinishDownloadingEvo = false
    private var _didFinishDownloadingDesc = false
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        return _description
    }
    
    var type: String {
        return _type
    }
    
    var stats: Dictionary<String,Int> {
        return _stats
    }
    
    var evolutionChain: Array<String>{
        return _evolutionChain.componentsSeparatedByString(",")
    }
    
    var evolutionChainId: Array<String> {
        return _evolutionChainId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._evolutionChain = ""
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadDetails(completed: DownloadCompleted) {
        let url = NSURL(string: self._pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            switch response.result {
            case .Success(let data):
                let result = data
                self._didFinishDownloadingBio = true
                if let dict = result as? Dictionary<String,AnyObject> {
                    if let weight = dict["weight"] as? Int {
                        self._stats["weight"] = weight
                    }
                    
                    if let height = dict["height"] as? Int {
                        self._stats["height"] = height
                    }
                    
                    if let stats = dict["stats"] as? [Dictionary<String,AnyObject>] {
                        if let speed = stats[0]["base_stat"] as? Int {
                            self._stats["speed"] = speed
                        }
                        if let spDef = stats[1]["base_stat"] as? Int {
                            self._stats["specialDefense"] = spDef
                        }
                        if let spAtt = stats[2]["base_stat"] as? Int {
                            self._stats["specialAttack"] = spAtt
                        }
                        if let def = stats[3]["base_stat"] as? Int {
                            self._stats["defense"] = def
                        }
                        if let att = stats[4]["base_stat"] as? Int {
                            self._stats["attack"] = att
                        }
                        if let hp = stats[5]["base_stat"] as? Int {
                            self._stats["baseHp"] = hp
                        }
                    }
                    if let types = dict["types"] as? [Dictionary<String,AnyObject>] {
                        if let type = types[0]["type"] {
                            if let name = type["name"] {
                                self._type = ("\(name as! String)").capitalizedString
                            }
                        }
                        if types.count > 1 {
                            for var x = 1; x < types.count; x++ {
                                if let type = types[x]["type"] {
                                    if let name = type["name"] {
                                        self._type! += "/\(name as! String)".capitalizedString
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        self._type = ""
                    }
                }
                if self._didFinishDownloadingEvo == true && self._didFinishDownloadingDesc == true { completed() }

            case .Failure(let error):
                print("Request failed with error: \(error)")

            }
        }
    //end of first network call.
        // call poke species to get evo chain url.
        let speciesString = "\(URL_BASE)\(URL_POKEMON_SPECIES)\(self.pokedexId)/"
        let speciesURL = NSURL(string: speciesString)!
        Alamofire.request(.GET, speciesURL).responseJSON{ response in
            switch response.result {
            case .Success(let data):
                if let dict = data as? Dictionary<String,AnyObject>{
                    if let flavorText = dict["flavor_text_entries"] as? [Dictionary<String,AnyObject>] {
                        if let engDescription = flavorText[1]["flavor_text"] where flavorText[1]["language"]!["name"] as? String == "en" {
                            self._description = engDescription as! String
                        } else {
                            self._description = "Description not found."
                        }
                        self._didFinishDownloadingDesc = true
                        if self._didFinishDownloadingBio == true && self._didFinishDownloadingEvo == true { completed() }
                    }
                    if let evolutionChain = dict["evolution_chain"] as? Dictionary<String,String>{
                        if let evolutionChainString = evolutionChain["url"]{
                            //calling evolution chain .GET from the url obtained from species.
                            let evoURL = NSURL(string: evolutionChainString)!
                            Alamofire.request(.GET, evoURL).responseJSON{ response in
                                switch response.result{
                                case .Success(let data):
                                    self._didFinishDownloadingEvo = true
                                    if let result = data as? Dictionary<String,AnyObject>{
                                        if let chain = result["chain"] as? Dictionary<String,AnyObject>{
                                            if let species = chain["species"] as? Dictionary<String,AnyObject> {
                                                self._evolutionChain! += "\(species["name"] as! String)"
                                                var nextEvo = species["url"] as! String
                                                nextEvo = nextEvo.stringByReplacingOccurrencesOfString("http://pokeapi.co/api/v2/pokemon-species/", withString: "")
                                                nextEvo = nextEvo.stringByReplacingOccurrencesOfString("/", withString: "")
                                                self._evolutionChainId.append(nextEvo)
                                            }
                                            if let evolvesTo = chain["evolves_to"] as? [Dictionary<String,AnyObject>] where evolvesTo.count > 0 {
                                                if let species = evolvesTo[0]["species"] as? Dictionary<String,AnyObject> {
                                                    self._evolutionChain! += ",\(species["name"] as! String)"
                                                    var nextEvo = species["url"] as! String
                                                    nextEvo = nextEvo.stringByReplacingOccurrencesOfString("http://pokeapi.co/api/v2/pokemon-species/", withString: "")
                                                    nextEvo = nextEvo.stringByReplacingOccurrencesOfString("/", withString: "")
                                                    self._evolutionChainId.append(nextEvo)
                                                    if let thirdEvo = evolvesTo[0]["evolves_to"] as? [Dictionary<String,AnyObject>] where thirdEvo.count > 0 {
                                                        if let species = thirdEvo[0]["species"] as? Dictionary<String,AnyObject> {
                                                            self._evolutionChain! += ",\(species["name"] as! String)"
                                                            var nextEvo = species["url"] as! String
                                                            nextEvo = nextEvo.stringByReplacingOccurrencesOfString("http://pokeapi.co/api/v2/pokemon-species/", withString: "")
                                                            nextEvo = nextEvo.stringByReplacingOccurrencesOfString("/", withString: "")
                                                            self._evolutionChainId.append(nextEvo)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    if self._didFinishDownloadingBio == true && self._didFinishDownloadingDesc == true { completed() }
                                case .Failure(let error):
                                    print("Request failed with error: \(error)")
                                }
                            }
                        }
                    }
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
 
 }