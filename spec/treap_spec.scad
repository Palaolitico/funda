include <../assert.scad>
include <../treap.scad>
include <../array.scad>
include <../sort.scad>

//Test set interface
for (i = [0:9]) {
  let (
    N = 1024,
    D = 30, //Depth bound
    xs = rands(0,1, N),
    tp = foldl(treap_new(compare), xs, treap_add),
    sxs = quicksort(xs),
    stp = foldl(treap_new(compare), sxs, treap_add),
  ) {
    assert_eq(N, treap_size(tp));
    assert_eq(N, treap_size(stp));
    assert_eq(sxs, treap_array(tp));
    assert_eq(sxs, treap_array(stp));
    assert_true(treap_depth(tp) <= D);
    assert_true(treap_depth(stp) <= D);

    let (bef = sxs[0]-1) {
      assert_true(!treap_has(tp, bef));
      assert_true(!treap_has(stp, bef));
    }
    for (i = [0:N-1]) {
      let (
        key = sxs[i]
      ) {
        assert_true(treap_has(tp, key));
        assert_true(treap_has(stp, key));
        assert_true(is_undef(treap_get(tp, key)));
        assert_true(is_undef(treap_get(stp, key)));
        if (i < N-1) {
          let (mid = (key + sxs[i+1]) / 2) {
            assert_true(!treap_has(tp, mid));
            assert_true(!treap_has(stp, mid));
          }
        }
      }
    }
    let (after = sxs[N-1]+1) {
      assert_true(!treap_has(tp, after));
      assert_true(!treap_has(stp, after));
    }

    let (
      rxs = slice(xs, [0:2:N-1]),
      tp2 = foldl(tp, rxs, treap_delete),
      stp2 = foldl(stp, rxs, treap_delete)
    ) {
      assert_eq(N-len(rxs), treap_size(tp2));
      assert_eq(N-len(rxs), treap_size(stp2));
      //Delete can make depth grow, so it is not sensible to check for
      //assert_true(treap_depth(tp2) <= treap_depth(tp));
      assert_true(treap_depth(tp2) <= D);
      assert_true(treap_depth(stp2) <= D);
      for (i = [0:N-1]) {
        let (
          key = xs[i],
        ) {
          assert_eq(i % 2 == 1, treap_has(tp2, key));
          assert_eq(i % 2 == 1, treap_has(stp2, key));
        }
      }
    }
  }
}


//Test map interface
for (i = [0:9]) {
  let (
    N = 1000,
    D = 30, //Depth bound
    xs = rands(0,1, N),
    ps = [for (i = [0:N-1]) [xs[i], i]],
    tp = foldl(treap_new(compare), ps, treap_set_entry),
    sps = quicksort(ps, function(a,b) compare(a[0], b[0])),
    stp = foldl(treap_new(compare), sps, treap_set_entry)
  ) {
    assert_eq(N, treap_size(tp));
    assert_eq(N, treap_size(stp));
    assert_eq(sps, treap_array(tp));
    assert_eq(sps, treap_array(stp));
    assert_true(treap_depth(tp) <= D);
    assert_true(treap_depth(stp) <= D);

    let (bef = sps[0][0]-1) {
      assert_true(!treap_has(tp, bef));
      assert_true(!treap_has(stp, bef));
    }
    for (i = [0:N-1]) {
      let (
        key = sps[i][0],
        val = sps[i][1],
      ) {
        assert_true(treap_has(tp, key));
        assert_true(treap_has(stp, key));
        assert_eq(val, treap_get(tp, key));
        assert_eq(val, treap_get(stp, key));
        if (i < N-1) {
          let (mid = (key + sps[i+1][0]) / 2) {
            assert_true(!treap_has(tp, mid));
            assert_true(!treap_has(stp, mid));
          }
        }
      }
    }
    let (after = sps[N-1][0]+1) {
      assert_true(!treap_has(tp, after));
      assert_true(!treap_has(stp, after));
    }

    let (
      inc = function(x) x+1,
      incval = function(p) [p[0], p[1]+1],
      tp2 = treap_map(tp, inc)
    ) {
      assert_eq(map(sps,incval), treap_array(tp2));
    }

    let (
      rxs = slice(xs, [0:2:N-1]),
      tp2 = foldl(tp, rxs, treap_delete),
      stp2 = foldl(stp, rxs, treap_delete)
    ) {
      assert_eq(N-len(rxs), treap_size(tp2));
      assert_eq(N-len(rxs), treap_size(stp2));
      assert_true(treap_depth(tp2) <= D);
      assert_true(treap_depth(stp2) <= D);
      for (i = [0:N-1]) {
        let (
          key = ps[i][0],
          val = ps[i][1]
        ) {
          assert_eq(i % 2 == 1, treap_has(tp2, key));
          assert_eq(i % 2 == 1, treap_has(stp2, key));
          if (i % 2 == 1) {
            assert_eq(val, treap_get(tp2, key));
            assert_eq(val, treap_get(stp2, key));
          }
        }
      }
    }
  }
}
