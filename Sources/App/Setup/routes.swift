import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // MARK: APIControllers
    
    try router.register(collection: TaskController())
    try router.register(collection: VerbController())
    try router.register(collection: AnswerController())
    try router.register(collection: UserController())
    
    // MARK: ViewControllers
    
    try router.register(collection: TaskViewController())
    try router.register(collection: LoginViewController())
    try router.register(collection: VerbViewController())
    try router.register(collection: AnswerViewController())
}
