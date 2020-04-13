# vim:ft=raku
use Margotu::Data::Monoid;
use Test;

plan 2;

class MyInt { ... }
class MyInt does Monoid[MyInt] is Int {
  method mempty of MyInt { MyInt.new: 0 }
  method mappend (MyInt $a) of MyInt { MyInt.new: self + $a }
}

class MyInt2 { ... }
class MyInt2 does Monoid[MyInt2] is Int {
  method mempty of MyInt2 { MyInt2.new: 0 }
  method mappend (MyInt2 $a) of MyInt2 { MyInt2.new: self + $a }
}

subtest "Test Monoid of an Integer class" => {

  plan 6;

  my MyInt $a .= new: 2;
  is $a.mempty, 0, 'Mempty as method is 0';
  is mempty($a), 0, 'Mempty as function is 0';
  is mappend($a, $a), 4, 'Mappend';
  is $a <> $a, 4, 'm+';
  is $a <> $a <> $a, 6, 'm+ chained';
  is ([<>] $a xx 100), $a * 100, '[m+]';

}

subtest "Test that two different monoids should not talk to each other" => {

  plan 13;

  my MyInt $a .= new: 2;
  my MyInt2 $b .= new: 2;

  is $b.mempty, 0         , '0 of MyInt2';
  is $b       , 2         , 'value of MyInt2';
  ok $b ~~ MyInt2         , 'Is subtype of MyInt2';
  nok $b ~~ MyInt         , 'But not of MyInt';
  ok $b ~~ Monoid[MyInt2] , 'And it is monoidal with MyInt2';
  nok $b ~~ Monoid[MyInt] , 'But not with MyInt';

  is (mempty $b)    ,    0, 'Mempty still works';
  is (mempty MyInt2),    0, 'Even with type objects';
  nok (mempty $b) ~~ MyInt, 'And it should get back the correct type';

  is $b <> $b, 4, '<> still works';
  throws-like '$a <> $b'
            , X::Syntax::InfixInTermPosition
            , 'Only with same type of Monoidal Structures'
            ;
  throws-like 'mappend $a, $b'
            , X::TypeCheck::Binding::Parameter
            , 'The same for mappend function'
            ;
  throws-like '$a.mappend($b)'
            , X::TypeCheck::Binding::Parameter
            , 'The same for mappend method'
            ;


}

done-testing;
