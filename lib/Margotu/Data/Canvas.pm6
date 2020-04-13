unit module Margotu::Data::Canvas;

use Margotu::Data::Style;
use Margotu::Data::Drawable;
use Margotu::Data::Point;

role Canvas is export {
  has Str @!content;
  multi method draw(Drawable $a) of Str { * }
  multi method save(Str $a) of Str { push @!content, $a; $a }
}

class Asymptote is Canvas is export {
  has Str $.psviewer = "ghostview";

  multi method serialize(Style:U $r) of Str { "" }
  multi method serialize(Rgb $r) of Str { <rgb> ~ $r.list.raku }
  multi method serialize(Circle $c) of Str {
    <circle> ~ (($c.anchor.x, $c.anchor.y), $c.r).raku
  }
  multi method draw(Circle $c) {
    $.save: join "", gather {
      take "draw(" without $c.fill;
      take "filldraw(" with $c.fill;
      take $.serialize: $c;
      take ", " ~ $.serialize($_) with $c.fill;
      take ", " ~ $.serialize($_) with $c.stroke;
      take <);>;
    }
  }
}
