import FluentSQLite
import Vapor
import Leaf

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())
    try services.register(LeafProvider())

    // Register routes to the router
    services.register(Router.self) { container -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router)
        return router
    }
    
    // Register middleware
    var middlewareConfig = MiddlewareConfig()
    try middlewares(config: &middlewareConfig)
    services.register(middlewareConfig)

    /// Register the configured database to the database config.
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)

    // Configure migrations
    services.register { container -> MigrationConfig in
        var migrationConfig = MigrationConfig()
        try migrate(migrations: &migrationConfig)
        return migrationConfig
    }
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
}
