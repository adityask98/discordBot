import DiscordBM
import Logging
import NIOCore
import NIOPosix
import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = try await Application.make(env)

        // This attempts to install NIO as the Swift Concurrency global executor.
        // You should not call any async functions before this point.
        let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
        app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")
        let bot: BotGatewayManager = await BotGatewayManager(
            eventLoopGroup: app.eventLoopGroup,
            httpClient: app.http.client.shared,
            token: Constants.botToken,
            presence: .init(
                activities: [.init(name: "SwiftBot", type: .game)],
                status: .online,
                afk: false
            ),
            intents: [.guildMessages, .messageContent]
        )

        Task { await bot.connect() }

        Task {
            for await event in await bot.events {
                EventHandler(event: event, client: bot.client).handle()
            }
        }

        do {
            try await configure(app)
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
        try await app.execute()
        try await app.asyncShutdown()
    }
}
