'use strict'

const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB({region: 'eu-central-1'});

exports.handler = async (event) => {
    const tableName = "timestamps";
    try {
        await dynamoDb.putItem({
            TableName: tableName,
            Item: {
                timestamp: {N: Date.now().toString() }
            }
        }).promise();

    } catch (error) {
        throw new Error(`Error in dynamoDB: ${JSON.stringify(error)}`);
    }
};