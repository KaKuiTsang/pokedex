//
//  PokemonCell.swift
//  pokedex
//
//  Created by Tsang Ka Kui on 27/7/2016.
//  Copyright © 2016年 Tsang Ka Kui. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var PokemonImageView: UIImageView!
    
    @IBOutlet weak var PokemonIndexLabel: UILabel!
    
    @IBOutlet weak var PokemonNameLabel: UILabel!
    
    @IBOutlet weak var PokemonFirstTypeLabel: UILabel!
    
    @IBOutlet weak var PokemonSecondTypLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0).CGColor
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }
    
    func configure(pokemon: Pokemon) {
        let index = String(format: "%03d", Int(pokemon.index)!)
        PokemonImageView.image = UIImage(named: "\(pokemon.index).png")
        PokemonIndexLabel.text = "#\(index)"
        PokemonNameLabel.text = "\(pokemon.name.capitalizedString)"
    }
    
}
