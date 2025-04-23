/**
 * Basic assertion modules for testing.
 */

module assert_true(q, message = undef) {
  if (!q) {
    msg = is_undef(message) ? "Failed assertion"
      : is_string(message) ? message
      : is_function(message) ? message()
      : str(message);
    assert(false, msg);
  }
}

module assert_eq(x, y, message = undef) {
  ok = x==y;
  if (!ok) {
    msg = is_undef(message) ? str("Expected ", y, " to be ", x)
      : is_string(message) ? message
      : is_function(message) ? message(x, y)
      : str(message);
    assert(false, msg);
  }
}

module assert_all(p, xs, message = undef) {
  kos = [for (x = xs) if (!p(x)) x];
  if (len(kos) > 0) {
    msg = is_undef(message)
      ? str("There are ", len(kos), " values not fulfilling ", p, ": ", kos)
      : is_string(message) ? message
      : is_function(message) ? message(p, xs, kos)
      : str(message);
    assert(false, msg);
  }
}
