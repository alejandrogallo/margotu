sub EXPORT() {
  {
    use Margotu::Data::Canvas;
    use Margotu::Data::Drawable;
    use Margotu::Data::Monoid;
    use Margotu::Data::Point;
    use Margotu::Data::Style;
    return ::.pairs.grep(*.key ne '$_').Map;
  }
}
