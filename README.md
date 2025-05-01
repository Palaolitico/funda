Funda: FUNctional Data structures & Algoritms for OpenSCAD
======================================================================

This project is an experiment on Data Structures and Algoritms with OpenSCAD.

It is pure functional programming, by force,
because OpenSCAD has no way to modify a variable
or a component in a structural value.

API
----------------------------------------------------------------------

Testing
-----------------------------------------------------------------------

This project has a lot of unit testing.
I have never seen a OpenSCAD with test, 
therefore I built a [pretty simple framework](./assert.scad) based con
`assert`.
The main drawback is that the testing process stops on the first failure.

All the testing code is in the [spec folder](./spec).
Currently, the *recommended* way to run it is:
```
for spec in spec/*_spec.scad; do echo $spec; time openscad -o /dev/null --export-format binstl $spec; done
```

OpenSCAD caveats
----------------------------------------------------------------------

### Array comprenhension limits

There is a limit on the length of a range for an array comprehension:
it should be < 10^6.
The following expression
```
xs = [for (x = [1:1e6]) x];
```
fails with
```
WARNING: Bad range parameter in for statement: too many elements (1000000) in ...
```

This limit does not applies when the source is an array instead of a range:
```
xs = [for (x = [1:1e6-1]) x];
xs2 = concat(xs, xs);
ys = [for (x = xs2) x+1];
```

### Recursion limit

OpenSCAD optimizes tail recursion.
For non-tail recursion, it imposes a limit on the number of pending calls,
that is around 1e4.
