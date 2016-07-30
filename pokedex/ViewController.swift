//
//  ViewController.swift
//  pokedex
//
//  Created by Tsang Ka Kui on 27/7/2016.
//  Copyright © 2016年 Tsang Ka Kui. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    @IBOutlet weak var collecetionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var backgroundMusicButton: UIButton!
    
    var backgroundMusicPlayer: AVAudioPlayer!

    var pokemons = [Pokemon]()
    
    var filteredPokemons = [Pokemon]()
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collecetionView.delegate = self
        collecetionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .Done
        fetchPokemonsFromCSV()
        playBackgroundMusic()
    }
    
    func fetchPokemonsFromCSV() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            
            for row in csv.rows {
                let index = row["id"]!
                let name = row["identifier"]!
                let type = ["Grass", "Poison"]
                let pokemon = Pokemon(index: index, name: name, type: type)
                pokemons.append(pokemon)
            }
            
        } catch let error as NSError{
            print(error.debugDescription)
        }
        
    }
    
    func playBackgroundMusic() {
        let path = NSBundle.mainBundle().URLForResource("opening", withExtension:  "mp3")!
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: path)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print("\(error.debugDescription)")
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isSearching == true {return filteredPokemons.count}
        
        return pokemons.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.frame.size.width
        
        let collectionViewHeight = collectionView.frame.size.height
        
        let cellWidth = collectionViewWidth / 3 - 10
        
        let cellHeight = collectionViewHeight / 3 - 7
        
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = collecetionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCell else {
            return UICollectionViewCell()
        }
        
        let pokemon: Pokemon!
        
        if isSearching == true {
            pokemon = filteredPokemons[indexPath.row]
        } else {
           pokemon = pokemons[indexPath.row]
        }
        
        cell.configure(pokemon)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pokemon = pokemons[indexPath.row]
        fetchPokemonDetail(pokemon)
    }
    
    func fetchPokemonDetail(pokemon: Pokemon) {
        
        let url = "http://pokeapi.co/api/v2/pokemon/\(pokemon.index)"
        
        Alamofire.request(.GET, url).responseJSON { response in
            
            let result = response.result
            
            guard result.isSuccess == true else { return print(result.error) }
            
            let data = result.value as! [String: AnyObject]
            
            let height = data["height"]!
            
            let weight = data["weight"]!
            
            var abilities = [String]()
            
            let abilityObjects = data["abilities"] as! [[String: AnyObject]]
        
            for item in abilityObjects {
                
                let ability = item["ability"] as! [String: AnyObject]
                
                let name = ability["name"] as! String
                
                abilities.append(name.capitalizedString)
            }
            
            let abilitiesString = abilities.joinWithSeparator(" / ")
            
            let sender : [String: AnyObject] = ["pokemon": pokemon, "height": height, "weight": weight, "abilities": abilitiesString]
            
            self.backgroundMusicPlayer.stop()
            self.backgroundMusicButton.alpha = 0.3
            self.performSegueWithIdentifier("PokemonDetail", sender: sender)
            
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "PokemonDetail" {
            if let detailController = segue.destinationViewController as? PokemonDetailViewController {
                if let data = sender as? [String : AnyObject] {
                    detailController.data = data
                }
            }
        }
        
    }
    
    @IBAction func didPressSoundButton(sender: UIButton) {
        if backgroundMusicPlayer.playing == true {
            backgroundMusicPlayer.pause()
            sender.alpha = 0.3
        } else {
            backgroundMusicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let text = searchBar.text where text != ""  {
            isSearching = true
            let lowercaseText = text.lowercaseString
            filteredPokemons = pokemons.filter { $0.name.rangeOfString(lowercaseText) != nil}
            collecetionView.reloadData()
        } else {
            isSearching = false
            view.endEditing(true)
            collecetionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

