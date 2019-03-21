import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // MARK: APIControllers
    
    try router.register(collection: TasksController())
    
    // MARK: ViewControllers
    
    try router.register(collection: TasksViewController())
    try router.register(collection: LoginViewController())
    
}
