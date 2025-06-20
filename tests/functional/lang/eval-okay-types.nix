with builtins;

[
  (isNull null)
  (isNull (x: x))
  (isFunction (x: x))
  (isFunction "fnord")
  (isString ("foo" + "bar"))
  (isString [ "x" ])
  (isInt (1 + 2))
  (isInt { x = 123; })
  (isInt (1 / 2))
  (isInt (1 + 1))
  (isInt (1 / 2))
  (isInt (1 * 2))
  (isInt (1 - 2))
  (isFloat (1.2))
  (isFloat (1 + 1.0))
  (isFloat (1 / 2.0))
  (isFloat (1 * 2.0))
  (isFloat (1 - 2.0))
  (isBool (true && false))
  (isBool null)
  (isPath /bsd/store)
  (isPath ./.)
  (isAttrs { x = 123; })
  (isAttrs null)
  (typeOf (3 * 4))
  (typeOf true)
  (typeOf "xyzzy")
  (typeOf null)
  (typeOf { x = 456; })
  (typeOf [
    1
    2
    3
  ])
  (typeOf (x: x))
  (typeOf ((x: y: x) 1))
  (typeOf map)
  (typeOf (map (x: x)))
]
