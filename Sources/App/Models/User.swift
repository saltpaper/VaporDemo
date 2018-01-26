//
//  User.swift
//  HelloAPIPackageDescription
//
//  Created by Amy on 25/1/2018.
//
import Vapor
import FluentProvider

final class User: Model {
    var userName: String
    var email: String
    var age: Int
    
    let storage = Storage() //The storage property is there to allow Fluent to store extra information on your model--things like the model's database id.
    
    init(userName:String,email:String,age:Int) {
        self.userName = userName
        self.email = email
        self.age = age
    }
    
    
    /*function describes how to initialize your user from a database table entry like get the value at the column “username” and assign it to username.
     从db里解析出数据（parsing the User from the database）
    */
    init(row: Row) throws {
       self.userName = try row.get("userName")
        self.email = try row.get("email")
        self.age = try row.get("age")

    }
    
    /* The function defines the representation of your user for the database table like for the column “userName” "email"  set the value of the variable username.
        序列化数据到db(serializing the User to the database.)
    */
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("userName",userName)
        try row.set("email",email)
        try row.set("age",age)
        return row
    }
    
    //The Row struct represents a database row. Your models should be able to parse from and serialize to database rows.
}


// MARK: Fluent Preparation
/*
 Preparing the Database
 In order to use your model, you may need to prepare your database with an
 appropriate schema.
 
  by conforming your model to Preparation.
 */

extension User : Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { users in
            users.id()
            users.string("userName")
            users.string("email")
            users.int("age")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: Node

extension User: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("userName", userName)
        try node.set("email", email)
        try node.set("age", age)

        return node
    }
}
