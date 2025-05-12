/*
Linked list.

To avoid namespace collition, all top level definitions start with `lst_`.

### Implementation details

- Sequence of nested pair ending in undef: [x0, [x1, ... [xn, undef]...]]
*/

include <comparison.scad>

lst_empty = undef;
lst_cons = function(x,xs) [x, xs];
lst_is_empty = function(xs) is_undef(xs);
lst_car = function(xs) xs[0];
lst_cdr = function(xs) xs[1];

lst_from = function(arr) let (
  mk = function(i, rs) (i < 0) ? rs : mk(i-1, lst_cons(arr[i], rs))
) mk(len(arr)-1, lst_empty);

lst_array = function(xs) [
  for (ptr = xs; !lst_is_empty(ptr); ptr = lst_cdr(ptr)) lst_car(ptr)
];

lst_size = function(xs) let (
  size = function(xs, n) lst_is_empty(xs) ? n : size(lst_cdr(xs), n+1)
) size(xs, 0);

lst_len = lst_size;

lst_at = function(xs, n) let (
  at = function(xs, i)
  lst_is_empty(xs) ? undef : i == 0 ? lst_car(xs) : at(lst_cdr(xs), i-1)
) n < 0 ? undef : at(xs, n);

lst_last = function(xs) let (
  last = function(x, xs) lst_is_empty(xs) ? x : last(lst_car(xs), lst_cdr(xs))
) lst_is_empty(xs) ? undef : last(lst_car(xs), lst_cdr(xs));

lst_append = function(xs, x) lst_reverse(lst_cons(x,lst_reverse(xs)));

lst_concat = function(xs, ys) let (
  cc = function(rs, ys)
  lst_is_empty(rs) ? ys : cc(lst_cdr(rs), lst_cons(lst_car(rs),ys))
) cc(lst_reverse(xs), ys);

lst_set = function(xs, n, x) let (
  set = function(xs, i, rs) (
    i == 0
    ? lst_reverse_on(rs, lst_cons(x, lst_is_empty(xs) ? xs : lst_cdr(xs)))
    : set(lst_cdr(xs), i-1, lst_cons(lst_car(xs),rs))
  )
) n < 0 ? xs : set(xs, n, lst_empty);

lst_insert = function(xs, n, x) let (
  insert = function(xs, i, rs) (
    i == 0
    ? lst_reverse_on(rs, lst_cons(x, xs))
    : insert(lst_cdr(xs), i-1, lst_cons(lst_car(xs),rs))
  )
) n < 0 ? xs : insert(xs, n, lst_empty);

lst_remove = function(xs, n) let (
  remove = function(xs, i, rs) (
    lst_is_empty(xs) ? lst_reverse(rs)
    : i == 0 ? lst_reverse_on(rs, lst_cdr(xs))
    : remove(lst_cdr(xs), i-1, lst_cons(lst_car(xs),rs))
  )
) n < 0 ? xs : remove(xs, n, lst_empty);

lst_reverse = function(xs) lst_reverse_on(xs, lst_empty);

lst_reverse_on = function(xs, rs)
  lst_is_empty(xs) ? rs : lst_reverse_on(lst_cdr(xs), lst_cons(lst_car(xs),rs));

lst_map = function(xs, fun) let (
  map = function(xs, as)
  lst_is_empty(xs) ? as : map(lst_cdr(xs), lst_cons(fun(lst_car(xs)),as))
) lst_reverse(map(xs, lst_empty));

lst_filter = function(xs, test) let (
  filter = function(xs, as) lst_is_empty(xs) ? as
  : filter(lst_cdr(xs), let (x = lst_car(xs)) test(x) ? lst_cons(x,as) : as)
) lst_reverse(filter(xs, lst_empty));

lst_quicksort = function(xs, cmp = undef) let (
  sort_fast = function(xs) (
    lst_is_empty(xs) ? xs
    : let (
      p = lst_car(xs),
      ys = lst_cdr(xs),
      les = lst_filter(ys, less_equal1(p)),
      gts = lst_filter(ys, greater_than1(p))
    ) lst_concat(sort_fast(les), lst_cons(p, sort_fast(gts)))
  ),
  sort_gen = function(xs) (
    lst_is_empty(xs) ? xs
    : let (
      p = lst_car(xs),
      ys = lst_cdr(xs),
      les = lst_filter(ys, function(x) cmp(p,x) >= 0),
      gts = lst_filter(ys, function(x) cmp(p,x) < 0)
    ) lst_concat(sort_gen(les), lst_cons(p, sort_gen(gts)))
  )
) is_undef(cmp) ? sort_fast(xs) : sort_gen(xs);
