BEGIN {
  add = 0;
  del = 0;
}

{
  add += $1;
  del += $2;
}

END {
  printf("%d %d %d", NR, add, del);
}
