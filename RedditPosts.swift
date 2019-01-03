//
//  RedditPosts.swift
//  RedditTutorial
//
//  Created by Will Bishop on 3/1/19.
//  Copyright © 2019 Will Bishop. All rights reserved.
//

import Foundation

struct RedditPosts: Codable{
    var posts: [RedditPost?]
    
    init?(json: [String: Any]) {
        guard let data = json["data"] as? [String: Any], let children = data["children"] as? [[String: Any]] else {return nil}
        self.posts = children.map {RedditPost(json: $0)}
    }
}

struct RedditPost: Codable{
    var title: String
    
    init?(json: [String: Any]) {
        guard let data = json["data"] as? [String: Any], let title = data["title"] as? String else {return nil}
        self.title = title
    }
    
}
