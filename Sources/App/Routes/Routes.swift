import Vapor

extension Droplet {
    func setupRoutes() throws {   //This method is where all the routes for our application will be added.
        get("home") { req in
            return try self.view.make("homeView.leaf", ["name": "amy"])
        }
        
        get("name",":name") { request in
            if let name = request.parameters["name"]?.string {
                return "Hello \(name)!"
            }
            return "Error retrieving parameters."
        } // website: .../name/amy
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        get("usersList") {req in
            return try self.view.make("userList.leaf")
        }
        
        try resource("posts", PostController.self)
    }
    
}
