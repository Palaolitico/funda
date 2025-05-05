/**
 * Basic operations with arrays.
 */

array_id = function(n) array([0:n-1]);

array = function(rng) [for (x = rng) x];

firstIndexOf = function(xs, x)
  let (
    n = len(xs),
    fio = function(i) n <= i ? -1 : xs[i] == x ? i : fio(i+1)
  ) fio(0);

reverse = function(xs) [for (i = [len(xs)-1:-1:0]) xs[i]];

slice = function(xs, r) [for (i = r) xs[i]];

flatten1 = function(xs) [for (x = xs) if (!is_list(x)) x else each x];
flatten = flatten1;

flatten_all =
  function(xs) [for (x = xs) if (!is_list(x)) x else each flatten_all(x)];

//A simple optimization of shuffle at https://github.com/thehans/funcutils
//Length 2 is handled as a base case.
//The rationale is that half the times `shuffle([a,b])` makes a recursive
//call with `[a,b]` on one branch (and a `[]`) on the other.
//See bench/funda/shuffle_bench.scad for the benchmarking.
shuffle = function(xs)
  let (n = len(xs))
  n <= 2 ? (
    n <= 1 ? xs
    : rands(0,1,1)[0] < 0.5 ? [xs[0],xs[1]] : [xs[1],xs[0]]
    //: let(i = round(rands(0,1,1)[0])) [xs[i],xs[1-i]]
    )
  : let(
    disc = [for (r = rands(0,1, n)) r < 0.5],
    left = [for (i = [0:n-1]) if (disc[i]) xs[i]],
    right = [for (i = [0:n-1]) if (!disc[i]) xs[i]]
  ) concat(shuffle(left), shuffle(right));

map = function(xs, f) [for (x = xs) f(x)];

foldl = function(x, xs, f)
  let (n = len(xs),
       fold = function(x, i) n <= i ? x : fold(f(x,xs[i]), i+1))
  fold(x, 0);

// Non-final foldr
foldr_nf = function(x, xs, f)
  let (n = len(xs),
       fold = function(i) n <= i ? x : f(xs[i], fold(i+1)))
  fold(0);

foldr = function(x, xs, f)
  let (fold = function(x, i) i < 0 ? x : fold(f(xs[i],x), i-1))
  fold(x, len(xs)-1);

filter = function(xs, p) [for (x = xs) if (p(x)) x];
