var express = require('express');
var router = express.Router();
var spawn = require('child_process').spawn;

/* GET home page. */
router.get('/', function(req, res, next) {

	var uname = spawn('uname', ['-a']);
	var unameOutput = '';
	uname.stdout.on('data', function(data) {
		unameOutput = data;
	});

	uname.stderr.on('data', function (data) {
		unameOutput = data;
	});

	uname.on('close', function (code) {
		res.render('index',
			{
				title: 'aarch64 blog',
				release: process.env.release,
				version: unameOutput
			}
		);
	});
});

module.exports = router;
