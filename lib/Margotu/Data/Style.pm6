unit module Margotu::Data::Style;
use Margotu::Data::Monoid;

role Style is export {}

subset RgbReal of Real where 0 <= * <= 1;
class Rgb {...}
class Rgb does Style does Monoid[Rgb] is export {
  has RgbReal $.r = 0; has RgbReal $.g = 0; has RgbReal $.b = 0;
  method list { $!r, $!g, $!b }
  # Monoidal
  method mappend (Rgb $o) { Rgb.new: |hash <r g b> Z=> (self.list Z+ $o.list) }
  # Constructors
  multi method new(RgbReal :$r=0, RgbReal :$g=0, RgbReal :$b=0){
    self.bless: |hash <r g b> Z=> $r, $g, $b
  }
  multi method new(RgbReal $r, RgbReal $g, RgbReal $b){
    self.bless: |hash <r g b> Z=> $r, $g, $b
  }
  multi method new (Int $hex where * <= 0xffffff) is export {
    self.bless: |hash <b g r> Z=> (0, 8, 16).map: (0xff +& ($hex +> * ))/0xff
  }
}

sub rgb (|c) of Rgb is export { Rgb.new: |c }

constant Blue      is export = rgb 0x0000FF;
constant Grey      is export = rgb 0x808080;
constant Gray      is export = rgb 0x808080;
constant Red       is export = rgb 0xFF0000;
constant White     is export = rgb 0xFFFFFF;
constant Cyan      is export = rgb 0x00FFFF;
constant Silver    is export = rgb 0xC0C0C0;
constant Black     is export = rgb 0x000000;
constant Orange    is export = rgb 0xFFA500;
constant Purple    is export = rgb 0x800080;
constant Brown     is export = rgb 0xA52A2A;
constant Yellow    is export = rgb 0xFFFF00;
constant Maroon    is export = rgb 0x800000;
constant Lime      is export = rgb 0x00FF00;
constant Green     is export = rgb 0x008000;
constant Magenta   is export = rgb 0xFF00FF;
constant Olive     is export = rgb 0x808000;
