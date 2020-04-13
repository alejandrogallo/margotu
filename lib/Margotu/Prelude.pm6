sub EXPORT() {
  {
    use Margotu::Data::Monoid;
    use Margotu::Data::Point;
    return ::.pairs.grep(*.key ne '$_').Map;
  }
}
