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
				title: process.env.APP_TITLE || 'aarch64 blog',
        runMode :  process.env.RUN_MODE || 'local',
				release: process.env.RELEASE || 'master',
        region: process.env.REGION || 'blr',
				version: unameOutput
			}
		);
	});
});

router.get('/status', function(req, res, next) {
  var response = {
    runMode :  process.env.RUN_MODE || 'local',
    release: process.env.RELEASE || 'master',
    region: process.env.REGION || 'blr'
  };

  res.status(200).send(JSON.stringify(response));
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
