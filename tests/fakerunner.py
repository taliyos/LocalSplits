import asyncio
import websockets
import json
import time

ROOM_ID = "SEMPK6"  # change to match whatever room you create
SERVER = f"ws://localhost:8080/race?roomId={ROOM_ID}"
RUNNER_NAME = "FakeRunner"
SPLIT_TIMES = ["1.23", "2.45", "3.67", "4.89", "5.11"]

async def fake_runner():
    async with websockets.connect(SERVER) as ws:
        # announce joining
        await ws.send(json.dumps({"event": "joined", "runner": RUNNER_NAME}))
        print(f"Joined room {ROOM_ID} as {RUNNER_NAME}")

        # split every 2 seconds
        for i, split_time in enumerate(SPLIT_TIMES):
            await asyncio.sleep(2)
            msg = {
                "event": "split",
                "runner": RUNNER_NAME,
                "splitIndex": i,
                "splitTime": split_time
            }
            await ws.send(json.dumps(msg))
            print(f"Split {i}: {split_time}")

        # keep connection open
        await asyncio.sleep(999)

asyncio.run(fake_runner())