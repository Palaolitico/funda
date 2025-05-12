/*

Value comparisons.

*/

compare = function(a,b) a < b ? -1 : a > b ? 1 : 0;
less_than = function(a,b) a < b;
less_equal = function(a,b) a <= b;
greater_equal = function(a,b) a >= b;
greater_than = function(a,b) a > b;

compare1 = function(a) function(b) compare(a,b);
less_than1 = function(a) function(b) b < a;
less_equal1 = function(a) function(b) b <= a;
greater_equal1 = function(a) function(b) b > a;
greater_than1 = function(a) function(b) b >= a;
