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
  ) {
    assert_eq(N, stree_size(st));
    assert_eq(sxs, stree_array(st));
    assert_true(!stree_has(st, sxs[0]-1));
    for (i = [0:N-1]) {
      let (
        key = sxs[i]
      ) {
        assert_true(stree_has(st, key));
        assert_true(is_undef(stree_get(st, key)));
        if (i < N-1) assert_true(!stree_has(st, (key + sxs[i+1]) / 2));
      }
    }
    assert_true(!stree_has(st, sxs[N-1]+1));

    let (
      rxs = slice(xs, [0:2:N-1]),
      st2 = foldl(st, rxs, stree_delete)
    ) {
      assert_eq(N-len(rxs), stree_size(st2));
      for (i = [0:N-1]) {
        let (
          key = xs[i],
        ) {
          assert_eq(i % 2 == 1, stree_has(st2, key));
        }
      }
    }
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
  ) {
    assert_eq(N, stree_size(st));
    assert_eq(sps, stree_array(st));
    assert_true(!stree_has(st, sps[0][0]-1));
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
    assert_true(!stree_has(st, sps[N-1][0]+1));

    let (
      inc = function(x) x+1,
      incval = function(p) [p[0], p[1]+1],
      st2 = stree_map(st, inc)
    ) {
      assert_eq(map(sps,incval), stree_array(st2));
    }

    let (
      rxs = slice(xs, [0:2:N-1]),
      st2 = foldl(st, rxs, stree_delete)
    ) {
      assert_eq(N-len(rxs), stree_size(st2));
      for (i = [0:N-1]) {
        let (
          key = ps[i][0],
          val = ps[i][1]
        ) {
          assert_eq(i % 2 == 1, stree_has(st2, key));
          if (i % 2 == 1) {
            assert_eq(val, stree_get(st2, key));
          }
        }
      }
    }
  }
}
