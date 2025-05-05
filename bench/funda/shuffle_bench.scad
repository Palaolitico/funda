/*

A shuffle benchmark.
Comparing recursive shuffling with base case for length <= 1
to shuffling considering also length 2 as a base case.
Time to shuffle 1e5 elements:
```
Length <= 1 base cases: 0m3,620s
Length <= 2 base cases: 0m2,868s
```
The optimization pays off clearly.

Code to run this bench:
```
p@pdroleo:main~/y/3d/funda$ for A in shuffle shuffle1; do echo $A; time openscad -o /dev/null --export-format binstl -DN=100000 -Dfun=$A bench/funda/shuffle_bench.scad; done;
````
*/

include <../../array.scad>

shuffle1 = function(xs)
  let (n = len(xs)) n <= 1 ? xs
  : let(
    disc = [for (r = rands(0,1, n)) r < 0.5],
    left = [for (i = [0:n-1]) if (disc[i]) xs[i]],
    right = [for (i = [0:n-1]) if (!disc[i]) xs[i]]
  ) concat(shuffle1(left), shuffle1(right));

N = 1000;
fun = shuffle;

echo(len(fun(array_id(N))));
