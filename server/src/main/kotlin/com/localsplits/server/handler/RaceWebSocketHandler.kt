package com.localsplits.server.handler

import org.springframework.stereotype.Component
import org.springframework.web.socket.CloseStatus
import org.springframework.web.socket.TextMessage
import org.springframework.web.socket.WebSocketSession
import org.springframework.web.socket.handler.TextWebSocketHandler
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.jacksonObjectMapper
import java.net.URLDecoder
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CopyOnWriteArrayList


data class RaceMessage(
    val event: String = "",
    val runner: String = "",
    val splitIndex: Int = 0,
    val splitTime: String = "",
    val currentTime: String = "",
    val finalTime: String = ""
)


@Component
class RaceWebSocketHandler (
    private val objectMapper: ObjectMapper
) : TextWebSocketHandler() {

    private val rooms = ConcurrentHashMap<String, CopyOnWriteArrayList<WebSocketSession>>()
    private val sessionRoomMap = ConcurrentHashMap<String, String>()
    private val sessionUsernameMap = ConcurrentHashMap<String, String>()

    override fun afterConnectionEstablished(session: WebSocketSession) {
        val roomId = getRoomID(session) ?: run {
            session.close(CloseStatus.BAD_DATA)
            return
        }
        val sessions = rooms.computeIfAbsent(roomId) { CopyOnWriteArrayList() }

        sessions.forEach { existingSession ->
            val username = sessionUsernameMap[existingSession.id] ?: return@forEach
            session.sendMessage(TextMessage("""{"event":"joined","runner":"$username"}"""))
        }
        rooms.getOrPut(roomId) { CopyOnWriteArrayList() }.add(session)
        sessionRoomMap[session.id] = roomId

        println("Runner joined room $roomId | " + "Total in room: ${rooms[roomId]?.size}")

    }
    override fun handleTextMessage(session: WebSocketSession, message: TextMessage) {
        println("Received from ${session.id}: ${message.payload}")
        val roomId = sessionRoomMap[session.id] ?: return
        val sessions = rooms[roomId] ?: return

        val data = objectMapper.readTree(message.payload)
        val event = data["event"]?.stringValue()
        val runner = data["runner"]?.stringValue()
        if (event == "joined" && runner != null) {
            sessionUsernameMap[session.id] = runner
        }

        sessions
            .filter { it.id != session.id && it.isOpen }
            .forEach { other: WebSocketSession ->
                runCatching {
                    println("Forwarding to ${other.id}: ${message.payload}")
                    other.sendMessage(TextMessage(message.payload))
                }.onFailure {
                    println("Failed to forward to session: ${other.id}")
                }
            }
    }
    override fun afterConnectionClosed(session: WebSocketSession, status: CloseStatus) {
        val roomId = sessionRoomMap.remove(session.id) ?: return
        sessionUsernameMap.remove(session.id) ?: return
        val sessions = rooms[roomId] ?: return
        sessions.remove(session)

        if(sessions.isEmpty()){
            rooms.remove(roomId)
            println("Room $roomId is empty, removed")
        }

        val disconnectMsg = objectMapper.writeValueAsString(
            mapOf(
                "event" to "left",
                "runner" to (session.attributes["runner"] ?: "Unknown")
            )
        )
        sessions
            .filter {it.isOpen}
            .forEach {runCatching {it.sendMessage(TextMessage(disconnectMsg)) } }

        println("Runner disconnected from room $roomId")
    }
 

    private fun getRoomID(session: WebSocketSession): String? {
        val query = session.uri?.query ?: return null

        return query.split("&").map {it.split("=")}.firstOrNull { it.size == 2 && it[0] == "roomId" }?.get(1)
    }
}




















