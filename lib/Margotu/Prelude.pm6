sub EXPORT() {
  {
    use Margotu::Data::Monoid;
    use Margotu::Data::Point;
    use Margotu::Data::Style;
    return ::.pairs.grep(*.key ne '$_').Map;
  }
}
