var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index',
    {
      title: 'aarch64 blog',
      release: 'release version from global env',
      version: 'output of uname'
    }
  );
});

module.exports = router;
