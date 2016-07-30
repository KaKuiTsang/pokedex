//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Tsang Ka Kui on 28/7/2016.
//  Copyright © 2016年 Tsang Ka Kui. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailViewController: UIViewController {
    
    private weak var bioViewController: BioViewController!
    
    @IBOutlet weak var PokemonNameLabel: UILabel!
    
    @IBOutlet weak var BioView: UIView!
    
    @IBOutlet weak var StatView: UIView!
    
    @IBOutlet weak var MoveView: UIView!
    
    var data: [String: AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pokemon = data["pokemon"] as! Pokemon
        let index = String(format: "%03d", Int(pokemon.index)!)
        let height = data["height"]!
        let weight = data["weight"]!
        let ability = data["abilities"] as! String
        PokemonNameLabel.text = pokemon.name.capitalizedString
        bioViewController.PokemonImageView.image = UIImage(named: "\(pokemon.index).png")
        bioViewController.heightLabel.text = "\(height)"
        bioViewController.weightLabel.text = "\(weight)"
        bioViewController.abilityLabel.text = ability
        bioViewController.indexLabel.text = "#\(index)"
    }

    @IBAction func didPressBackButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressSegmentControllButton(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: { 
                self.BioView.hidden = false
                self.StatView.hidden = true
                self.MoveView.hidden = true
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animateWithDuration(0.5, animations: {
                self.BioView.hidden = true
                self.StatView.hidden = false
                self.MoveView.hidden = true
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.BioView.hidden = true
                self.StatView.hidden = true
                self.MoveView.hidden = false
            })
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "BioVIew" {
            if let bioViewController = segue.destinationViewController as? BioViewController {
                self.bioViewController = bioViewController
            }
        }

        
    }
}
