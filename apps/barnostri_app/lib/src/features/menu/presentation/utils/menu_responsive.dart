int menuCrossAxisCount(double width) {
  if (width >= 1440) return 6;
  if (width >= 1200) return 5;
  if (width >= 900) return 4;
  if (width >= 600) return 3;
  if (width >= 400) return 2;
  return 1;
}
