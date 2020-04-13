# vim:ft=raku
use Test;
use Margotu::Data::Style;
use Margotu::Data::Canvas;
use Margotu::Data::Drawable;
use Margotu::Data::Point;

plan *;



subtest "circles" => {
  ok circle :r(2);
}

subtest "LinearPath" => {
  is-deeply $_.points
          , Array[Point].new(1 v 2, 2 v 3), "Create a 2-linear path"
          given v<1 2> -- v<2 3>;

  is-deeply $_.points
          , Array[Point].new(1 v 2, 2 v 3, v<1 0>), "Create a 3-linear path"
          given (v<1 2> -- v<2 3> -- 1vx);

  my $path = [--] v<1 2>, v<2 3>, v<4 5>;
  is .points.Int, 6, 'path -- path' given $path -- $path;
  is .points.Int, 4, 'path -- path' given $path -- v<1 2 3>;
  is .points.Int, 4, 'path -- path' given $path R-- v<1 2 3>;
  is .points.Int, 4, 'path -- path' given v<1 2 3> -- $path ;

}

subtest "Asymptote" => {
  plan *;


  my $ctx = Asymptote.new;
  ok $ctx;

  subtest "point" => {
    is $ctx.serialize(v<1 2 3>), "(1, 2)", "Serialize a point";
    is $_, "(1, 2) -- (3, 4)", "Serialize a 2-path"
       given $ctx.serialize(v<1 2> -- v<3 4>);
    is $_, "(1, 2) -- (3, 4) -- (2, 10.2)", "Serialize a 3-path"
       given $ctx.serialize(v<1 2> -- v<3 4> -- v<2 10.2>);
    is $_, "draw((1, 2) -- (3, 4) -- (2, 10.2));", "draw a 3-path"
       given $ctx.draw(v<1 2> -- v<3 4> -- v<2 10.2>);
  }

  subtest "circles" => {
    my $c = Circle.new(:r(1.0) :stroke(rgb 0.3, 0.4, 0.2));
    ok $c, 'Create a circle of unit with stroke';
    ok $c.stroke, 'Stroke exists';
    is-deeply $c.stroke, rgb 0.3, 0.4, 0.2;
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
   }

  done-testing;
}

done-testing;
