while (<>) {
  s/<date>20[0-9][0-9].[0-9][0-9].[0-9][0-9]T.*Z\.?<\/date>/<date\/>/;
  s/Date: 20[0-9][0-9].[0-9][0-9].[0-9][0-9]T.*Z\.?//;
  s/Fecha:[ ]?[0-9\-]+//;
  s/Date:[ ]?[0-9\-]+//;
  s/SAXON HE 9.*//;
  s/XSLT stylesheets version [1-9].*//;
  s/on 20[0-9][0-9].[0-9][0-9].[0-9][0-9]T.*Z\.?//;
  s/(<application.*version\s*=\s*)['"][0-9.a-z]+['"]/$1"9thisisaplaceholder88.777soisthis6666.55555thistoo4444.333lastone22"/;
  print;
}
