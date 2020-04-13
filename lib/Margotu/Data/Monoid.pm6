unit module Margotu::Data::Monoid;
=begin pod

Monoid role for main data structures

=end pod


role Monoid[::T] is export {
  method mempty of T { $?CLASS.new }
  method mappend(T $a --> T) { ... }
}

multi mempty (Monoid $a --> Monoid:D) is export { $a.mempty; }
multi mappend
(Monoid:D $a, Monoid:D $b --> Monoid:D) is export { $a.mappend($b); }
sub infix:< <> >
(Monoid:D $a, Monoid:D $b --> Monoid:D) is export is assoc<left> { $a.mappend($b) }
