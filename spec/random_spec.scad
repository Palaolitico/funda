include <../assert.scad>
include <../random.scad>
include <../math.scad>

let(M = 100)
assert_all(
  function(x) is_int(x) && 0 <= x && x < M,
  randints(max_value=M, value_count=1000),
  message = function(p,xs,kos) str(
    "There are ", len(kos), " out of ", len(xs), " values not fulfilling ", p));
