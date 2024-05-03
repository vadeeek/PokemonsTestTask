import Foundation

struct Sprites: Decodable {
    
    let frontDefault: String?
    let spritesDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case spritesDefault = "default"
    }
    // FIXME: - убрать этот код
    //    init(frontDefault: String?) {
    //        self.frontDefault = frontDefault
    //    }
}
