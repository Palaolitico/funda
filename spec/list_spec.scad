include <../assert.scad>
include <../list.scad>
include <../array.scad>
include <../sort.scad>

assert_eq(undef, lst_empty);
assert_eq([1,undef], lst_cons(1, lst_empty));
assert_eq([1,[2,undef]], lst_cons(1, lst_cons(2, lst_empty)));

assert_eq(undef, lst_from([]));
assert_eq([1,undef], lst_from([1]));
assert_eq([1,[2,undef]], lst_from([1,2]));

for (xs = [[], [0], [0,1], array([0:100])]) {
  let (n = len(xs), xls = lst_from(xs)) {
    assert_eq(xs, lst_array(xls));
    assert_eq(n, lst_size(xls));
    assert_eq(n, lst_len(xls));

    assert_true(is_undef(lst_at(xls,-1)));
    assert_true(is_undef(lst_at(lst_empty,n)));
    assert_true(is_undef(lst_at(lst_empty,n+1)));
    for (i = [0:n-1]) assert_eq(xs[i], lst_at(xls,i));

    if (n == 0) assert_true(is_undef(lst_last(xls)));
    else assert_eq(xs[n-1], lst_last(xls));
  }
}

assert_true(lst_from([1]), lst_append(lst_empty, 1));
assert_true(lst_from(array([0:10])), lst_append(lst_from(array([0:9])), 10));

let (
  xs = array([0:4]), xls = lst_from(xs),
  ys = array([5,9]), yls = lst_from(ys)
) {
  assert_true(lst_is_empty(lst_concat(lst_empty, lst_empty)));
  assert_eq(xls, lst_concat(lst_empty, xls));
  assert_eq(xls, lst_concat(xls, lst_empty));
  assert_eq(lst_from(concat(xs,ys)), lst_concat(xls,yls));
}

let (
  N = 10, xs = array([0:N-1]), xls = lst_from(xs)
) {
  //Set
  assert_true(lst_is_empty(lst_set(lst_empty, -1, N)));
  assert_eq(lst_from([N]), lst_set(lst_empty, 0, N));
  assert_eq(lst_from([undef, undef, N]), lst_set(lst_empty, 2, N));
  assert_eq(xls, lst_set(xls, -1, N));
  assert_eq(lst_append(xls, 10), lst_set(xls, N, N));
  assert_eq(lst_concat(xls, lst_from([undef,undef,10])), lst_set(xls, N+2, N));
  for (i = [0:N]) {
    assert_eq(
      lst_from(concat(slice(xs,[0:i-1]), [N], slice(xs,[i+1:N-1]))),
      lst_set(xls, i, N));
  }

  //Insert
  assert_true(lst_is_empty(lst_insert(lst_empty, -1, N)));
  assert_eq(lst_from([N]), lst_insert(lst_empty, 0, N));
  assert_eq(lst_from([undef, undef, N]), lst_insert(lst_empty, 2, N));
  assert_eq(xls, lst_insert(xls, -1, N));
  assert_eq(lst_append(xls, 10), lst_insert(xls, N, N));
  assert_eq(
    lst_concat(xls, lst_from([undef,undef,10])),
    lst_insert(xls, N+2, N));
  for (i = [0:N]) {
    assert_eq(
      lst_from(concat(slice(xs,[0:i-1]), [N], slice(xs,[i:N-1]))),
      lst_insert(xls, i, N));
  }

  //Remove
  assert_true(lst_is_empty(lst_remove(lst_empty, -1)));
  assert_true(lst_is_empty(lst_remove(lst_empty, 0)));
  assert_true(lst_is_empty(lst_remove(lst_empty, 1)));
  assert_eq(xls, lst_remove(xls, -1));
  assert_eq(xls, lst_remove(xls, N));
  for (i = [-1:N]) {
    assert_eq(
      lst_from(concat(slice(xs,[0:i-1]), slice(xs,[i+1:N-1]))),
      lst_remove(xls, i));
  }
}

let (inc = function(x) x+1) {
  assert_true(lst_is_empty(lst_map(lst_empty, inc)));
  assert_eq(lst_from(array([1:10])), lst_map(lst_from(array([0:9])), inc));
}

let (even = function(x) x % 2 == 0) {
  assert_true(lst_is_empty(lst_filter(lst_empty, even)));
  assert_eq(
    lst_from(array([2:2:10])),
    lst_filter(lst_from(array([1:11])), even));
}

for (xs = [[], [0], [0,1], [1,0], rands(0,1,100), rands(0,1,200)]) {
  let (xls = lst_from(xs), sxs = quicksort(xs)) {
    assert_eq(sxs, lst_array(lst_quicksort(xls)));
    assert_eq(sxs, lst_array(lst_quicksort(xls, compare)));
  }
}
