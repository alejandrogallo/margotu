# vim:ft=raku
use Test;
use Margotu::Data::Monoid;
use Margotu::Data::Point;

plan *;

subtest 'Point constructors', {

  ok 1 v 1, '1 v 1';
  is-deeply 1 v 2 v 3, $_, "1 v 2 v 3" given Point.new: |hash <x y z> Z=> 1,2,3;
  is-deeply 1 v 2, $_, " 1 v 2" given Point.new: |hash <x y z> Z=> 1,2,0;
  is-deeply 1.12vx  , 1.12 v 0 v 0 , '1vx';
  is-deeply 1vy     , 0 v 1 v 0    , '1vy';
  is-deeply (1/2)vz , 0 v 0 v 1/2  , '1vz';

  is-deeply Point.new([1]), 1vx, 'List constructor (1)';
  is-deeply Point.new([1,2]), 1 v 2, 'List constructor (1,2)';
  is-deeply Point.new([1,2,3]), ([<>] 1vx, 2vy, 3vz), 'List constructor (1,2,3)';

  is-deeply v(1,2,3), ([<>] 1vx, 2vy, 3vz), 'constructor circumfix v()';
  is-deeply v<1 2 3.3>, ([<>] 1vx, 2vy, 3.3vz), 'constructor prefix v';


};

subtest 'Monoidal structure', {
  plan *;
  is-deeply mempty(Point), 0 v 0 v 0;
  is-deeply mempty(1 v 2 v 3), 0 v 0 v 0;
  is-deeply ((1vx) <> (2vy)), 1 v 2, 'vx + vy';
};

subtest 'Operators', {
  plan *;
  is-deeply -(1 v 2 v 3), -1 v -2 v -3;
  is-deeply -1 v 2 v 3, -1 v  2 v  3;
  is-deeply - 1 v 2 v 3, -1 v  2 v  3;
  is-deeply -(1vz), -1vz;

  is-deeply 32 * 2vz, 64vz;
  is-deeply 2vz R* 32, 64vz;
  is-deeply 32 * (1 v 2 v 3), [v] 32 <<*<< (1,2,3);

  is-deeply 1vz * 1vz, 1;
  is-deeply 1vz * (1vx <> 1vy), 0;

  ok 1vz || 1vz, "Paralell";
  ok 1vz || 1vx, "Not Paralell";
  ok 1vz L 1vy, "Right angle";
  nok 1vz L 3vz, "Not Right angle";

  is-deeply 1vx x 1vy  , 1vz  , "i x j = k";
  is-deeply 1vx Rx 1vy , -1vz , "i Rx j = -k";
  is-deeply 1vy x 1vz  , 1vx  , "j x k = x";
  is-deeply 1vy Rx 1vz , -1vx , "j Rx k = -x";
  is-deeply 1vz x 1vx  , 1vy  , "k x i = j";
  is-deeply 1vz Rx 1vx , -1vy , "k Rx i = -j";

  is (angle 1vx, 1vy), pi/2, 'angle 1vx 1vy';
  is (angle 1vx, 1vy), pi/2, 'angle 1vx 1vy';

  is 1vx V 1vy      , pi/2 , '1vx V 1vy';
  is 1vx ∠ 100vy    , pi/2 , '1vx ∠ 100vy';
  is 1231vx.abs     , 1231 , '1vx ∠ 1vx';
  is 123vx.abs      , 123  , '1vx ∠ 1vx';
  is 1231vx ∠ 123vx , 0    , '1231vx ∠ 123vx';
  is 1231vx ∠ 0vz   , 0    , '1231vx ∠ 0vz';

};

done-testing;
