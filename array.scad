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
