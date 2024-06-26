import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.http.server.configuration.port = 8090
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
}
