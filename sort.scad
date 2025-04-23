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


merge = function(xs, ys, le = less_equal)
  let (
    m = function(zs, a,b, c,d)
    a < b && (c == d || le(xs[a], ys[c])) ? m(concat(zs,xs[a]), a+1,b, c,d)
    : c < d && (a == b || le(ys[c], xs[a])) ? m(concat(zs,ys[c]), a,b, c+1,d)
    : zs
  ) m([], 0,len(xs), 0,len(ys));

//iperm_apply = function(xs, ips)



quicksort = function(xs, cmp = compare)
  let (
    sort = function(ys) len(ys) <= 1 ? ys : let (pivot = ys[0])
    concat(
      sort([for (x = ys) if (x < pivot) x]),
      [for (x = ys) if (x == pivot) x],
      sort([for (x = ys) if (x > pivot) x])
    )
  ) sort(xs);
