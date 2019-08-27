const listInstruments = require('./list')
const brokerage = require('./brokerage')

exports.handler = (event, context, callback) => {

  const fns = {
    "/instruments": listInstruments,
    "/brokerage": brokerage.additional,
    "/brokerage/inclusive": brokerage.inclusive
  }

  if (event.httpMethod == "GET" && fns[event.path]) {
    const result = fns[event.path](event.queryStringParameters || {})
    const response = {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json', 
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS, GET",
      },
      body: JSON.stringify(result),
    };
    callback(null, response);
  }
  else if (event.httpMethod == "OPTIONS") {
    const response = {
      statusCode: 204,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Methods": "OPTIONS, GET",
      },
      body: ""
    };
    callback(null, response);

  }
  else {
    const response = {
      statusCode: 400,
      body: JSON.stringify({message: "Not implemented"}),
    };
    callback(null, response);
  }




};