'use strict';

var AWS = require('aws-sdk');

module.exports.showAll = (event, context, callback) => {
  var docClient = new AWS.DynamoDB.DocumentClient();

  const params = {
    TableName: "issues"
  };
  docClient.scan(params, (error, data) => {

    if(error) {
      callback(error);
    } else {
      const response = {
        statusCode: 200,
        body: JSON.stringify(data.Items)
      };

      callback(null, response);
    }
  });
};

module.exports.create = (event, context, callback) => {
  var docClient = new AWS.DynamoDB.DocumentClient();

  var params = JSON.parse(event.body);
  var item = params;

  docClient.put({TableName: 'issues', Item: item}, (error) => {
    if (error) {
      callback(error);
    }

    callback(null, { statusCode: 201 });
  });
};

module.exports.update = (event, context, callback) => {
  var docClient = new AWS.DynamoDB.DocumentClient();

  var params = JSON.parse(event.body);
  var item = params;

  docClient.update({TableName: 'issues', Item: item}, (error) => {
    if (error) {
      callback(error);
    }

    callback(null, { statusCode: 201 });
  });
};
