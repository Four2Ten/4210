# Backend Server for Four2Ten

## Introduction
This backend server acts as the coordination point for the multi-player game, Four2Ten, by keeping information of currently active rooms and relaying information between clients in the same room via WebSocket. 

Specifically, each client (a player's mobile application) initiates a WebSocket connection with the server while specifying the room ID. The server will group together all the WebSocket clients within the same room, and process messages from each client according to the schema below.

The server is written in `Node.js` and is hosted on [Google App Engine](https://cloud.google.com/appengine).

## Quick Start
You may refer to this [quickstart guide from Google](https://cloud.google.com/appengine/docs/standard/nodejs/quickstart) on how to deploy `Node.js` to Google App Engine. Note that you need to initialise the Google Cloud SDK first, as described in the guide.

After everyting's ready, here are some quick commands to get started:
- Install dependencies for the project: `npm install`
- Start the server locally: `npm start`
- Deploy to Google App Engine: `gcloud app deploy`

## Schema

### Global variables
- Set of strings of room IDs
- Hashmap:
{
    roomNumber: {
        clients: [array of WebSockets],
        players: [{
            name: "John",
            colour: "Colour.pink"
        }, ...],
        canJoin: true
    }
}

### WebSocket Schema
<table>
    <tr>
        <td> S/N </td> 
        <td> Functionality </td> 
        <td> What Client sends </td> 
        <td> Type of Client </td>
        <td> What Server sends and To Whom </td>
    </tr>
    <tr>
        <td> 1 </td> 
        <td> To create a room </td> 
        <td> 

            ```
            {
                "type": "CREATE_ROOM",
                "body": {
                    "name": "John",
                    "colour": "Colour.pink"
                }
            }
            ```

        </td> 
        <td> Host </td>
        <td> 

            ```
            {
                "type": "CREATE_ROOM_REPLY",
                "body": "2345"
            }
            ```
            Sent to Host.

        </td>
    </tr>
    <tr>
        <td> 2 </td> 
        <td> To join a room </td> 
        <td> 

            ```
            {
                "type": "JOIN_ROOM",
                "body": {
                    "room": "2345",
                    "name": "John",
                    "colour": "Colour.blue"
                }
            }
            ```

        </td> 
        <td> Host </td>
        <td> 

            ```
            {
                "type": "JOIN_ROOM_REPLY",
                "body": {
                    "message": "sucess|no such room|cannot join now",
                    "player":[
                        {
                            "name": "John",
                            "colour": "Colour.blue"
                        },
                        {
                            ...
                        }
                    ],
                }
            }
            ```
            Relay to all if success.

        </td>
    </tr>
</table>


2. To join a room:
client:
{
    "type": "JOIN_ROOM",
    "body": {
        "room": "2345",
        "name": "Zechu",
        "colour": "blue"
    }
}
server (relay to all if success):
{
    "type": "JOIN_ROOM_REPLY",
    "body": {
        "message": "sucess|no such room|cannot join now",
        "player":[
            {
                "name": "Zechu",
                "colour": "blue"
            },
            {
                ...
            }
        ],
    }
}
3. Indicate ready
client:
{
    "type": "INDICATE_READY",
    "body": {
        "room": "2345",
        "name": "Zechu"
    }
}
server: relay to all
4. Start game
client (host):
{
    "type": "START_GAME",
    "body": {
        "room": "2345"
    }
}
server:
relay to all
5. Start round
client (host):
{
    "type": "START_ROUND",
    "body": {
        "room": "2345",
        "round": 15,
        "question": "2345"
    }
}
server: 
relay to all
6. Someone got it correct:
client (the one who got it correct):
{
    "type": "GET_CORRECT",
    "body": {
        "room": "2345",
        "name": "Zechu",
        "score": 12,
        "correctAnswer": "1+1+9+0"
    }
}
server:
relay to all
7. Someone passes
client (the one who passes):
{
    "type": "PASS",
    "body": {
        "room": "1234",
        "name": "Zechu"
    }
}
server:
relay to all
8. Timer's up
client (host):
{
    "type": "TIME_UP",
    "body": {
        "room": "2345"
    }
}
server:
relay to all
9. End game:
client (host):
{
    "type": "END_GAME",
    "body": {
        "room": "2345"
    }
}
server:
relay to all





