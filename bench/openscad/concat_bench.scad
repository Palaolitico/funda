/*

A benchmark to compare several array creation strategies.
This is the execution in a Linux, on an x86_64, turbo disabled,
constructing arrays of length [for (n = [10:19]) 2^n]
```
rng       fwd       bwd       bin
0m0,057s  0m0,058s  0m0,055s  0m0,052s
0m0,053s  0m0,052s  0m0,049s  0m0,060s
0m0,058s  0m0,060s  0m0,064s  0m0,065s
0m0,052s  0m0,077s  0m0,066s  0m0,085s
0m0,062s  0m0,084s  0m0,085s  0m0,121s
0m0,066s  0m0,113s  0m0,107s  0m0,178s
0m0,065s  0m0,168s  0m0,169s  0m0,319s
0m0,085s  0m0,285s  0m0,281s  0m0,572s
0m0,134s  0m0,525s  0m0,522s  0m1,112s
0m0,194s  0m1,027s  0m1,023s  0m2,194s
```
Surprisingly, binary strategy is slower than prepending/appending.
OpenSCAD must doing some kind of optimization for appending
and prepending.

Anyways, appending/prepending penalty grows superlinearly, but it is
only 5 times slower on huge arrays.
Therefore, it is sensible to build arrays appending data
when an array comprehension is not suitable.

Code to run this benchmark:
```
for alg in rng fwd bwd bin; do for s in $(seq 10 19); do  echo $s $alg; time openscad -o /dev/null --export-format binstl -Dlog2=$s -Dcreate=create_$alg ideas/understanding/concat-perf.scad; done; done
```

*/

create_rng = function(n) [for (i=[0:n-1]) i];

create_fwd = function(n)
  let (
    mk = function(xs, i) n <= i ? xs : mk(concat(xs,[i]), i+1)
  ) mk([], 0);

create_bwd = function(n)
  let (
    mk = function(xs, i) i < 0 ? xs : mk(concat([i],xs), i-1)
  ) mk([], n-1);

create_bin = function(n)
  let (
    mk = function(i, j) i == j ? [i]
    : let (m = floor((i+j)/2)) concat(mk(i,m), mk(m+1,j))
  ) n <= 0 ? [] : n == 1 ? [0] : mk(0,n-1);

log2 = 10;
create = create_rng;

echo(len(create(floor(pow(2,log2)))));
