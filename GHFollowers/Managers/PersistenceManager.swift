//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by ioannis on 17/6/23.
//

import Foundation
enum PeristenceActionType{
    case add, remove
}


enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite:Follower,actionType: PeristenceActionType,completed:@escaping(GFError?)->Void){
        retrieveFavorites { result in
            switch result {
            case .success (let favorites):
                var retreivedFavorites = favorites
                switch actionType {
                case.add :
                    guard !retreivedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    retreivedFavorites.append(favorite)
                case .remove:
                    retreivedFavorites.removeAll {$0.login == favorite.login}
                }
                completed(save(favorites: retreivedFavorites))
            case .failure(let error):
                completed(error)
            }
            
        }
    }
    
    
    static func retrieveFavorites(completed:@escaping(Result<[Follower],GFError>)->Void)  {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
        
    }
    
    
    static func save(favorites:[Follower])-> GFError?{
        do {
            let encoder = JSONEncoder()
            let encodedFavorites  = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        }catch {
            return .unableToFavorite
        }
        
    }
}

