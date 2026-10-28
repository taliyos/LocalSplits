package com.localsplits.server.handler

import org.springframework.web.socket.WebSocketSession
import java.util.concurrent.CopyOnWriteArrayList

enum class RoomStatus { IDLE, RUNNING }

class Room {
    val players = CopyOnWriteArrayList<WebSocketSession>()
    var status = RoomStatus.IDLE
    var startAt = 0L
}