package com.localsplits.server.handler

import org.springframework.stereotype.Component
import org.springframework.web.socket.CloseStatus
import org.springframework.web.socket.TextMessage
import org.springframework.web.socket.WebSocketSession
import org.springframework.web.socket.handler.TextWebSocketHandler
import tools.jackson.databind.ObjectMapper
import java.util.concurrent.ConcurrentHashMap

private const val COUNTDOWN_MS = 3000L
@Component
class RaceWebSocketHandler (
    private val objectMapper: ObjectMapper
) : TextWebSocketHandler() {

    private val rooms = ConcurrentHashMap<String, Room>()
    private val playerRoomMap = ConcurrentHashMap<String, String>()
    private val playerUsernameMap = ConcurrentHashMap<String, String>()

    override fun afterConnectionEstablished(player: WebSocketSession) {
        val roomId = getRoomID(player) ?: run {
            player.close(CloseStatus.BAD_DATA)
            return
        }
        val room = rooms.computeIfAbsent(roomId) { Room() }

        room.players.forEach { existingPlayer ->
            val username = playerUsernameMap[existingPlayer.id] ?: return@forEach
            send(player, toJson(mapOf("event" to "joined", "runner" to username)))
        }
        room.players.add(player)
        playerRoomMap[player.id] = roomId

        val runningStartAt = synchronized(room){
            if (room.status == RoomStatus.RUNNING) room.startAt else null
        }
        if (runningStartAt != null) {
            send(player, toJson(mapOf("event" to "start", "startAt" to runningStartAt)))
        }

        println("Runner joined room $roomId | Total in room: ${room.players.size}")
    }

    override fun handleTextMessage(player: WebSocketSession, message: TextMessage) {
        val roomId = playerRoomMap[player.id] ?: return
        val room = rooms[roomId] ?: return

        val data = objectMapper.readTree(message.payload)
        val event = data["event"]?.stringValue()
        val runner = data["runner"]?.stringValue()

        // answer pings directly; never forward them
        if (event == "ping") {
            val clientTime = data["clientTime"]?.asLong() ?: return
            send(
                player, toJson(
                    mapOf(
                        "event" to "pong",
                        "clientTime" to clientTime,
                        "serverTime" to serverTimeMs()
                    )
                )
            )
            return
        }

        println("Received from ${player.id}: ${message.payload}")

        if (event == "requestStart"){
            handleRequestStart(room)
            return
        }

        if (event == "reset"){
            synchronized(room){room.status = RoomStatus.IDLE}
        }

        if (event == "joined" && runner != null) {
            playerUsernameMap[player.id] = runner
        }

        room.players
            .filter { it.id != player.id }
            .forEach { other -> send(other, message.payload) }
    }

    private fun send(player: WebSocketSession, text: String){
        runCatching{
            synchronized(player) {
                if (player.isOpen) player.sendMessage(TextMessage(text))
            }
            }.onFailure {
            println("Failed to send to player: ${player.id}: ${it.message}")
        }
    }

    private fun broadcast(room: Room, payload: Map<String, Any>){
        val text = toJson(payload)
        room.players.forEach {send(it, text)}
    }

    private fun handleRequestStart(room: Room) {
        val startAt = synchronized(room){
            if(room.status != RoomStatus.IDLE) return
            room.status = RoomStatus.RUNNING
            room.startAt = serverTimeMs() + COUNTDOWN_MS
            room.startAt
        }
        println("Race starting at $startAt (in ${COUNTDOWN_MS}ms)")
        broadcast(room, mapOf("event" to "start", "startAt" to startAt))
    }

    override fun afterConnectionClosed(player: WebSocketSession, status: CloseStatus) {
        val roomId = playerRoomMap.remove(player.id) ?: return
        playerUsernameMap.remove(player.id) ?: return
        val room = rooms[roomId] ?: return
        room.players.remove(player)

        if (room.players.isEmpty()) {
            rooms.remove(roomId)
            println("Room $roomId is empty, removed")
        }

        broadcast(room, mapOf(
            "event" to "left",
            "runner" to (player.attributes["runner"] ?: "Unknown")
        ))

        println("Runner disconnected from room $roomId")
    }

    private fun serverTimeMs(): Long = System.nanoTime() / 1_000_000

    private fun toJson(payload: Map<String, Any>): String = objectMapper.writeValueAsString(payload)

    private fun getRoomID(player: WebSocketSession): String? {
        val query = player.uri?.query ?: return null

        return query.split("&").map { it.split("=") }.firstOrNull { it.size == 2 && it[0] == "roomId" }?.get(1)
    }
}