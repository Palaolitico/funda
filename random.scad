/**
 * Random value generation utils
 */

randints = function(min_value=0, max_value, value_count)
  [for (x = rands(min_value, max_value, value_count)) floor(x)];

randint = function(min_value=0, max_value)
  floor(rands(min_value, max_value, 0)[0]);
