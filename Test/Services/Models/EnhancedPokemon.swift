import Foundation

struct EnhancedPokemon: Decodable, Equatable {
    
    static func == (lhs: EnhancedPokemon, rhs: EnhancedPokemon) -> Bool {
        return lhs.abilities == rhs.abilities && lhs.height == rhs.height && lhs.id == rhs.id && lhs.name == rhs.name && lhs.species == rhs.species && lhs.pictureUrlString == rhs.pictureUrlString && lhs.stats == rhs.stats && lhs.types == rhs.types && lhs.weight == rhs.weight
    }
    
    let abilities: [Species]?
    let height: Int?
    let id: Int?
    let name: String?
    let species: Species?
    var pictureUrlString: String?
    let stats: [Stat]?
    let types: [Species]?
    let weight: Int?
    
    init(pokemon: Pokemon) {
        if let abilities = pokemon.abilities {
            var abilitiesArray: [Species] = []
            for abilityElement in abilities {
                if let ability = abilityElement.ability {
                    abilitiesArray.append(ability)
                }
            }
            self.abilities = abilitiesArray
        } else {
            self.abilities = nil
        }
        
        if let types = pokemon.types {
            var typesArray: [Species] = []
            for typeElement in types {
                if let type = typeElement.type {
                    typesArray.append(type)
                }
            }
            self.types = typesArray
        } else {
            self.types = nil
        }
        
        self.height = pokemon.height
        self.id = pokemon.id
        self.name = pokemon.name
        self.species = pokemon.species
        self.pictureUrlString = pokemon.sprites?.frontDefault
        self.stats = pokemon.stats
        self.weight = pokemon.weight
    }
}

extension EnhancedPokemon {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["abilities"] = abilities?.map { $0.toDictionary() }
        dict["height"] = height
        dict["id"] = id
        dict["name"] = name
        dict["species"] = species?.toDictionary()
        dict["pictureUrlString"] = pictureUrlString
        dict["stats"] = stats?.map { $0.toDictionary() }
        dict["types"] = types?.map { $0.toDictionary() }
        dict["weight"] = weight
        
        return dict
    }
}

extension Species {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["name"] = name
        dict["url"] = url
        
        return dict
    }
}

extension Stat {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["base_stat"] = baseStat
        dict["stat"] = stat?.toDictionary()
        
        return dict
    }
}
