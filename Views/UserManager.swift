// UserManager.swift

class UserManager {
    static let shared = UserManager()
    
    var user: User?
    
    private init() { }
}
