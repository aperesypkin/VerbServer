import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let tasksController = TasksController()
    try router.register(collection: tasksController)
    
}
