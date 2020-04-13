unit module Margotu::Data::Point;

use Margotu::Data::Monoid;


class Point { ... }
class Point is export does Monoid[Point] {
  my Point $outer;
  has Real $.x=0; has Real $.y=0; has Real $.z = 0;
  method gist of Str { "($!x $!y $!z)" }
  method list { $!x, $!y, $!z }
  method abs of Real { sqrt([+] $.list Z* $.list) }

  # monoid
  method mempty { Point.new }
  method mappend (Point $a) of Point {
    Point.new: |hash <x y z> Z=> [Z+] $.list, $a.list
  }

}

multi sub infix:<v> (Real $a, Real $b) is export { Point.new: x=>$a, y=>$b }

multi sub infix:<v> (Point $a, Real $b) is export {
  Point.new: x=>$a.x, y=>$a.y, z=>$b
}

multi sub postfix:<vx> (Real $x) of Point is export { $x v 0  v 0 }
multi sub postfix:<vy> (Real $y) of Point is export { 0  v $y v 0 }
multi sub postfix:<vz> (Real $z) of Point is export { 0  v 0  v $z}

multi sub scalar-product (Point $a, Point $b) of Real is export { [+] ($a.list Z* $b.list) }
multi sub infix:<*> (Point $a, Point $b) of Real is export { scalar-product $a, $b }
multi sub infix:<*> (Real $a, Point $b) of Point is export { [v] map $a * *, $b.list }

multi sub sum (Point $a, Point $b) of Point is export { $a <> $b }

multi sub prefix:<-> (Point $a) of Point is export { [v] map -*, $a.list }
multi sub infix:<-> (Point $a, Point $b) is export { [v] $a.list Z- $b.list }

multi sub abs(Point $a) is export { $a.abs }
multi sub circumfix:<I I>(Point $a) of Real is export { $a.abs }

multi sub infix:<L> (Point $a, Point $b) is export of Bool { ($a * $b) eq 0 }

multi sub infix:<||> (Point $a, Point $b) is export of Bool { not $a L $b }

multi sub angle(Point $a, Point $b) of Real is export {
  ($a * $b) / ([*] ($a, $b)>>.&abs)
}
multi sub infix:<∠> (Point $a, Point $b) is export { angle $a, $b }

multi sub infix:<x> (Point $a, Point $b) is export {
  [v] $a.y * $b.z - $a.z * $b.y
    , $a.z * $b.x - $a.x * $b.z
    , $a.x * $b.y - $a.y * $b.x
}
