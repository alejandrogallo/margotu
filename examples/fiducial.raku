use Margotu::Prelude;

my $fiducial = group v<0 0> -- v<0 10>
                   , v<-5 5> -- v<5 5>
                   , circle :r(2.5) :anchor(0 v 5) :stroke(Red)
                   ;


with Asymptote.new {
  .draw($fiducial).say;
  .to-file: <fiducial.asy>;
  .open: <fiducial.asy>;
}
