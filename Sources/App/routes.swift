import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Bot Token: \(String(describing: Environment.process.BOT_TOKEN))"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

     app.get("botToken") { req async -> String in
        "Bot Token: \(Constants.botToken)"
    }
}
