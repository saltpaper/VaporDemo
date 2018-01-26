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
            let list = try User.all()
            return try self.view.make("userList",["users": list.makeNode(in: nil)])
        }
        
        post("usersList") { req in
            guard let userName = req.data["userName"]?.string else {
                return Response(status: .badRequest)
            }
            guard let email = req.data["email"]?.string else {
                return Response(status: .badRequest)
            }
            
            guard let age = req.data["age"]?.int else {
                return Response(status: .badRequest)
            }
            
            let user = User.init(userName: userName, email: email, age: age)
            try user.save()
            return Response(redirect: "usersList")
        }
        
        
        try resource("posts", PostController.self)
    }
    
}
