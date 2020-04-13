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

};

done-testing;
