
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
    console.log('Ran cloud function.');
    response.success("Hello world!");
});

//TWILIO
Parse.Cloud.define("twilio", function(request, response) {
	// Require and initialize the Twilio module with your credentials
	var client = require('twilio')('AC47d7f1298aba32a48efcf711a5ca990d', 'f039329073ef926596d2a28695f0bb03');
	var receiverPhone = request.params.receiverPhone
	var userFirstName = request.params.userFirstName
	var userLastName = request.params.userLastName
	var receiverFirstName = request.params.receiverFirstName
	var amount = request.params.amount
	
	// Send an SMS message
	client.sendSms({
		to: receiverPhone,
		from: '+18324314448',
		body: 'Hi'
	  }, function(err, responseData) {
		if (err) {
		  console.log(err);
		} else {
		  console.log(responseData.from);
		  console.log(responseData.body);
		}
	  }
);
});

