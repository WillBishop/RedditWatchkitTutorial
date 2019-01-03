//
//  InterfaceController.swift
//  RedditTutorial WatchKit Extension
//
//  Created by Will Bishop on 3/1/19.
//  Copyright © 2019 Will Bishop. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var redditTable: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        self.getUserInput(gotInput: {input in
            if let redditURL = URL(string: "https://reddit.com/r/\(input).json") {
                var request = URLRequest(url: redditURL)
                request.setValue("Replace this with something long and unique, about this long works well", forHTTPHeaderField: "User-Agent")
                
                URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                    guard let data = data else {return}
                    do{
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                            guard let posts = RedditPosts(json: jsonObject) else {return}
                            self.setupTable(withPosts: posts.posts)
                            
                            
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                }).resume()
            }
        })
    }
    func setupTable(withPosts posts: [RedditPost?]){
        self.redditTable.setNumberOfRows(posts.count, withRowType: "RedditPostCell")
        for (index, element) in posts.enumerated(){
            guard let row = self.redditTable.rowController(at: index) as? RedditCell else {continue}
            row.postTitle.setText(element?.title)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func getUserInput(gotInput: @escaping (_: String) -> Void){
        self.presentTextInputController(withSuggestions: ["AskReddit"], allowedInputMode: .plain, completion: {result in
            guard let userInput = result?.first as? String else {return}
            gotInput(userInput)
        })
    }
}
