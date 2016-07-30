//
//  Pokemon.swift
//  pokedex
//
//  Created by Tsang Ka Kui on 27/7/2016.
//  Copyright © 2016年 Tsang Ka Kui. All rights reserved.
//

import Foundation

class Pokemon {
    private var _index: String
    private var _name: String
    private var _type: [String]
    
    var index: String {
        return _index
    }
    
    var name: String {
        return _name
    }
    
    var type: [String]{
        return _type
    }
    
    init(index: String, name: String, type:[String]) {
        self._index = index
        self._name = name
        self._type = type
    }
    
}