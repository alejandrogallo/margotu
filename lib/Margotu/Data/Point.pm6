unit module Margotu::Data::Point;
use Margotu::Data::Monoid;

class Point { ... }
class Point is export does Monoid[Point] {
  has Real $.x=0; has Real $.y=0; has Real $.z = 0;
  method gist of Str { "($!x $!y $!z)" }
  method list { ($!x, $!y, $!z) }
  method abs of Num { sqrt([+] [Z*] $_, $_) given $.list }

  # construct from list
  multi method new (@a) { self.bless(|hash <x y z> Z=> @a) }

  # monoidal structure
  method mempty of Point { Point.new }
  method mappend (Point $a) of Point { Point.new: [Z+] $.list, $a.list }
}

sub infix:<v> (*@a) is assoc<list> is export { Point.new: @a }
multi circumfix:<v( )>(*@a) of Point is export { Point.new: @a }
multi prefix:<v>(*@a) of Point is export { Point.new: @a».Real }

multi postfix:<vx> (Real $x) of Point is export { $x v 0  }
multi postfix:<vy> (Real $y) of Point is export { 0  v $y }
multi postfix:<vz> (Real $z) of Point is export { [v] 0, 0, $z }

multi scalar-product (Point $a, Point $b) of Real is export { [+] ($a.list Z* $b.list) }
multi infix:<*> (Point $a, Point $b) of Real is export { scalar-product $a, $b }
multi infix:<*> (Real $a, Point $b) of Point is export { [v] map $a * *, $b.list }

multi sum (Point $a, Point $b) of Point is export { $a <> $b }

multi prefix:<-> (Point $a) of Point is export { [v] map -*, $a.list }
multi infix:<-> (Point $a, Point $b) is export { [v] $a.list Z- $b.list }

multi abs(Point $a) of Num is export { $a.abs }
multi circumfix:<I I>(Point $a) of Num is export { $a.abs }

multi infix:<L> (Point $a, Point $b) is export of Bool { ($a * $b) eq 0 }

multi infix:<||> (Point $a, Point $b) is export of Bool { not $a L $b }

multi angle(Point $a, Point $b) of Real is export {
  (0 eq $a.abs * $b.abs) ?? 0.0 !! .acos given ($a * $b) / ($a.abs * $b.abs)
}
multi infix:<∠> (Point $a, Point $b) of Real is export { angle $a, $b }
multi infix:<V> (Point $a, Point $b) of Real is export { angle $a, $b }

multi infix:<x> (Point $a, Point $b) is export {
  [v] $a.y * $b.z - $a.z * $b.y
    , $a.z * $b.x - $a.x * $b.z
    , $a.x * $b.y - $a.y * $b.x
}
