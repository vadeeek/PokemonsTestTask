import UIKit

enum Resources {
    enum Colors {
        static var active = UIColor.systemOrange
        //        static var inactive = UIColor.systemGray
        
        static var separator = UIColor.darkGray
    }
    
    enum Strings {
        enum TabBar {
            static var pokemons = "Pokemons"
            static var items = "Items"
            static var compare = "Compare"
            static var profile = "Profile"
        }
    }
    
    enum Images {
        enum LaunchScreen {
            static var pokemonLabel = UIImage(named: "pokemonLabel")
            static var pokeball = UIImage(named: "pokeball")
        }
        enum Pokemon {
            static var pokemonPictureNoImage = UIImage(named: "noImage")
        }
        enum Item {
            static var itemPictureNoImage = UIImage(named: "noImage") // FIXME: поменять изображение на другое для items
        }
        enum DetailsScreen {
            static var evolutionBG = UIImage(named: "evolutionBG")
            static var evolutionArrow = UIImage(named: "arrow")
        }
        enum TabBar {
            static var pokemons_unselected = UIImage(systemName: "person")
            static var pokemons_selected = UIImage(systemName: "person.fill")
            static var items_unselected = UIImage(systemName: "shippingbox")
            static var items_selected = UIImage(systemName: "shippingbox.fill")
            static var compare_unselected = UIImage(systemName: "arrow.left.arrow.right.square")
            static var compare_selected = UIImage(systemName: "arrow.left.arrow.right.square.fill")
            static var profile_unselected = UIImage(systemName: "person")
            static var profile_selected = UIImage(systemName: "person.fill")
        }
    }
}
