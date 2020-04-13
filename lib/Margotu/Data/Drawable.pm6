unit module Margotu::Data::Drawable;
use Margotu::Data::Point;
use Margotu::Data::Monoid;
use Margotu::Data::Style;

role Drawable is export {
  has Style $.stroke;
  has Style $.fill;
  has Point $.anchor = Point.new;
}

multi sub infix:<stroke> (Drawable $a, Style:D $s)
  of Drawable
  is export {
  my $b = $a;
  with $b.stroke { $b.stroke <>= $s; }
  else           { $b.stroke = $s; }
  $b.stroke <>= $s;
  $b;
}

class Circle does Drawable is export { has Real $.r; }
sub circle (|c) is export { Circle.new: |c };

class LinearPath does Drawable is export {
  has Point @.points;
  method gist { join " -- ", @.points>>.gist }
  multi method new (LinearPath $a) { @.points.append: $a.points }
}

# TODO
class Group does Drawable is export {
  has Drawable @.items;
  multi method new(*@s) { self.bless: items=>@s }
}
multi group(|c) of Group is export { Group.new: |c }

multi infix:<-->(Point $a, Point $b) is export of LinearPath {
  LinearPath.new: :points($a, $b)
}
multi infix:<-->(LinearPath $a, Point $b) is export of LinearPath {
  LinearPath.new: :points(|$a.points, $b)
}
multi infix:<-->(Point $a, LinearPath $b) is export of LinearPath {
  LinearPath.new: :points($a, |$b.points)
}
multi infix:<-->(LinearPath $a, LinearPath $b) is export of LinearPath {
  LinearPath.new: :points(|$a.points, |$b.points)
}
