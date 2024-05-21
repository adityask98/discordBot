import Foundation


// Pulls thh env variables from the respective .env.* file.
enum Constants {
    static func env(_ key:String) -> String {
        if let value = ProcessInfo.processInfo.environment[key] {
            return value
        } else {
            fatalError("""
            Set an environment value for key '\(key)'.
            """)
        }
    }
    static let botToken = env("BOT_TOKEN")
}