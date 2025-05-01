/*
A Set/Map implemented as a Treap.
The operation naming follows searchtree.scad,
but top level definitions start with `treap_`.

### Implementation details

Outer structure: `[root, cmp]`.
Node structure: `[left, right, key, priority]`
  or `[left, right, key, priority, value]`.
Absent node: `undef`.

Tree has a heap structure sorted by priority, highest priority at the root.
*/

include <searchtree.scad>

treap_mknode = function(left, right, key, pri, val)
  is_undef(val) ? [left, right, key, pri] : [left, right, key, pri, val];

treap_newnode = function(left, right, key, val)
  treap_mknode(left, right, key, rands(0,1,1)[0], val);

treap_setnode = function(node, val)
  treap_mknode(node[0], node[1], node[2], node[3], val);
treap_setsubs = function(node, left, right)
  treap_mknode(left, right, node[2], node[3], node[4]);

treap_pri = function(node) is_undef(node) ? -1 : node[3];

treap_join = function(node, left, right)
  !(is_list(left) || is_undef(left)) || !(is_list(right) || is_undef(right))
  ? echo("Chungui", left, right) undef
  :
  let (
    npri = treap_pri(node), lpri = treap_pri(left), rpri = treap_pri(right)
  )
  npri >= lpri && npri >= rpri
  ? treap_setsubs(node, left, right)
  : lpri >= rpri
  ? treap_setsubs(left, left[0], treap_join(node, left[1], right))
  : treap_setsubs(right, treap_join(node, left, right[0]), right[1]);

treap_concat = function(left, right)
  is_undef(left) ? right
  : is_undef(right) ? left
  : let (lpri = left[3], rpri = right[3])
  lpri >= rpri ? treap_setsubs(left, left[0], treap_concat(left[1], right))
  : treap_setsubs(right, treap_concat(left, right[0]), right[1]);

treap_new = function(cmp) [undef, cmp];

treap_size = stree_size;

treap_depth = stree_depth;

treap_array = function(tp)
  let (
    entry = function(key, val) is_undef(val) ? [key] : [[key,val]],
    array = function(node) (
      is_undef(node) ? []
      : concat(array(node[0]), entry(node[2], node[4]), array(node[1]))
    )
  ) array(tp[0]);

treap_find = stree_find;

treap_has = stree_has;

treap_get = function(tp, key)
  let (node = treap_find(tp, key)) is_undef(node) ? undef : node[4];

treap_add = function(tp, key) treap_set(tp, key, undef);

treap_set_entry = function(st, entry) treap_set(st, entry[0], entry[1]);

treap_set = function(tp, key, val)
  let (
    cmp = tp[1],
    set = function(node) (
      is_undef(node)
      ? treap_newnode(undef, undef, key, val)
      : let (left = node[0], right = node[1], okey = node[2], c = cmp(key,okey))
      c < 0 ? treap_join(node, set(left), right)
      : c > 0 ? treap_join(node, left, set(right))
      : treap_setnode(node, val)
    )
  ) [ set(tp[0]), cmp ];

treap_delete = function(tp, key)
  let (
    cmp = tp[1],
    del = function(node) (
      is_undef(node) ? node
      : let (left = node[0], right = node[1], okey = node[2], c = cmp(key,okey))
      c < 0 ? treap_join(node, del(left), right)
      : c > 0 ? treap_join(node, left, del(right))
      : treap_concat(left, right)
    )
  ) [ del(tp[0]), cmp ];

treap_remove = treap_delete;

treap_map = function(tp, f)
  let (
    map = function(node) (
      is_undef(node) ? node
      : treap_mknode(map(node[0]), map(node[1]), node[2], node[3], f(node[4]))
    )
  ) [ map(tp[0]), tp[1] ];
