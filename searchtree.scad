/*
  A Set/Map implemented as a binary search tree.
  The tree no balancing strategy; see treap.scad for a balanced tree.
  API provides both a set and map view, simultaneously;
  therefore, the same tree can be used at the same time as a set and as a map;
  retrieving a value for a key that was inserted as a set will provide an `undef`.

  To avoid namespace collition, all top level definitions start with `stree_`.

  ### Implementation details

  Outer structure: `[root, cmp]`.
  Node structure: `[key, left, right]` or `[key, left, right, value]`.
  Absent node: `undef`.
*/

stree_new = function(cmp) [undef, cmp];

stree_size = function(st)
  let (
    size = function(node) is_undef(node) ? 0 : 1 + size(node[1]) + size(node[2])
  ) size(st[0]);

stree_array = function(st)
  let (
    entry = function(key, val) is_undef(val) ? [key] : [[key,val]],
    array = function(node) (
      is_undef(node) ? []
      : concat(array(node[1]), entry(node[0], node[3]), array(node[2]))
    )
  ) array(st[0]);

stree_find = function(st, key)
  let (
    cmp = st[1],
    find = function(node) (
      is_undef(node) ? undef
      : let (c = cmp(key, node[0]))
      c < 0 ? find(node[1])
      : c > 0 ? find(node[2])
      : node
    )
  ) find(st[0]);

stree_has = function(st, key) !is_undef(stree_find(st, key));

stree_add = function(st, key) stree_set(st, key, undef);

stree_get = function(st, key)
  let (node = stree_find(st, key)) is_undef(node) ? undef : node[3];

stree_mknode = function(key, val, left, right)
  is_undef(val) ? [key, left, right] : [key, left, right, val];

stree_set_entry = function(st, entry) stree_set(st, entry[0], entry[1]);

stree_set = function(st, key, val)
  let (
    cmp = st[1],
    set = function(node) (
      is_undef(node)
      ? stree_mknode(key, val, undef, undef)
      : let (okey = node[0], left = node[1], right = node[2], c = cmp(key,okey))
      c < 0 ? stree_mknode(okey, node[3], set(left), right)
      : c > 0 ? stree_mknode(okey, node[3], left, set(right))
      : stree_mknode(okey, val, left, right)
    )
  ) [ set(st[0]), cmp ];

stree_delete = function(st, key)
  let (
    cmp = st[1],
    del = function(node) (
      is_undef(node) ? node
      : let (
        okey = node[0], val = node[3],
        left = node[1], right = node[2],
        c = cmp(key,okey)
      ) c < 0 ? stree_mknode(okey, val, del(left), right)
      : c > 0 ? stree_mknode(okey, val, left, del(right))
      : join(left, right)
    ),
    join = function(left, right) (
      is_undef(left) ? right
      : is_undef(right) ? left
      : let (disc = del1(right))
      stree_mknode(disc[0], disc[1], left, disc[2])
    ),
    del1 = function(node) (
      let (
        key = node[0], val = node[3],
        left = node[1], right = node[2]
      )
      is_undef(left) ? [key, val, right]
      : let (r = del1(left)) [r[0], r[1], stree_mknode(key,val, r[2],right)]
    )
  ) [ del(st[0]), cmp ];

stree_remove = stree_delete;

stree_map = function(st, f)
  let (
    map = function(node) (
      is_undef(node) ? node
      : stree_mknode(node[0], map(node[1]), map(node[2]), f(node[3]))
    )
  ) [ map(st[0]), st[1] ];
