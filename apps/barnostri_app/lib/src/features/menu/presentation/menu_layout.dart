int responsiveCrossAxisCount(double width) {
  if (width >= 1000) return 4;
  if (width >= 700) return 3;
  if (width >= 500) return 2;
  return 1;
}
