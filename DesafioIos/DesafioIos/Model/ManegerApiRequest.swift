//
//  ManegerApiRequest.swift
//  DesafioIos
//
//  Created by Kacio Henrique Couto Batista on 12/12/19.
//  Copyright © 2019 Kacio Henrique Couto Batista. All rights reserved.
//

import Foundation
class ManegerApiRequest{
    static let apiKey = "21f18125f6767ae14a2f2577d85de3db"
    var delegate:SendDataApi?
    
    let queryGenre = ["api_key":apiKey,
                      "language":"en-US"]
    
    //MARK: - url Movie Popular
    let urlMoviePopular = "https://api.themoviedb.org/3/movie/popular"
    //MARK: - url genres Movies
    let urlGenresMovies = "https://api.themoviedb.org/3/genre/movie/list"
    static var genres:[Genre] = [] {
        didSet{
            print("load all genres")
        }
    }
    init() {
        self.getGenres()
    }
    func sendMovies(){
        for i in 1...100{
            let queryMoviesPopular:[String:Any] =  ["api_key":ManegerApiRequest.apiKey,
                                                    "page":"\(i)",
                "language":"en-US",
                "region":"US"]
            self.getRequest(querys: queryMoviesPopular) { (catalog) in
                self.delegate?.sendMovie(movies: catalog.results)
                self.delegate?.sendStatus(status: .send)
                self.delegate?.sendStatus(status: .finish)
            }
        }
        
        
    }
    // MARK: - Get movies
    func getRequest(querys:[String:Any],completion: @escaping (_ results: Movies) -> Void) {
        guard var urlComponents = URLComponents(string: urlMoviePopular) else{
            return
        }
        urlComponents.queryItems = creatQuery(json: querys)
        guard let url = urlComponents.url else{
            return
        }
        URLSession.shared.dataTask(with: url){
            (data,_,error) in
            do{
                if let data = data {
                    if let movies = try? JSONDecoder().decode(Movies.self, from: data){
                        completion(movies)
                    }
                }
                else{
                    print("error")
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
    func getGenres(){
        self.requestGenres(url: urlGenresMovies, data: queryGenre) { (allGenres) in
            ManegerApiRequest.genres = allGenres.genres
        }
    }


    // MARK: - request Genres
    func requestGenres(url:String,data:[String:Any],completion: @escaping (_ results: AllGenres) -> Void){
        guard var urlComponents = URLComponents(string: url) else{
            return
        }
        urlComponents.queryItems = creatQuery(json: data)
        guard let url = urlComponents.url else{
            return
        }
        URLSession.shared.dataTask(with: url){
            (data,_,error) in
            do{
                if let data = data {
                    if let genres = try? JSONDecoder().decode(AllGenres.self, from: data){
                        completion(genres)
                    }
                }
                else{
                    print("error")
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
}
