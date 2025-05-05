include <../assert.scad>
include <../array.scad>
include <../sort.scad>

assert_eq([1,2,3,4], array([1:4]));

let (xs = rands(0, 1, 100)) {
  for (i = [0:len(xs)-1]) {
    assert_eq(i, firstIndexOf(xs, xs[i]));
  }
}

assert_eq(array([10:-1:0]), reverse(array([0:10])));

let (ys = flatten([1,2,3,4]))
assert_eq([1,2,3,4], ys);
let (ys = flatten([1,[2,3],4]))
assert_eq([1,2,3,4], ys);
let (ys = flatten([[1,2],[[3],[4]]]))
assert_eq([1,2,[3],[4]], ys);

let (ys = flatten_all([1,2,3,4]))
assert_eq([1,2,3,4], ys);
let (ys = flatten_all([1,[2,3],4]))
assert_eq([1,2,3,4], ys);
let (ys = flatten_all([[1,2],[[3],[4]]]))
assert_eq([1,2,3,4], ys);

let (
  xs = array_id(1000),
  sxs = shuffle(xs)
) {
  assert_eq(len(xs), len(sxs));
  assert_true(xs != sxs);
  assert_eq(xs, quicksort(sxs));
}

let (inc = function(x) x + 1) {
  let (xs = [0,1,2])
    assert_eq([for (x = xs) inc(x)], map(xs, inc));
  let (xs = [0:10])
    assert_eq([for (x = xs) inc(x)], map(xs, inc));
}

let (sum = function(x,y) x + y,
     triangle = function(x) (1+x)*x/2) {
  for (N = [4, 100, 1e4-1]) {
    let (y = foldl(x = 0, xs = array([1:N]), f = sum))
      assert_eq(triangle(N), y);
    let (y = foldr(x = 0, xs = array([1:N]), f = sum))
      assert_eq(triangle(N), y);
    if (N <= 1e3)
      let (y = foldr_nf(x = 0, xs = array([1:N]), f = sum))
        assert_eq(triangle(N), y);
  }
}
