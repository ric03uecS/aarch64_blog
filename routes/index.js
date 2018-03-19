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
				release: process.env.RELEASE || 'master',
				version: unameOutput
			}
		);
	});
});

router.get('/add', function(req, res, next) {
	var first = Number(req.query.first, 10);
	var second = Number(req.query.second, 10);
	var result = add(first, second);

	res.status(200).send(JSON.stringify(result));
});

router.add = function (first, second) {
  return first + second;
}

module.exports = router;
