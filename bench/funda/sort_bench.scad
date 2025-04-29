/*

A sorting benchmark.
Performance using random arrays:
```
        quicksort   mergesort   quicksort_cmp   mergesort_cmp
   100  0m0,074s    0m0,052s    0m0,055s        0m0,056s
  1000  0m0,069s    0m0,082s    0m0,107s        0m0,098s
 10000  0m0,288s    0m0,557s    0m0,902s        0m0,785s
100000  0m2,952s    0m6,357s    0m10,490s       0m9,349s

        quicksort3  quicksort3_cmp
   100  0m0,066s    0m0,063s
  1000  0m0,117s    0m0,114s
 10000  0m0,711s    0m1,094s
100000  0m9,005s    0m11,685s
```

When using primitive comparisons directly, quicksort is a clear winner.
For general comparison function, mergesort is slightly better, because
current quicksort implementation requires 3 comparisons per element.
`quicksort3` makes only one comparison per element,
but needs to use `concat` instead of array comprehension;
the net result is worse.

Performance for ascending and descending sorted lists is very similar,
except for `quicksort3` that chooses the first element as pivot.

Code to run this test:
```
for A in quicksort mergesort quicksort_cmp mergesort_cmp; do for G in random inc dec; do for N in 100 1000 10000 100000; do time openscad -o /dev/null --export-format binstl -DN=$N -Dgen=${G}_gen -Dsort=$A bench/funda/sort_bench.scad; done; done; done
```
*/

include<../../sort.scad>

random_gen = function(n) rands(0,1, n);
asc_gen = function(n) [for (x = [0:n-1]) x];
des_gen = function(n) [for (x = [n-1:-1:0]) x];

nosort = function(xs) xs;
quicksort_cmp = function(xs, cmp=compare) quicksort(xs, cmp);
quicksort3_cmp = function(xs, cmp=compare) quicksort3(xs, cmp);
mergesort_cmp = function(xs, cmp=compare) mergesort(xs, cmp);

N = 1000;
gen = random_gen;
sort = nosort;

echo(len(sort(gen(N))));
