include <../assert.scad>
include <../searchtree.scad>
include <../array.scad>
include <../sort.scad>

//Test set interface
for (i = [0:9]) {
  let (
    N = 1000,
    xs = rands(0,1, N),
    sxs = quicksort(xs),
    st = foldl(stree_new(compare), xs, stree_add),
    ys = stree_array(st)
  ) {
    assert_eq(N, stree_size(st));
    assert_eq(sxs, ys);
    assert_true(!stree_has(sxs[0]-1));
    for (i = [0:N-1]) {
      let (
        key = sxs[i]
      ) {
        assert_true(stree_has(st, key));
        assert_true(is_undef(stree_get(st, key)));
        if (i < N-1) assert_true(!stree_has(st, (key + sxs[i+1]) / 2));
      }
    }
    assert_true(!stree_has(sxs[N-1]+1));
  }
}

//Test map interface
for (i = [0:9]) {
  let (
    N = 1000,
    xs = rands(0,1, N),
    ps = [for (i = [0:N-1]) [xs[i], i]],
    sps = quicksort(ps, function(a,b) compare(a[0], b[0])),
    st = foldl(stree_new(compare), ps, stree_set_entry),
    qs = stree_array(st)
  ) {
    assert_eq(N, stree_size(st));
    assert_eq(sps, qs);
    assert_true(!stree_has(sps[0][0]-1));
    for (i = [0:N-1]) {
      let (
        key = sps[i][0],
        val = sps[i][1],
      ) {
        assert_true(stree_has(st, key));
        assert_eq(val, stree_get(st, key));
        if (i < N-1) assert_true(!stree_has(st, (key + sps[i+1][0]) / 2));
      }
    }
    assert_true(!stree_has(sps[N-1][0]+1));
  }
}
