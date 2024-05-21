import DiscordBM
import Foundation

struct EventHandler: GatewayEventHandler {
    let event: Gateway.Event
    let client: any DiscordClient

    func onMessageCreate(_ payload: Gateway.MessageCreate) async throws {
        let isBot = payload.author?.bot == true
        if !isBot {
            print("NEW MESSAGE")
            print(payload)
            let response = try await client.createMessage(
                channelId: payload.channel_id,
                payload: .init(content: "Got a message: '\(payload.content)'")
            )
        }
    }
}
