# Backend Server for Four2Ten

## Introduction
This backend server acts as the coordination point for the multi-player game, Four2Ten, by keeping information of currently active rooms and relaying information between clients in the same room via WebSockets. 

Specifically, each client (a player's mobile application) initiates a WebSocket connection with the server by specifying the room ID. The server will group together all the WebSocket clients within the same room, and process messages from each client according to the schema below.

The server is written in `Node.js` and is hosted on [Google App Engine](https://cloud.google.com/appengine). All server code can be found in `server.js`.

## Quick Start
You may refer to this [quickstart guide from Google](https://cloud.google.com/appengine/docs/standard/nodejs/quickstart) on how to deploy `Node.js` to Google App Engine. Note that you'll need to initialise the Google Cloud SDK first, as described in the guide.

After everyting's ready, here are some quick commands to get started:
- Install dependencies for the project: `npm install`
- Start the server locally: `npm start`
- Deploy to Google App Engine: `gcloud app deploy`

## Schema

### Global variables
- Set of strings of room IDs
- Hashmap:
```
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
```

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
<pre>
{
    "type": "CREATE_ROOM",
    "body": {
        "name": "John",
        "colour": "Colour.pink"
    }
}
</pre>
</td> 
<td> Host </td>
<td> 
<pre>
{
    "type": "CREATE_ROOM_REPLY",
    "body": "2345"
}

Send to Host.
</pre>
</td>
</tr>

<tr>
<td> 2 </td> 
<td> To join a room </td> 
<td> 
<pre> 
{
    "type": "JOIN_ROOM",
    "body": {
        "room": "2345",
        "name": "John",
        "colour": "Colour.blue"
    }
}
</pre>
</td> 
<td> Non-host </td>
<td> 
<pre>
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

Reply to all if success.
</pre>
</td>
</tr>

<tr>
<td> 3 </td> 
<td> To indicate a player is ready </td> 
<td> 
<pre> 
{
    "type": "INDICATE_READY",
    "body": {
        "room": "2345",
        "name": "John"
    }
}
</pre>
</td> 
<td> Non-host </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

<tr>
<td> 4 </td> 
<td> To start a game </td> 
<td> 
<pre> 
{
    "type": "START_GAME",
    "body": {
        "room": "2345"
    }
}
</pre>
</td> 
<td> Host </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

<tr>
<td> 5 </td> 
<td> To start a new round </td> 
<td> 
<pre> 
{
    "type": "START_ROUND",
    "body": {
        "room": "2345",
        "round": 15,
        "question": "7385"
    }
}
</pre>
</td> 
<td> Host </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

<tr>
<td> 6 </td> 
<td> To inform others that a player gets a question correct </td> 
<td> 
<pre> 
{
    "type": "GET_CORRECT",
    "body": {
        "room": "2345",
        "name": "John",
        "score": 12,
        "correctAnswer": "1+1+9+0"
    }
}
</pre>
</td> 
<td> Any player (the player who gets the question correct) </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

<tr>
<td> 7 </td> 
<td> To inform others that a player wants to pass the current round </td> 
<td> 
<pre> 
{
    "type": "PASS",
    "body": {
        "room": "1234",
        "name": "John"
    }
}
</pre>
</td> 
<td> Any player (the player who wants to pass) </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

<tr>
<td> 8 </td> 
<td> To inform everyone that time is up for the current round </td> 
<td> 
<pre> 
{
    "type": "TIME_UP",
    "body": {
        "room": "2345"
    }
}
</pre>
</td> 
<td> Host </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

<tr>
<td> 9 </td> 
<td> To end a game </td> 
<td> 
<pre> 
{
    "type": "END_GAME",
    "body": {
        "room": "2345"
    }
}
</pre>
</td> 
<td> Host </td>
<td> 
<pre>
Relay original message to all.
</pre>
</td>
</tr>

</table>
