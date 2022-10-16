// load in the environment vars
require('dotenv').config({silent: true})

const express = require('express');
const app = express();
const logger = require('morgan');
var bodyParser = require('body-parser');
const jwt = require("jsonwebtoken");


app.use(logger('dev'))
// enable CORS for all routes and for our specific API-Key header
app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '/DevOps')
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, API-Key')
  next()
})

app.use(express.static('public'))
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
const secret = process.env.JWT_SECRET
const tokenExpirationTime = process.env.JWT_EXPIRES_IN;


app.use((req, res, next) => {
  if(req.path != "/DevOps") {
    res.status(404).send(JSON.stringify("ERROR"));
  } else {
    next()
  }
})

app.use((req, res, next) => {
  const apiKey = req.get('X-Parse-REST-API-Key')
  if (!apiKey || apiKey !== process.env.API_KEY) {
    res.status(401).json({error: 'unauthorised'})
  } else {
    next()
  }
})

  function verifyToken(req, res) {
    jwt.sign({
      message: req.body.message,
      to: req.body.to,
      from: req.body.from,
      timeToLifeSec: req.body.timeToLifeSec
    },
    secret,
    {
        expiresIn: tokenExpirationTime
    },
    
    (err, token) => {
      res.header("X-JWT-KWY", token)
      res.status(200).json({
          message: `Hello ${req.body.to} your token is read`,
          token: token
      })
    });
  }
  app.post('/getToken', (req, res) => {
    verifyToken(req, res)
  })
  app.post('/DevOps', (req, res, next) => {
    const bearerHeader = req.get('X-JWT-KWY');
    try {
      req.user = jwt.verify(bearerHeader, secret)
      delete req.user.iat;
      delete req.user.exp;
      if(JSON.stringify(req.user) === JSON.stringify(req.body)){
        res.status(200).json({
          message: `Hello ${req.body.to} your message will be send`,
        })
      } else {
        res.status(406).json("Request body doesn't match provided JWT Token")
      }
    }
    catch (err) {
      console.log(err);
      res.status(503).send(err)
    }
    if (typeof bearerHeader !== "undefined") {
      const bearerToken = bearerHeader.split(" ")[1];
      req.token = bearerToken;
      next();
    } else {
      res.sendStatus(403);
    }
    
  })

app.listen(process.env.PORT, () => {
  console.log(`Server Listening on port ${process.env.PORT}`)
})