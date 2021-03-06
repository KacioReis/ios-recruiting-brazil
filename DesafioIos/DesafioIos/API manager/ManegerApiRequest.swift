//
//  ManegerApiRequest.swift
//  DesafioIos
//
//  Created by Kacio Henrique Couto Batista on 12/12/19.
//  Copyright © 2019 Kacio Henrique Couto Batista. All rights reserved.
//

import Foundation
public final class ManegerApiRequest{
    private var numPages = 1
    var dataToSend:[Movie] = [] {
        didSet{
            if Int(Double(self.numPages) * 20.0 * 0.8) <= self.dataToSend.count{
                self.delegate?.sendMovie(movies: self.dataToSend)
                let seconds = 5.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.delegate?.sendStatus(status: .finish)
                   
                }
            }
        }
    }
   
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
        }
    }
    init() {
        self.getGenres()
    }
    func sendMovies(numPage:Int){
        self.delegate?.sendStatus(status: .sending)
        DispatchQueue.main.async {
            self.numPages = numPage
            let querysPopularMovies = self.createQuerysMoviesPopular(quant:numPage)
            querysPopularMovies.forEach { query in
                self.getRequest(querys: query) { (catolog) in
                    self.addToDataToSend(movies: catolog.results)
                }
            }
        }
    }
    private func addToDataToSend(movies:[Movie]){
        for movie in movies {
            if !self.dataToSend.contains { (previoMovies) -> Bool in
                return movie.id == previoMovies.id
                }{
                self.dataToSend.append(movie)
            }
        }
    }
    private func createQuerysMoviesPopular(quant:Int)->[[String:Any]]{
        var querys : [[String:Any]] = []
        for i in 1...quant + 1{
            let query:[String:Any] = ["api_key":ManegerApiRequest.apiKey,
                                      "page":"\(i)",
                "language":"en-US",
                "region":"US"]
            querys.append(query)
        }
        return querys
    }
    // MARK: - Get movies
    func getRequest(querys:[String:Any],completion: @escaping (_ results: Movies) -> Void) {
        guard var urlComponents = URLComponents(string: urlMoviePopular) else{
            print("erro no component url")
            return
        }
        urlComponents.queryItems = creatQuery(json: querys)
        guard let url = urlComponents.url else{
            print("erro ao montar url")
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
                    self.delegate?.sendStatus(status: .dontConnection)
                    print("error1")
                }
            }
            catch{
                print(error.localizedDescription)
                self.delegate?.sendStatus(status: .dontConnection)
                print("error2")
            }
        }.resume()
    }
    func getGenres(){
        self.requestGenres(url: urlGenresMovies, data: queryGenre) { (allGenres) in
            ManegerApiRequest.genres = allGenres.genres
            print("request genres")
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
    private func creatQuery(json:[String:Any])->[URLQueryItem]{
        var querys:[URLQueryItem] = []
        for query in json{
            querys.append(URLQueryItem(name: query.key, value: query.value as? String))
        }
        return querys
    }

}
