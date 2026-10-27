package com.localsplits.server

import com.localsplits.server.handler.RaceWebSocketHandler
import org.springframework.context.annotation.Configuration
import org.springframework.web.socket.config.annotation.EnableWebSocket
import org.springframework.web.socket.config.annotation.WebSocketConfigurer
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry

@Configuration
@EnableWebSocket
class WebSocketConfig (

    private val raceWebSocketHandler: RaceWebSocketHandler
) : WebSocketConfigurer {
    override fun registerWebSocketHandlers(registry: WebSocketHandlerRegistry) {
        registry
            .addHandler(raceWebSocketHandler, "/race")
            // Allow any client to connect — lock this down
            // to your domain when you deploy to production
            .setAllowedOrigins("*")
    }
}