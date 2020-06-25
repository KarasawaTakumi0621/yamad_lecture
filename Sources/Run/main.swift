import FluentSQLite
import Vapor

var services = Services.default()

services.register(NIOServerConfig.default(hostname:"127.0.0.1", port:8080))

try services.register(FluentSQLiteProvider())

var databases = DatabasesConfig()
let sqlite = try SQLiteDatabase(storage:.file(path:"/Users/fox_tail/yamadhacks"))
databases.add(database:sqlite, as:DatabaseIdentifier<SQLiteDatabase>.sqlite)
services.register(databases)

let application = try Application(config:Config.default(), environment:Environment.detect(), services:services)

final class User {
  static let entity = "users"
  var id:Int?
  var name:String
  init(id:Int? = nil, name:String) {
    self.id = id
    self.name = name
  }
}

extension User:Content {}
extension User:SQLiteModel {}

User.defaultDatabase = DatabaseIdentifier<SQLiteDatabase>.sqlite

let router = try application.make(Router.self)

router.get("create") { request -> Future<[User]> in
  let user1 = User(id:1, name:"Takumi Karasawa")
  let _ = user1.create(on:request)
  return User.query(on:request).all()
}

router.get("readAll") { request -> Future<[User]> in
  return User.query(on:request).all()
}

router.get("read") { request -> Future<[User]> in
  return User.query(on:request).filter(\User.id == 1).all()
}

router.get("update") { request -> Future<[User]> in
  let user = User(id:1, name:"Takumi Karasawa")
  let _ = user.update(on:request)
  return User.query(on:request).all()
}

try application.run()
