import Foundation

struct EnhancedItem: Decodable/*, Equatable*/ {
    
//    static func == (lhs: EnhancedItem, rhs: EnhancedItem) -> Bool {
//        return lhs.abilities == rhs.abilities && lhs.height == rhs.height && lhs.id == rhs.id && lhs.name == rhs.name && lhs.species == rhs.species && lhs.pictureUrlString == rhs.pictureUrlString && lhs.stats == rhs.stats && lhs.types == rhs.types && lhs.weight == rhs.weight
//    }
    
    let attributes: [String]?
    let category: String?
    let cost: Int?
    let effects: [String]?
    let id: Int?
    let name: String?
    let pictureUrlString: String?
    
    init(item: Item) {
        if let attributes = item.attributes {
            var attributesArray: [String] = []
            for attributeElement in attributes {
                if let attribute = attributeElement.name {
                    attributesArray.append(attribute)
                }
            }
            self.attributes = attributesArray
        } else {
            self.attributes = nil
        }
        
        if let effects = item.effectEntries {
            var effectsArray: [String] = []
            for effectsElement in effects {
                if let effect = effectsElement.shortEffect {
                    effectsArray.append(effect)
                }
            }
            self.effects = effectsArray
        } else {
            self.effects = nil
        }
        
        self.category = item.category?.name
        self.cost = item.cost
        self.id = item.id
        self.name = item.name
        self.pictureUrlString = item.sprites?.spritesDefault
    }
}

//extension EnhancedItem {
//    func toDictionary() -> [String: Any] {
//        var dict: [String: Any] = [:]
//        
//        dict["abilities"] = abilities?.map { $0.toDictionary() }
//        dict["height"] = height
//        dict["id"] = id
//        dict["name"] = name
//        dict["species"] = species?.toDictionary()
//        dict["pictureUrlString"] = pictureUrlString
//        dict["stats"] = stats?.map { $0.toDictionary() }
//        dict["types"] = types?.map { $0.toDictionary() }
//        dict["weight"] = weight
//        
//        return dict
//    }
//}
//
//extension Species {
//    func toDictionary() -> [String: Any] {
//        var dict: [String: Any] = [:]
//        
//        dict["name"] = name
//        dict["url"] = url
//        
//        return dict
//    }
//}
//
//extension Stat {
//    func toDictionary() -> [String: Any] {
//        var dict: [String: Any] = [:]
//        
//        dict["base_stat"] = baseStat
//        dict["stat"] = stat?.toDictionary()
//        
//        return dict
//    }
//}
