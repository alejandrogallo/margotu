# vim:ft=raku
use Test;
use Margotu::Data::Style;
use Margotu::Data::Canvas;
use Margotu::Data::Drawable;
use Margotu::Data::Point;

plan *;


subtest "Asymptote" => {
  plan *;

  my $c = Circle.new(:r(1.0) :stroke(rgb 0.3, 0.4, 0.2));
  ok $c, 'Create a circle of unit with stroke';
  ok $c.stroke, 'Stroke exists';
  is-deeply $c.stroke, rgb 0.3, 0.4, 0.2;

  my $ctx = Asymptote.new;
  ok $ctx;

  is $ctx.serialize($c), "circle((0, 0), 1.0)";
  is $ctx.serialize($c.stroke), "rgb(0.3, 0.4, 0.2)";
  is $ctx.draw($c), 'draw(circle((0, 0), 1.0), rgb(0.3, 0.4, 0.2));';
  is $ctx.draw($_), 'draw(circle((1, 2), 1.0));'
                    given Circle.new: :r(1.0) :anchor(1 v 2);
  is $ctx.draw($_), 'draw(circle((1, 2), 1.0));'
                    given Circle.new: :r(1.0) :anchor(1 v 2);
  is $ctx.draw($_)
   , 'filldraw(circle((1, 2), 1.0), rgb(0.0, 0.0, 1.0), rgb(1.0, 0.0, 0.0));'
   given Circle.new: :r(1.0) :anchor(1 v 2) :fill(Blue) :stroke(Red);

  done-testing;
}

done-testing;
