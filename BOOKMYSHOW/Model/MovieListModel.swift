//
//  MovieListModel.swift
//  BOOKMYSHOW
//
//  Created by Sanjay Mali on 22/02/19.
//  Copyright © 2019 LoyltyRewardz. All rights reserved.
//

import Foundation
struct BaseModel:Decodable {
    let results:[MovieListModel]?
    let page:Int?
    let total_pages:Int?
}
struct MovieListModel: Decodable{
    let vote_count:Int?
    let id:Int?
    let video:Bool?
    let vote_average:Double?
    let title:String?
    let popularity:Double?
    let poster_path:String?
    let original_language:String?
    let original_title:String?
    let backdrop_path:String?
    let adult:Bool?
    let overview:String?
    let release_date:String?
}

struct  CreditBaseModel:Decodable{
    let id:Int?
    let cast:[CreditModel]?
}
struct CreditModel:Decodable {
    let cast_id:Int??
    let character:String?
    let credit_id:String?
    let gender:Int?
    let id:Int?
    let name:String?
    let order:Int?
    let profile_path:String?
}
