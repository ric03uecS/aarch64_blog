var expect = require('chai').expect;
var router = require('./routes/index.js');

describe('check add route', function() {
  it ('should add two number', function() {
    var x = 1;
    var y = 2;

    var sum = router.add(x, y);

    expect(sum).to.be.equal(3);
	});
});
