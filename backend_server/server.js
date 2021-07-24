#!/usr/bin/env node
var WebSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);
    response.writeHead(404);
    response.end();
});
server.listen(8080, function() {
    console.log((new Date()) + ' Server is listening on port 8080');
});

// GLOBAL VARS
var rooms = new Set();
var mapping = new Map();

// useful functions:
function getNewRoom() {
  const max = 9999;
  const min = 1111;
  var candidate = Math.floor(Math.random() * (max - min) + min);
  while (rooms.has(candidate) || candidate.toString().includes('0')) {
    candidate = Math.floor(Math.random() * (max - min) + min);
  }
  // TODO: think about race conditions here
  rooms.add(candidate.toString());
  return candidate.toString();
}

wsServer = new WebSocketServer({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});

function originIsAllowed(origin) {
  // put logic here to detect whether the specified origin is allowed.
  return true;
}

function parseMessage(message, connection) {
  const object = JSON.parse(message);
  const type = object.type;
  const body = object.body;
  switch (type) {
    case "CREATE_ROOM":
      const newRoom = getNewRoom();
      var player = {
        name: body.name,
        colour: body.colour
      }
      const reply = {
        type: "CREATE_ROOM_REPLY",
        body: newRoom
      }
      // add connection to hashmap
      mapping.set(newRoom, {
        clients: [connection],
        players: [player],
        canJoin: true
      });
      connection.sendUTF(JSON.stringify(reply));
      break;
    case "JOIN_ROOM":
      var roomNumber = body.room;
      player = {
        name: body.name,
        colour: body.colour
      }
      if (rooms.has(roomNumber)) { // successful join
        mapping.get(roomNumber).clients.push(connection);
        mapping.get(roomNumber).players.push(player);
        const reply = {
          type: "JOIN_ROOM_REPLY",
          body: {
            message: "success",
            player: mapping.get(roomNumber).players
          }
        }

        var clients = mapping.get(roomNumber).clients;
        // send every client
        for (let client of clients) {
          client.sendUTF(JSON.stringify(reply));
        }
      } else { // join failed
        // implement later
      }
      break;
    case "INDICATE_READY": // fall through
    case "START_GAME": // fall through
    case "START_ROUND": // fall through
    case "GET_CORRECT": // fall through
    case "PASS": // fall through
    case "TIME_UP": // fall through
    case "END_GAME":
      roomNumber = JSON.parse(message).body.room; // TODO: handle wrong room number
      clients = mapping.get(roomNumber).clients;
      // send every client
      for (let client of clients) {
        client.sendUTF(message);
      }
      break;
    default:
      console.log("Should not reach here!");  
  }
}

wsServer.on('request', function(request) {
    if (!originIsAllowed(request.origin)) {
      // Make sure we only accept requests from an allowed origin
      request.reject();
      console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
      return;
    }
    
    // var connection = request.accept('echo-protocol', request.origin);
    var connection = request.accept(null, request.origin);
    console.log((new Date()) + ' Connection accepted.');
    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log('Received Message: ' + message.utf8Data);
            // const reply = parseMessage(message.utf8Data, connection);
            // connection.sendUTF(reply);
            parseMessage(message.utf8Data, connection); // parseMessage() does the reply as well
        }
        else if (message.type === 'binary') {
            console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');
            connection.sendBytes(message.binaryData);
        }
    });
    connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});