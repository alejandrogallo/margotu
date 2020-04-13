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
  is looser(&infix:<+>)
  is export {
  my $b = $a;
  with $b.stroke { $b.stroke <>= $s; }
  else           { $b.stroke = $s; }
  $b.stroke <>= $s;
  $b;
}

class Circle does Drawable is export { has Real $.r; }
sub circle (|c) is export { Circle.new: |c };


