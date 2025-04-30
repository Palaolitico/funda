/*
A Set/Map implemented as a binary search tree.
The tree no balancing strategy; see treap.scad for a balanced tree.
API provides both a set and map view, simultaneously;
therefore, the same tree can be used at the same time as a set and as a map;
retrieving a value for a key that was inserted as a set will provide an `undef`.

To avoid namespace collition, all top level definitions start with `stree_`.

### Implementation details

Outer structure: `[root, cmp]`.
Node structure: `[left, right, key]` or `[left, right, key, value]`
Absent node: `undef`.
*/

stree_mknode = function(left, right, key, val)
  is_undef(val) ? [left, right, key] : [left, right, key, val];

stree_new = function(cmp) [undef, cmp];

stree_size = function(st)
  let (
    size = function(node) is_undef(node) ? 0 : 1 + size(node[0]) + size(node[1])
  ) size(st[0]);

stree_depth = function(tp)
  let (
    depth = function(node) (
      is_undef(node) ? 0 : 1 + max(depth(node[0]), depth(node[1]))
    )
  ) depth(tp[0]);

stree_array = function(st)
  let (
    entry = function(key, val) is_undef(val) ? [key] : [[key,val]],
    array = function(node) (
      is_undef(node) ? []
      : concat(array(node[0]), entry(node[2], node[3]), array(node[1]))
    )
  ) array(st[0]);

stree_find = function(st, key)
  let (
    cmp = st[1],
    find = function(node) (
      is_undef(node) ? undef
      : let (c = cmp(key, node[2]))
      c < 0 ? find(node[0])
      : c > 0 ? find(node[1])
      : node
    )
  ) find(st[0]);

stree_has = function(st, key) !is_undef(stree_find(st, key));

stree_get = function(st, key)
  let (node = stree_find(st, key)) is_undef(node) ? undef : node[3];

stree_add = function(st, key) stree_set(st, key, undef);

stree_set_entry = function(st, entry) stree_set(st, entry[0], entry[1]);

stree_set = function(st, key, val)
  let (
    cmp = st[1],
    set = function(node) (
      is_undef(node)
      ? stree_mknode(undef, undef, key, val)
      : let (left = node[0], right = node[1], okey = node[2], c = cmp(key,okey))
      c < 0 ? stree_mknode(set(left), right, okey, node[3])
      : c > 0 ? stree_mknode(left, set(right), okey, node[3])
      : stree_mknode(left, right, okey, val)
    )
  ) [ set(st[0]), cmp ];

stree_delete = function(st, key)
  let (
    cmp = st[1],
    del = function(node) (
      is_undef(node) ? node
      : let (
        left = node[0], right = node[1],
        okey = node[2], val = node[3],
        c = cmp(key,okey)
      ) c < 0 ? stree_mknode(del(left), right, okey, val)
      : c > 0 ? stree_mknode(left, del(right), okey, val)
      : join(left, right)
    ),
    join = function(left, right) (
      is_undef(left) ? right
      : is_undef(right) ? left
      : let (disc = del1(right))
      stree_mknode(left, disc[2], disc[0], disc[1])
    ),
    del1 = function(node) (
      let (
        left = node[0], right = node[1],
        key = node[2], val = node[3]
      )
      is_undef(left) ? [key, val, right]
      : let (r = del1(left)) [r[0], r[1], stree_mknode(r[2],right, key,val)]
    )
  ) [ del(st[0]), cmp ];

stree_remove = stree_delete;

stree_map = function(st, f)
  let (
    map = function(node) (
      is_undef(node) ? node
      : stree_mknode(map(node[0]), map(node[1]), node[2], f(node[3]))
    )
  ) [ map(st[0]), st[1] ];
