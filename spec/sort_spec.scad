include <../assert.scad>
include <../sort.scad>
include <../array.scad>

assert_eq(
  [0], [for (i = [0:2:0]) i])

for (contest = [
    [true, []],
    [true, [1]],
    [true, [1,1]],
    [true, [1,2]],
    [false, [2,1]],
    [true, array([0:1e2])],
    [false, reverse(array([0:1e2]))],
    [false, rands(0, 1, 1000)],
  ]) {
  expect = contest[0];
  xs = contest[1];
  assert_eq(expect, is_sorted(xs), function(x,y)
    str("Expected ", xs, " to be ", expect ? "sorted" : "unsorted"));
}

for (contest = [
    [array([0:19]), array([0:19]), []],
    [array([0:19]), [], array([0:19])],
    [array([0:19]), array([0:9]), array([10:19])],
    [array([0:19]), array([10:19]), array([0:9])],
    [array([0:19]), array([0:2:19]), array([1:2:19])],
    [array([0:19]), array([1:2:19]), array([0:2:19])],
    [array([0:19]), [10], concat(array([0:9]), array([11:19]))],
    [array([0:19]), concat(array([0:9]), array([11:19])), [10]],
  ]) {
  expect = contest[0];
  xs = contest[1];
  ys = contest[2];
  assert_eq(expect, merge_sorted(xs, ys));
  assert_eq(expect, merge_sorted(xs, ys, compare));
}

module assert_sorting(sort, xs) {
  ys = sort(xs);
  assert_eq(len(xs), len(ys), message = function(nxs, nys)
    str("Sorted array length ", nys,
      " differs from original array length ", nxs));
  assert_true(is_sorted(ys), message = function()
    str("Returned an unsorted array ", ys));

  q = perm_sort(xs, sort);
  assert_eq(len(xs), len(q), message = function(nxs, nq)
    str("Sorted permutation length ", nq,
      " differs from original array length ", nxs));
  assert_true(perm_is_sorted(xs, q), message = function()
    str("Returned a permutation ", q, " not sorting the array ", xs));
  assert_true(is_sorted(perm_apply(xs,q)), message = function()
    str("Application of permutation ", q,
      " did not generated a sorted array for ", xs));
}

for (sort = [
    quicksort0,
    quicksort3,
    quicksort,
    mergesort,
    function(xs, cmp=compare) quicksort0(xs, cmp),
    function(xs, cmp=compare) quicksort3(xs, cmp),
    function(xs, cmp=compare) quicksort(xs, cmp),
    function(xs, cmp=compare) mergesort(xs, cmp)
  ]) {
  for (xs = [
      [],
      [1],
      array([0:10]),
      reverse(array([0:10])),
      rands(0,1, 1000),
    ]) {
    assert_sorting(sort, xs);
  }
}
