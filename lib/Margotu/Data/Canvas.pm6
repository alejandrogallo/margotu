unit module Margotu::Data::Canvas;

use Margotu::Data::Style;
use Margotu::Data::Drawable;
use Margotu::Data::Point;

role Canvas is export {
  has Str @!content;
  multi method draw(Drawable $a) of Str { * }
  multi method save(Str $a) of Str { push @!content, $a; $a }
  method to-file(Str $file) { $file.IO.spurt: join "\n", @!content }
  method open(Str $file) { * }
 }

class Asymptote is Canvas is export {
  has Str $.executable = "asy";
  has Str $.open-cmd = "asy -V";
  method open(Str $file) { shell qqw! $.open-cmd "$file" !  }


  multi method serialize(Style:U $r) of Str { "" }
  multi method serialize(LinearPath $p) of Str { $p.points
                                                   .map({$.serialize: $_ })
                                                   .join: " -- "     }
  multi method serialize(Point $p) of Str { $p.list[0,1].raku }
  multi method serialize(Rgb $r) of Str { <rgb> ~ $r.list.raku }
  multi method serialize(Circle $c) of Str {
    <circle> ~ (($c.anchor.x, $c.anchor.y), $c.r).raku
  }
  multi method draw(Group $g) {$g.items.map({$.draw: $_ }).join("\n")}
  multi method draw(LinearPath $c) {
    $.save: join "", gather {
      take <draw(>;
      take $.serialize: $c;
      take ", " ~ $.serialize($_) with $c.stroke;
      take <);>;
    }
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
