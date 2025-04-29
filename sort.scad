/**
 * Array sorting.
 *
 * A *direct permutation* is an array with *target positions*.
 * If *p* is a direct permutation and *xs* is an array,
 * apply *p* to *xs* produces an array *ys* such that
 * *ys[p[i]] = xs[i]*.
 * Observe that value at position *i* goes to position *p[i]*,
 * therefore *p* is telling the *target position* for each *i*.
 *
 * A *source permutation* in an array with *source positions*
 * If *q* is an source permutation and *xs* is an array,
 * apply *q* to *xs* produces an array *ys* such that
 * *ys[i] = xs[q[i]]*.
 * Observe that value at position *i* cames from position *q[i]*,
 * therefore *p* is telling the *source position* for each *i*.
 *
 * *Source permutations* are easier to handle and to produce
 *  than *direct permutations*.
 * Particularly, appling a *source permutation* with OpenSCAD
 * is trivial because it is compatible with sequential array creation,
 * but appling a *direct permutation* is not trivial because
 * there is to way to define a random array position.
 *
 * If p and q are equivalent *direct* and *source permutations*,
 * and *I* is the identity array/permutation,
 * the I·p = q and I·q = p
 *
 * A *source permutation sorting algorithm* *S* is a sorting algorithm
 * that produces a *source permutation* instead of a sorted array.
 * Particularly, *S(xs)* produces *q* such that *is_sorted(xs·q)*.
 *
 * *Source permutation sorting*
 * a direct permutation *p* (source permutation *q*)
 * produces an equivalent
 * source permutation *q* (direct permutation *p*).
 */

include <array.scad>

compare = function(a,b) a < b ? -1 : a > b ? 1 : 0;
less_than = function(a,b) a < b;
less_equal = function(a,b) a <= b;
greater_equal = function(a,b) a >= b;
greater_than = function(a,b) a > b;

is_sorted = function(xs, le = less_equal)
  let (
    sorted = function(i) i < 0 ? true : le(xs[i], xs[i+1]) && sorted(i-1)
  ) sorted(len(xs)-2);

merge_le = function(xs, ys, le = less_equal)
  let (
    merge_acc = function(zs, a,b, c,d)
    a < b && (c == d || le(xs[a], ys[c]))
    ? merge_acc(concat(zs,xs[a]), a+1,b, c,d)
    : c < d && (a == b || le(ys[c], xs[a]))
    ? merge_acc(concat(zs,ys[c]), a,b, c+1,d)
    : zs
  ) merge_acc([], 0,len(xs), 0,len(ys));

merge = function(xs, ys, cmp = undef)
  let (
    merge_fast = function(zs, a,b, c,d)
    a < b && (c == d || xs[a] <= ys[c])
    ? merge_fast(concat(zs,xs[a]), a+1,b, c,d)
    : c < d && (a == b || ys[c] <= xs[a])
    ? merge_fast(concat(zs,ys[c]), a,b, c+1,d)
    : zs,

    merge_gen = function(zs, a,b, c,d)
    a < b && (c == d || cmp(xs[a], ys[c]) <= 0)
    ? merge_gen(concat(zs,xs[a]), a+1,b, c,d)
    : c < d && (a == b || cmp(ys[c], xs[a]) <= 0)
    ? merge_gen(concat(zs,ys[c]), a,b, c+1,d)
    : zs
  )
  is_undef(cmp)
  ? merge_fast([], 0,len(xs), 0,len(ys))
  : merge_gen([], 0,len(xs), 0,len(ys));

mergesort = function(xs, cmp = undef)
  let (
    create_singles = function(xs) [for (x = xs) [x]],
    pair_fast = function(x,y) x <= y ? [x,y] : [y,x],
    pair_gen = function(x,y) cmp(x,y) <= 0 ? [x,y] : [y,x],
    pair = is_undef(cmp) ? pair_fast : pair_gen,
    create_pairs = function(xs) (
      let (n = len(xs))
      [for (i = [0:2:n-1]) i == n-1 ? [xs[i]] : pair(xs[i],xs[i+1])]),
    //Starting with sorted pairs is a 10% faster that using singletons
    create_init = create_pairs,
    merge_pairs = function(xss) (
      let (n = len(xss))
      n == 1 ? xss[0] : merge_pairs(
        [for (i = [0:2:n-1]) i == n-1 ? xss[i] : merge(xss[i], xss[i+1], cmp)]))
  ) len(xs) <= 1 ? xs : merge_pairs(create_init(xs));

quicksort0 = function(xs, cmp = undef)
  let (
    sort_fast = function(ys) len(ys) <= 1 ? ys : let (pivot = ys[0])
    concat(
      sort_fast([for (x = ys) if (x < pivot) x]),
      [for (x = ys) if (x == pivot) x],
      sort_fast([for (x = ys) if (x > pivot) x])
    ),
    sort_gen = function(ys) len(ys) <= 1 ? ys : let (pivot = ys[0])
    concat(
      sort_gen([for (x = ys) if (cmp(pivot,x) > 0) x]),
      [for (x = ys) if (cmp(pivot,x) == 0) x],
      sort_gen([for (x = ys) if (cmp(pivot,x) < 0) x])
    )
  ) is_undef(cmp) ? sort_fast(xs) : sort_gen(xs);

quicksort = function(xs, cmp = undef)
  let (
    median_fast = function(ys, a,b,c) (
      ys[a] < ys[b]
      ? ys[b] < ys[c] ? b : ys[a] < ys[c] ? c : a
      : ys[b] > ys[c] ? b : ys[a] > ys[c] ? c : a
    ),
    median_gen = function(ys, a,b,c) (
      cmp(ys[a], ys[b]) < 0
      ? cmp(ys[b], ys[c]) < 0 ? b : cmp(ys[a], ys[c]) < 0 ? c : a
      : cmp(ys[b], ys[c]) > 0 ? b : cmp(ys[a], ys[c]) > 0 ? c : a
    ),
    median = is_undef(cmp) ? median_fast : median_gen,
    tukey = function(ys) (
      let (n = len(ys), med2 = n / 2)
      n <= 7
      ? med2
      : let (med1 = 0, med3 = n-1)
      n <= 40
      ? median(ys, med1,med2,med3)
      : let (
        m = n/8,
        med1 = median(ys, med1, med1+m, med1+m+m),
        med2 = median(ys, med2-m, med2, med2+m),
        med3 = median(ys, med3-m-m, med3-m, med3)
      ) median(ys, med1,med2,med3)
    ),
    sort_fast = function(ys) len(ys) <= 1 ? ys
    : let (pivot = ys[tukey(ys)]) concat(
      sort_fast([for (x = ys) if (x < pivot) x]),
      [for (x = ys) if (x == pivot) x],
      sort_fast([for (x = ys) if (x > pivot) x])
    ),
    sort_gen = function(ys) len(ys) <= 1 ? ys
    : let (pivot = ys[tukey(ys)]) concat(
      sort_gen([for (x = ys) if (cmp(pivot,x) > 0) x]),
      [for (x = ys) if (cmp(pivot,x) == 0) x],
      sort_gen([for (x = ys) if (cmp(pivot,x) < 0) x])
    )
  ) is_undef(cmp) ? sort_fast(xs) : sort_gen(xs);

quicksort3 = function(xs, cmp = undef)
  let (
    split_fast = function(p, xs, i, ls, es, gs) (
      i == len(xs) ? [ls, es, gs]
      : let (
        x = xs[i]
      ) x < p ? split_fast(p, xs, i+1, concat(ls,x), es, gs)
      : x > p ? split_fast(p, xs, i+1, ls, es, concat(gs,x))
      : split_fast(p, xs, i+1, ls, concat(es,x), gs)
    ),
    split_gen = function(p, xs, i, ls, es, gs) (
      i == len(xs) ? [ls, es, gs]
      : let (
        x = xs[i],
        c = cmp(x,p)
      ) c < 0 ? split_gen(p, xs, i+1, concat(ls,x), es, gs)
      : c > 0 ? split_gen(p, xs, i+1, ls, es, concat(gs,x))
      : split_gen(p, xs, i+1, ls, concat(es,x), gs)
    ),
    split = is_undef(cmp) ? split_fast : split_gen,
    sort = function(xs) (
      len(xs) <= 1 ? xs
      : let (
        pivot = xs[0],
        ss = split(pivot, xs, 1, [], [pivot], [])
      ) concat(sort(ss[0]), ss[1], sort(ss[2]))
    )
  ) sort(xs);

perm_is_sorted = function(xs, q, le = less_equal)
  let (
    sorted = function(i) i < 0 ? true : le(xs[q[i]], xs[q[i+1]]) && sorted(i-1)
  ) sorted(len(q)-2);

perm_sort = function(xs, sort = quicksort, cmp = compare)
  let (
    q = array_id(len(xs)),
    qcmp = function(i, j) cmp(xs[i], xs[j])
  ) sort(q, qcmp);

perm_apply = function(xs, q) [for (i = [0:len(q)-1]) xs[q[i]]];
